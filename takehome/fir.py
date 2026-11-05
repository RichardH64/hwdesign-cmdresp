"""fir.py -- the streaming FIR accelerator (CONFIG / PROCESS / END), written hook-first.

What is in this file, in the order a reader needs it:

1. **Schemas** -- the command header (command type, tx_id, ntaps, nsamp), the response header
   and the error codes.  Waveflow generates their C++ headers and serializers; nothing packs
   words by hand.  The taps and the samples are float32 bursts, one per 32-bit word, moved with
   the Waveflow array utilities.
2. **The bit-exact model** -- pure functions with no simulator in them:
   :func:`fir_eval` (the arithmetic, float32, in the C++ operation order, with the carried
   history) and :func:`fir_stream_model` (the whole protocol over a stream of bursts, TLAST rules
   and errors included).  This is what the C++ kernel is checked against, bit for bit.
3. **The module** -- :class:`FirAccel` declares the ports and the status-only register map and
   names its kernel body (``cpp_body = "body"``).  The Python :meth:`FirAccel.body` is the same
   kernel for pysim: a port wrapper around :func:`fir_eval`, plus a timing model.
4. **The pysim testbench** -- :class:`FirTB`.

The scenarios, their independently computed expected outputs, and the checker are in
``scenarios.py``; the build that runs everything is ``fir_build.py``.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from enum import IntEnum
from pathlib import Path
from typing import ClassVar

import numpy as np
import numpy.typing as npt

from waveflow.hw.arrayutils import array, read_array, write_array
from waveflow.hw.clock import Clock
from waveflow.hw.dataschema import DataList, EnumField, FloatField, IntField
from waveflow.hw.hw_hostactivated import HostActivated
from waveflow.hw.hw_module import HwParam
from waveflow.hw.interface import StreamIF, StreamIFMaster, StreamIFSlave
from waveflow.hw.irq import IrqIF, IrqIFSink
from waveflow.hw.timed_phase import TimedPhase
from waveflow.hw.memif import DirectMMIF, MMIFMaster
from waveflow.hw.regmap import (
    Bit,
    RegAccess,
    RegField,
    VitisRegMap,
    VitisRegMapMMIFSlave,
)
from waveflow.simulation.logger import Logger, NullLogger
from waveflow.simulation.simobj import ProcessGen, SimObj
from waveflow.simulation.simulation import Simulation
from waveflow.utils.burst_io import StreamBurst, read_bursts

# ---------------------------------------------------------------------------
# 1. Schemas
# ---------------------------------------------------------------------------

INCLUDE_DIR = "include"
WORD_BW_SUPPORTED = [32]
MAX_TAPS = 32
MAX_SAMPLES = 1024
TxIdField = IntField.specialize(bitwidth=16, signed=False)
CountField = IntField.specialize(bitwidth=16, signed=False)
#: 8 bits, not an enum field: an unknown command type must be expressible on the wire.
CmdTypeField = IntField.specialize(bitwidth=8, signed=False)
Float32 = FloatField.specialize(bitwidth=32, include_dir=INCLUDE_DIR)


class FirError(IntEnum):
    """What the kernel reports in its ``error`` register when it halts."""
    NO_ERROR = 0
    UNKNOWN_CMD = 1        # cmd_type is not CONFIG, PROCESS or END
    NO_CONFIG = 2          # PROCESS before any CONFIG in this activation
    BAD_COUNT = 3          # ntaps not 1..32, or nsamp not 1..1024
    TLAST_EARLY = 4        # TLAST before the last word of a tap or sample burst
    NO_TLAST = 5           # no TLAST on the last word of a tap or sample burst

FirErrorField = EnumField.specialize(enum_type=FirError)


class FirCmdType(IntEnum):
    CONFIG = 0
    PROCESS = 1
    END = 2


class FirCmdHdr(DataList):
    """Command header.  ``ntaps`` is meaningful on CONFIG, ``nsamp`` on PROCESS; the other
    count is sent as zero and ignored.  END sends both as zero."""
    elements = {
        "cmd_type": {"schema": CmdTypeField, "description": "0 CONFIG, 1 PROCESS, 2 END"},
        "tx_id":    {"schema": TxIdField,    "description": "Command ID: echoed, or reported on error"},
        "ntaps":    {"schema": CountField,   "description": "Number of taps (CONFIG), 1..32"},
        "nsamp":    {"schema": CountField,   "description": "Number of samples (PROCESS), 1..1024"},
    }


class FirRespHdr(DataList):
    """Response header: echo of tx_id and of nsamp (0 for the CONFIG and END responses)."""
    elements = {
        "tx_id": {"schema": TxIdField,  "description": "Echo of the transaction ID"},
        "nsamp": {"schema": CountField, "description": "Echo of nsamp (PROCESS); 0 otherwise"},
    }


SCHEMA_CLASSES = [
    FirErrorField,
    FirCmdHdr,
    FirRespHdr,
]

# ---------------------------------------------------------------------------
# 2. The bit-exact model (pure functions)
# ---------------------------------------------------------------------------

#: Samples kept from one PROCESS to the next: the window of the 32-tap pipeline, less the new one.
HIST_LEN = MAX_TAPS - 1


def zero_history() -> npt.NDArray[np.float32]:
    return np.zeros(HIST_LEN, dtype=np.float32)


def fir_eval(taps: npt.ArrayLike, x: npt.ArrayLike, hist: npt.ArrayLike | None = None
             ) -> tuple[npt.NDArray[np.float32], npt.NDArray[np.float32]]:
    """``y[n] = h[0]x[n] + h[1]x[n-1] + ... + h[N-1]x[n-N+1]`` in float32.

    Bit-exact to the C++ body: for each output the sum starts at +0.0f and adds the products
    ``h[0]*x[n]``, ``h[1]*x[n-1]``, ... in that order, each multiply and each add rounded to
    float32 (no fused multiply-add, no reordering).  Only the N real terms are added.  *hist*
    holds the last 31 samples before ``x`` (oldest first; zeros after a CONFIG); the function
    returns ``(y, new_hist)`` with ``len(y) == len(x)``.
    """
    h = np.asarray(taps, dtype=np.float32)
    xs = np.asarray(x, dtype=np.float32)
    hist = zero_history() if hist is None else np.asarray(hist, dtype=np.float32)
    xp = np.concatenate([hist, xs])             # xp[HIST_LEN + n] is x[n]
    n = len(xs)
    acc = np.zeros(n, dtype=np.float32)
    for k in range(len(h)):                     # the chain: term k adds h[k] * x[n-k]
        lo = HIST_LEN - k
        prod = (h[k] * xp[lo:lo + n]).astype(np.float32)
        acc = (acc + prod).astype(np.float32)
    return acc, xp[len(xp) - HIST_LEN:].copy()


@dataclass
class FirStreamResult:
    """What the kernel does to one stream: its output bursts and its final register status."""

    out: list[StreamBurst]
    halted: int = 0
    error: int = int(FirError.NO_ERROR)
    tx_id: int = 0

    def status(self) -> dict[str, int]:
        return {"halted": self.halted, "error": self.error, "tx_id": self.tx_id}


def fir_stream_model(bursts: list[StreamBurst], word_bw: int = 32) -> FirStreamResult:
    """One activation of the kernel, as a pure function of its input stream.

    Word by word, what ``fir_body_impl.tpp`` does:

    - the status starts clear and nothing is configured;
    - read a command header (a fixed number of words; the header read does not inspect TLAST);
    - checks on the header, in order: unknown command, PROCESS before CONFIG, invalid count.
      Any of them halts, writes nothing for the command and reads no more;
    - END: write the response header and return;
    - CONFIG: read ``ntaps`` words (TLAST early / missing halts, with nothing written), keep
      the taps, zero the history, write the response header;
    - PROCESS: write the response header, then for each sample word write one output; the word
      that completes ``nsamp`` -- or carries an early TLAST -- gets TLAST on its output.  The
      history carries across commands.
    """
    if word_bw not in WORD_BW_SUPPORTED:
        raise ValueError(f"word_bw must be one of {WORD_BW_SUPPORTED}, got {word_bw}")
    words = [(int(w), i + 1 == len(b.words) and b.tlast)
             for b in bursts for i, w in enumerate(np.asarray(b.words, dtype=np.uint64))]
    hdr_words = FirCmdHdr().serialize(word_bw=word_bw).size
    out: list[tuple[int, bool]] = []
    res = FirStreamResult(out=[])
    taps: npt.NDArray[np.float32] | None = None
    hist = zero_history()
    pos = 0

    def respond(tx_id: int, nsamp: int) -> None:
        r = FirRespHdr()
        r.tx_id, r.nsamp = tx_id, nsamp
        rw = r.serialize(word_bw=word_bw)
        out.extend((int(w), i + 1 == rw.size) for i, w in enumerate(rw))

    def halt(err: FirError, tx_id: int) -> None:
        res.halted, res.error, res.tx_id = 1, int(err), int(tx_id)

    while True:
        if pos + hdr_words > len(words):
            raise ValueError("the stimulus ends before an END command: the kernel would block")
        hdr = FirCmdHdr().deserialize([w for w, _ in words[pos:pos + hdr_words]], word_bw=word_bw)
        pos += hdr_words
        cmd, tx = int(hdr.cmd_type), int(hdr.tx_id)
        if cmd not in set(int(c) for c in FirCmdType):
            halt(FirError.UNKNOWN_CMD, tx)
            break
        if cmd == FirCmdType.END:
            respond(tx, 0)
            break
        if cmd == FirCmdType.PROCESS and taps is None:
            halt(FirError.NO_CONFIG, tx)
            break
        count, limit = ((int(hdr.ntaps), MAX_TAPS) if cmd == FirCmdType.CONFIG
                        else (int(hdr.nsamp), MAX_SAMPLES))
        if not 1 <= count <= limit:
            halt(FirError.BAD_COUNT, tx)
            break

        if cmd == FirCmdType.CONFIG:
            new = np.zeros(count, dtype=np.float32)
            err = FirError.NO_ERROR
            for j in range(count):
                if pos >= len(words):
                    raise ValueError("the stimulus ends inside a tap burst: the kernel would block")
                w, last = words[pos]
                pos += 1
                new[j] = read_array([w], elem_type=Float32, word_bw=word_bw, shape=1).val[0]
                if last and j + 1 < count:
                    err = FirError.TLAST_EARLY
                    break
                if j + 1 == count and not last:
                    err = FirError.NO_TLAST
            if err != FirError.NO_ERROR:
                halt(err, tx)
                break
            taps, hist = new, zero_history()
            respond(tx, 0)
            continue

        respond(tx, count)
        err = FirError.NO_ERROR
        for i in range(count):
            if pos >= len(words):
                raise ValueError("the stimulus ends inside a sample burst: the kernel would block")
            w, last = words[pos]
            pos += 1
            x = read_array([w], elem_type=Float32, word_bw=word_bw, shape=1).val
            y, hist = fir_eval(taps, x, hist)
            yw = write_array(y, elem_type=Float32, word_bw=word_bw)
            final = i + 1 == count
            out.append((int(yw[0]), final or last))
            if last and not final:
                err = FirError.TLAST_EARLY
                break
            if final and not last:
                err = FirError.NO_TLAST
        if err != FirError.NO_ERROR:
            halt(err, tx)
            break

    cur: list[int] = []
    for w, last in out:
        cur.append(w)
        if last:
            res.out.append(StreamBurst(np.array(cur, dtype=np.uint64), True))
            cur = []
    if cur:
        res.out.append(StreamBurst(np.array(cur, dtype=np.uint64), False))
    return res


# ---------------------------------------------------------------------------
# 3. The module: ports, register map, and the kernel body
# ---------------------------------------------------------------------------


@dataclass
class FirAccel(HostActivated):
    """The FIR accelerator: a body-only kernel.

    Waveflow generates ``gen/fir.hpp`` / ``gen/fir.cpp`` -- the prototype, every interface
    pragma, and one call ``fir_impl::body(s_in, m_out, halted, error, tx_id)`` -- and the whole
    kernel is the hand-written ``fir_body_impl.tpp``.  The register map holds only status.
    """

    cpp_kernel_name: ClassVar[str | None] = "fir"
    cpp_namespace:   ClassVar[str | None] = "fir_impl"
    cpp_body:        ClassVar[str | None] = "body"

    in_bw:        HwParam[int] = 32
    out_bw:       HwParam[int] = 32
    aximm_bw:     HwParam[int] = 32
    clk:          Clock = field(default_factory=lambda: Clock(freq=1e9))
    # The timing model's seeds (pysim only): the first result proc_latency cycles after the first
    # sample word, then one word per proc_ii cycles.
    proc_ii:      int = 1
    proc_latency: int = 40
    logger:       Logger | NullLogger = field(default_factory=NullLogger)
    unroll_factor: int = 1

    def __post_init__(self) -> None:
        super().__post_init__()
        self.s_in  = StreamIFSlave( name=f'{self.name}_s_in',  sim=self.sim, bitwidth=self.in_bw)
        self.m_out = StreamIFMaster(name=f'{self.name}_m_out', sim=self.sim, bitwidth=self.out_bw)
        self.regmap = VitisRegMap({
            "halted": RegField(Bit,            RegAccess.R, description="1 = halted on error"),
            "error":  RegField(FirErrorField, RegAccess.R, description="Error code (FirError)"),
            "tx_id":  RegField(TxIdField,      RegAccess.R, description="tx_id of the failed command"),
        }, bitwidth=self.aximm_bw)
        self.s_lite = VitisRegMapMMIFSlave(
            name=f'{self.name}_s_lite', sim=self.sim, bitwidth=self.aximm_bw,
            regmap=self.regmap, on_start=self.on_start,
        )
        for ep in (self.s_in, self.m_out, self.s_lite):
            self.add_endpoint(ep)
        self._job: int = 0
        cal = Path(__file__).resolve().parent / "calib" / f"w{int(self.in_bw)}"
        self.hdr_phase = TimedPhase(
            "hdr", spans={"resp_time": (self.s_in.last, self.m_out.first)},
            seed={"resp_time": {"intercept": 0.0}}, calib_dir=cal / "hdr")
        self.samp_phase = TimedPhase(
            "samples", spans={"latency": (self.s_in.first, self.m_out.first),
                              "fill_time": (self.m_out.first, self.m_out.last)},
            features=("nwords",),
            seed={"latency": {"intercept": float(self.proc_latency), "nwords": 0.0},
                  "fill_time": {"intercept": 0.0,
                                "nwords": float(self.proc_ii) / self.unroll_factor}},
            calib_dir=cal / "samples")
        for ph in (self.hdr_phase, self.samp_phase):
            self.add_timing_phase(ph)

    def _halt(self, err: FirError, tx_id: int) -> None:
        self.regmap.set("error", int(err))
        self.regmap.set("tx_id", tx_id)
        self.regmap.set("halted", 1)

    def _respond(self, wait, resp_hdr: "FirRespHdr") -> ProcessGen[None]:
        yield wait
        yield from self.m_out.write(resp_hdr)

    def body(self) -> ProcessGen[None]:
        """The kernel for pysim: the port wrapper around :func:`fir_eval`, plus timing."""
        self.logger.log(event='proc_begin', job=self._job)
        for f in ("halted", "error", "tx_id"):
            self.regmap.set(f, 0)
        taps = None
        hist = zero_history()
        while True:
            cmd_hdr: FirCmdHdr = yield from self.s_in.get_schema(FirCmdHdr)
            cmd, tx = int(cmd_hdr.cmd_type), int(cmd_hdr.tx_id)
            err = None
            if cmd not in set(int(c) for c in FirCmdType):
                err = FirError.UNKNOWN_CMD
            elif cmd == FirCmdType.END:
                resp = FirRespHdr()
                resp.tx_id, resp.nsamp = tx, 0
                yield from self.m_out.write(resp)
                self.logger.log(event='proc_end', job=self._job)
                return
            elif cmd == FirCmdType.PROCESS and taps is None:
                err = FirError.NO_CONFIG
            else:
                count, limit = ((int(cmd_hdr.ntaps), MAX_TAPS) if cmd == FirCmdType.CONFIG
                                else (int(cmd_hdr.nsamp), MAX_SAMPLES))
                if not 1 <= count <= limit:
                    err = FirError.BAD_COUNT
            if err is not None:
                self._halt(err, tx)
                self.logger.log(event='proc_end', job=self._job)
                return

            resp_hdr = FirRespHdr()
            resp_hdr.tx_id = tx
            if cmd == FirCmdType.CONFIG:
                words = yield from self.s_in.get(nwords_max=count)
                if len(words) < count:
                    self._halt(FirError.TLAST_EARLY, tx)
                    self.logger.log(event='proc_end', job=self._job)
                    return
                taps = read_array(words, elem_type=Float32, word_bw=32, shape=count).val
                hist = zero_history()
                resp_hdr.nsamp = 0
                yield self.hdr_phase.timeout()
                yield from self.m_out.write(resp_hdr)
                self._job += 1
                continue

            resp_hdr.nsamp = count
            resp = self.env.process(self._respond(self.hdr_phase.timeout(), resp_hdr))
            load = self.s_in.get_array(Float32, count)
            store = self.m_out.write_array(Float32, count)
            state = {"hist": hist}

            def compute(x, taps=taps, state=state):
                y, state["hist"] = fir_eval(taps, x.val, state["hist"])
                return array(Float32, y)

            r = yield from self.samp_phase.pipeline(compute, load=load, store=store,
                                                    nwords=load.nwords())
            yield resp
            hist = state["hist"]
            self._job += 1
            if len(r.y.val) < count:            # TLAST came early: halt, read nothing more
                self._halt(FirError.TLAST_EARLY, tx)
                self.logger.log(event='proc_end', job=self._job)
                return


# ---------------------------------------------------------------------------
# 4. The pysim testbench
# ---------------------------------------------------------------------------

#: What the status registers hold before a run (rule 5): both testbenches poison them.
POISONED_STATUS = {"halted": 1, "error": int(FirError.NO_TLAST), "tx_id": 0xFFFF}


@dataclass(kw_only=True)
class FirTB(SimObj):
    """Plays a scenario's stimulus file into :class:`FirAccel` and records the response.

    One kernel run: poison the status registers, start the kernel and sleep until its
    ``ap_done`` interrupt, while two other processes push the stimulus and collect the response.
    After an error, whatever the kernel left unread stays in the input channel (the host's
    reset).  A pysim stream cannot omit TLAST, so missing-TLAST scenarios skip pysim.
    """

    stimulus:  Path
    n_out:     int
    word_bw:   int = 32
    base_addr: int = 0x0

    def __post_init__(self) -> None:
        super().__post_init__()
        self.m_in   = StreamIFMaster(name=f'{self.name}_m_in',   sim=self.sim, bitwidth=self.word_bw)
        self.s_out  = StreamIFSlave( name=f'{self.name}_s_out',  sim=self.sim, bitwidth=self.word_bw)
        self.m_lite = MMIFMaster(    name=f'{self.name}_m_lite', sim=self.sim, bitwidth=32)
        self.irq    = IrqIFSink(     name=f'{self.name}_irq',    sim=self.sim)
        self.out: list[StreamBurst] = []
        self.status: dict[str, int] = {}
        self._regmap_ref: VitisRegMap | None = None

    def run_proc(self) -> ProcessGen[None]:
        for f, v in POISONED_STATUS.items():
            self._regmap().set(f, v)
        rm = self._regmap().bind_master(self.m_lite, base_addr=self.base_addr)
        reader = self.env.process(self._read_all())
        self.env.process(self._write_all())
        yield from rm.run(self.irq)
        yield reader
        for f in ("halted", "error", "tx_id"):
            self.status[f] = int((yield from rm.get(f)))

    def _write_all(self) -> ProcessGen[None]:
        for b in read_bursts(self.stimulus):
            yield from self.m_in.write(np.asarray(b.words, dtype=np.uint32))

    def _read_all(self) -> ProcessGen[None]:
        for _ in range(self.n_out):
            words = yield from self.s_out.get()
            self.out.append(StreamBurst(np.asarray(words, dtype=np.uint64), True))

    def _regmap(self) -> VitisRegMap:
        if self._regmap_ref is None:
            raise RuntimeError("FirTB._regmap_ref is unset; call connect() before run_sim().")
        return self._regmap_ref


def connect(sim: Simulation, tb: FirTB, accel: FirAccel, clk: Clock) -> None:
    """Wire the testbench to the accelerator: two streams, AXI-Lite, and the interrupt line."""
    in_stream  = StreamIF(sim=sim, clk=clk)
    out_stream = StreamIF(sim=sim, clk=clk)
    lite_link  = DirectMMIF(sim=sim, clk=clk, byte_addressable=True)
    irq        = IrqIF(name=f'{accel.name}_irq', sim=sim)
    in_stream.bind( "master", tb.m_in)
    in_stream.bind( "slave",  accel.s_in)
    out_stream.bind("master", accel.m_out)
    out_stream.bind("slave",  tb.s_out)
    lite_link.bind( "master", tb.m_lite)
    lite_link.bind( "slave",  accel.s_lite)
    irq.bind("source", accel.s_lite.interrupt())
    irq.bind("sink",   tb.irq)
    tb._regmap_ref = accel.regmap
