"""scenarios.py -- the test scenarios, their expected results, and the checker.

Each scenario is one kernel activation (one ``ap_start``), written as a list of **intents**:
a CONFIG with these taps, a PROCESS with these samples, a malformed command, END.  From the
intents this module writes the stimulus (``data/w32/<scenario>/in``) and the expected response
(``expected`` + ``expected_status.json``).  The expected response is computed from the intent
by walking it with the spec's rules and a plain per-sample float32 loop -- not by calling
``fir_eval`` or parsing the stimulus -- so it is independent of the model and the kernel.

Error activations send only the words the kernel will read (nothing queued behind the bad
command), so that co-simulation, which cannot replay unread input, can run them.

:func:`check` compares any run (model, pysim, csim, cosim) with the expected results, word for
word and TLAST for TLAST.  Two NaN words compare equal (see Assumptions in results.md).
"""
from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np

from fir import (
    WORD_BW_SUPPORTED, Float32, FirCmdHdr, FirError, FirRespHdr, MAX_SAMPLES, MAX_TAPS,
)
from waveflow.hw.arrayutils import write_array
from waveflow.utils.burst_io import StreamBurst, read_bursts, write_bursts

CONFIG, PROCESS, END = 0, 1, 2
f32 = np.float32


@dataclass(frozen=True)
class Cmd:
    """One command as intended.

    ``kind`` is the header's cmd_type (any 0..255).  ``data`` are the taps (CONFIG) or samples
    (PROCESS).  ``count`` overrides the header count (default ``len(data)``).  ``sent`` is how
    many data words the host sends (default: ``len(data)`` if the header is legal, else none);
    ``tlast`` says whether the last word sent carries TLAST.
    """

    kind: int
    tx_id: int
    data: np.ndarray = field(default_factory=lambda: np.zeros(0, f32))
    count: int | None = None
    sent: int | None = None
    tlast: bool = True

    @property
    def n(self) -> int:
        return len(self.data) if self.count is None else self.count


def cfg(tx, taps, **kw) -> Cmd:
    return Cmd(CONFIG, tx, np.asarray(taps, f32), **kw)


def proc(tx, x, **kw) -> Cmd:
    return Cmd(PROCESS, tx, np.asarray(x, f32), **kw)


def end(tx=0) -> Cmd:
    return Cmd(END, tx)


@dataclass(frozen=True)
class Scenario:
    """One activation: its commands in order (an erroring one is the last), and the stages."""

    cmds: list[Cmd]
    pysim: bool = True        # a pysim stream cannot omit TLAST
    note: str = ""


def _hdr(c: Cmd) -> np.ndarray:
    h = FirCmdHdr()
    h.cmd_type, h.tx_id = c.kind, c.tx_id
    h.ntaps = c.n if c.kind == CONFIG else 0
    h.nsamp = c.n if c.kind == PROCESS else 0
    return h.serialize(word_bw=32)


def _floats(x: np.ndarray) -> np.ndarray:
    return write_array(np.asarray(x, dtype=f32), elem_type=Float32, word_bw=32)


def _legal(c: Cmd) -> bool:
    return (c.kind == CONFIG and 1 <= c.n <= MAX_TAPS) or (c.kind == PROCESS and 1 <= c.n <= MAX_SAMPLES)


def _n_sent(c: Cmd) -> int:
    if c.kind not in (CONFIG, PROCESS) or not _legal(c):
        return 0
    return len(c.data) if c.sent is None else c.sent


def stimulus(sc: Scenario, word_bw: int = 32) -> list[StreamBurst]:
    bursts: list[StreamBurst] = []
    for c in sc.cmds:
        bursts.append(StreamBurst(_hdr(c)))
        k = _n_sent(c)
        if k:
            bursts.append(StreamBurst(_floats(c.data[:k]), c.tlast))
    return bursts


def _reference_fir(taps: list, hist: list, x: np.ndarray) -> tuple[list, list]:
    """Per-sample float32 reference.  *hist* is the newest-first list of past samples."""
    ys = []
    for xn in x:
        hist = [f32(xn)] + hist[:MAX_TAPS - 1]
        acc = f32(0.0)
        for k, h in enumerate(taps):
            acc = f32(acc + f32(h * hist[k]))
        ys.append(acc)
    return ys, hist


def _resp(tx: int, nsamp: int) -> StreamBurst:
    r = FirRespHdr()
    r.tx_id, r.nsamp = tx, nsamp
    return StreamBurst(r.serialize(word_bw=32))


def expected(sc: Scenario, word_bw: int = 32) -> tuple[list[StreamBurst], dict]:
    """The response the spec promises, from the intent alone."""
    out: list[StreamBurst] = []
    ok = {"halted": 0, "error": int(FirError.NO_ERROR), "tx_id": 0}

    def fail(err: FirError, c: Cmd) -> dict:
        return {"halted": 1, "error": int(err), "tx_id": c.tx_id}

    taps: list | None = None
    hist: list = [f32(0.0)] * (MAX_TAPS - 1)
    for c in sc.cmds:
        if c.kind not in (CONFIG, PROCESS, END):
            return out, fail(FirError.UNKNOWN_CMD, c)
        if c.kind == END:
            out.append(_resp(c.tx_id, 0))
            return out, ok
        if c.kind == PROCESS and taps is None:
            return out, fail(FirError.NO_CONFIG, c)
        if not _legal(c):
            return out, fail(FirError.BAD_COUNT, c)
        sent = _n_sent(c)
        early = sent < c.n and c.tlast          # TLAST on word sent-1, before the last
        missing = sent == c.n and not c.tlast
        if c.kind == CONFIG:
            if early:
                return out, fail(FirError.TLAST_EARLY, c)
            if missing:
                return out, fail(FirError.NO_TLAST, c)
            taps, hist = [f32(t) for t in c.data], [f32(0.0)] * (MAX_TAPS - 1)
            out.append(_resp(c.tx_id, 0))
            continue
        out.append(_resp(c.tx_id, c.n))
        ys, hist = _reference_fir(taps, hist, c.data[:sent])
        out.append(StreamBurst(_floats(np.array(ys, dtype=f32))))
        if early:
            return out, fail(FirError.TLAST_EARLY, c)
        if missing:
            return out, fail(FirError.NO_TLAST, c)
    raise ValueError("a scenario must end in END or an error")


def scenarios() -> dict[str, Scenario]:
    """Every scenario, from fixed seeds, in the order the testbench walks them."""
    rng = np.random.default_rng(7)

    def v(n: int, lo=-2.0, hi=2.0) -> np.ndarray:
        return rng.uniform(lo, hi, n).astype(f32)

    def fresh(tx: int) -> list[Cmd]:
        return [cfg(tx, v(5)), proc(tx + 1, v(20)), end(tx + 2)]

    s: dict[str, Scenario] = {}
    s["impulse"] = Scenario([cfg(1, [1, 2, 3]), proc(2, [1, 0, 0, 2]), end(3)],
                            note="h=[1,2,3], x=[1,0,0,2] -> [1,2,3,2]")
    s["carry_reconfig"] = Scenario([cfg(1, [1, 2]), proc(2, [1, 2]), proc(3, [3]),
                                    cfg(4, [2]), proc(5, [1]), end(6)],
                                   note="[1,4] then [7]; reconfig resets: [2]")
    s["ntaps_1"] = Scenario([cfg(1, [-1.5]), proc(2, v(40)), end(3)])
    s["ntaps_32"] = Scenario([cfg(1, v(32)), proc(2, v(100)), end(3)])
    s["nsamp_1"] = Scenario([cfg(1, v(7)), proc(2, v(1)), end(3)])
    s["nsamp_1024"] = Scenario([cfg(1, v(13)), proc(2, v(1024)), end(3)])
    s["few_samples"] = Scenario([cfg(1, v(32)), proc(2, v(5)), proc(3, v(3)), end(4)],
                                note="fewer samples than taps, history from zeros then carried")
    s["multi_process"] = Scenario([cfg(1, v(9)), proc(2, v(50)), proc(3, v(1)),
                                   proc(4, v(31)), proc(5, v(200)), end(6)])
    s["reconfig_ntaps"] = Scenario([cfg(1, v(8)), proc(2, v(30)), cfg(3, v(3)), proc(4, v(30)),
                                    cfg(5, v(32)), proc(6, v(64)), cfg(7, v(1)), proc(8, v(4)),
                                    end(9)], note="ntaps changes mid-activation")
    s["special_values"] = Scenario([
        cfg(1, [-1.0, np.inf, 0.5, -np.inf]),
        proc(2, [1.0, -2.0, np.nan, 3.0, 0.0, -0.0, np.inf, 1e30, -1e30, 1.0]),
        cfg(3, [np.nan, 1.0]),
        proc(4, [1.0, 2.0, 3.0]),
        cfg(5, [1e30, 1e30, -1e30]), proc(6, [1e30, 1e30, 1e30, 2.0]),
        end(7)], note="negative, NaN, infinite and overflowing values pass through")
    s["max_tx_id"] = Scenario([cfg(0xFFFF, v(2)), proc(0xFFFE, v(3)), end(0xFFFD)])
    s["timing"] = Scenario([cfg(1, v(32)), proc(2, v(1024)), end(3)],
                           note="32 taps, 1024 samples: the latency / throughput run")

    errs: list[tuple[str, Scenario]] = [
        ("unknown_cmd", Scenario([Cmd(7, 91)])),
        ("unknown_cmd_bad_count", Scenario([Cmd(200, 92, count=0)]),),
        ("process_before_config", Scenario([proc(93, v(4))])),
        ("process_before_config_bad_count", Scenario([Cmd(PROCESS, 94, count=0)])),
        ("bad_ntaps_0", Scenario([cfg(95, [], count=0)])),
        ("bad_ntaps_33", Scenario([cfg(96, v(33))])),
        ("bad_ntaps_65535", Scenario([cfg(97, [], count=65535)])),
        ("bad_nsamp_0", Scenario([cfg(1, v(3)), Cmd(PROCESS, 98, count=0)])),
        ("bad_nsamp_1025", Scenario([cfg(1, v(3)), proc(99, v(1025))])),
        ("early_tlast_cfg", Scenario([cfg(81, v(6), sent=3)])),
        ("no_tlast_cfg", Scenario([cfg(82, v(6), tlast=False)]), False),
        ("early_tlast_proc", Scenario([cfg(1, v(4)), proc(83, v(10), sent=4)])),
        ("early_tlast_proc_after_ok", Scenario([cfg(1, v(4)), proc(2, v(8)), proc(84, v(10), sent=1)])),
        ("no_tlast_proc", Scenario([cfg(1, v(4)), proc(85, v(10), tlast=False)]), False),
    ]
    for item in errs:
        name, sc = item[0], item[1]
        if len(item) > 2:
            sc = Scenario(sc.cmds, pysim=item[2])
        s[f"err_{name}"] = sc
        s[f"fresh_after_{name}"] = Scenario(fresh(100))
    return s


def write_scenarios(data_dir: Path, word_bw: int = 32) -> list[str]:
    if word_bw not in WORD_BW_SUPPORTED:
        raise ValueError(f"word_bw must be one of {WORD_BW_SUPPORTED}")
    data_dir.mkdir(parents=True, exist_ok=True)
    names = []
    for name, sc in scenarios().items():
        d = data_dir / name
        write_bursts(stimulus(sc, word_bw), d / "in")
        exp, status = expected(sc, word_bw)
        write_bursts(exp, d / "expected")
        (d / "expected_status.json").write_text(json.dumps(status) + "\n", encoding="utf-8")
        (d / "scenario.json").write_text(json.dumps({"pysim": sc.pysim, "note": sc.note}) + "\n",
                                         encoding="utf-8")
        names.append(name)
    (data_dir / "scenarios.txt").write_text("\n".join(names) + "\n", encoding="utf-8")
    return names


def _same_word(a: int, b: int, is_data: bool) -> bool:
    if a == b:
        return True
    if not is_data:
        return False
    fa, fb = np.array([a], np.uint32).view(f32)[0], np.array([b], np.uint32).view(f32)[0]
    return bool(np.isnan(fa) and np.isnan(fb))


def check(data_dir: Path, stage: str, names: list[str] | None = None) -> dict[str, list[str]]:
    """Compare ``<scenario>/<stage>`` with ``<scenario>/expected``; ``{scenario: [problems]}``.

    Words, burst boundaries, TLAST flags and the register status must match exactly (any NaN
    equals any NaN in an output-data burst)."""
    names = names or (data_dir / "scenarios.txt").read_text(encoding="utf-8").split()
    report: dict[str, list[str]] = {}
    for name in names:
        d = data_dir / name
        problems: list[str] = []
        got_dir = d / stage
        if not (got_dir / "words.bin").exists() and not (got_dir / "status.json").exists():
            report[name] = [f"no {stage} output in {got_dir}"]
            continue
        want = read_bursts(d / "expected") if (d / "expected" / "words.bin").exists() else []
        got = read_bursts(got_dir) if (got_dir / "words.bin").exists() else []
        want_st = json.loads((d / "expected_status.json").read_text(encoding="utf-8"))
        if want_st["halted"] and got and not got[-1].tlast:
            problems.append("the output burst in progress at the error was not closed with TLAST")
        if len(want) != len(got):
            problems.append(f"{len(got)} bursts, expected {len(want)}")
        for k, (w, g) in enumerate(zip(want, got)):
            if w.tlast != g.tlast:
                problems.append(f"burst {k}: tlast={g.tlast}, expected {w.tlast}")
            ww, gw = np.asarray(w.words, np.uint64), np.asarray(g.words, np.uint64)
            if len(ww) != len(gw) or not all(_same_word(int(a), int(b), True) for a, b in zip(ww, gw)):
                n = min(len(ww), len(gw))
                bad = next((i for i in range(n) if not _same_word(int(ww[i]), int(gw[i]), True)), n)
                problems.append(f"burst {k}: {len(gw)} words, expected {len(ww)}; "
                                f"first difference at word {bad}")
        st_path = got_dir / "status.json"
        if st_path.exists():
            got_st = json.loads(st_path.read_text(encoding="utf-8"))
            if got_st != want_st:
                problems.append(f"status {got_st}, expected {want_st}")
        else:
            problems.append("no status.json")
        report[name] = problems
    return report
