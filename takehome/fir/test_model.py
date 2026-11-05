"""test_model.py -- the Python model against the hand-computed examples and np.convolve;
and the checker rejecting wrong outputs.  Output goes to results/model_tests.log."""
import json, shutil, tempfile
from pathlib import Path
import numpy as np
from fir import fir_eval, fir_stream_model, zero_history
import scenarios as S
from waveflow.utils.burst_io import read_bursts, write_bursts, StreamBurst

f = np.float32
def run(h, x, hist=None): return fir_eval(h, x, hist)

def main():
    r = []
    y, _ = run([1, 2, 3], [1, 0, 0, 2]); r.append(("impulse [1,2,3]*[1,0,0,2]", y.tolist() == [1, 2, 3, 2], y.tolist()))
    y1, hs = run([1, 2], [1, 2]); y2, _ = run([1, 2], [3], hs)
    r.append(("carry-over [1,4] then [7]", y1.tolist() == [1, 4] and y2.tolist() == [7], [y1.tolist(), y2.tolist()]))
    y3, _ = run([2], [1], zero_history()); r.append(("reconfig [2]", y3.tolist() == [2], y3.tolist()))
    rng = np.random.default_rng(3); worst = 0.0
    for n_taps in (1, 2, 7, 32):
        for n in (1, 5, 300, 1024):
            h = rng.uniform(-1, 1, n_taps).astype(f); x = rng.uniform(-1, 1, n).astype(f)
            ref = np.convolve(x.astype(np.float64), h.astype(np.float64))[:n]
            y, _ = run(h, x)
            worst = max(worst, float(np.max(np.abs(y - ref) / np.maximum(np.abs(ref), 1e-3))))
            ok = np.allclose(y, ref, rtol=1e-5, atol=1e-5)
            r.append((f"np.convolve ntaps={n_taps} n={n}", ok, ""))
    # split stream == one stream
    h = rng.uniform(-1, 1, 11).astype(f); x = rng.uniform(-1, 1, 90).astype(f)
    whole, _ = run(h, x); a, hs = run(h, x[:37]); b, _ = run(h, x[37:], hs)
    r.append(("split stream == whole (bit exact)", np.array_equal(np.concatenate([a, b]).view(np.uint32), whole.view(np.uint32)), ""))
    # checker rejections
    root = Path("results/checker_rejects"); shutil.rmtree(root, ignore_errors=True)
    S.write_scenarios(root, 32)
    for name in ("impulse", "err_early_tlast_proc"):
        d = root / name; res = fir_stream_model(read_bursts(d / "in")); write_bursts(res.out, d / "bad")
        (d / "bad" / "status.json").write_text(json.dumps(res.status()))
    # wrong 1: one output off by one ulp
    d = root / "impulse"; bad = read_bursts(d / "bad"); bad[2].words[2] ^= 1
    write_bursts(bad, d / "bad")
    # wrong 2: error path does not halt
    d = root / "err_early_tlast_proc"; (d / "bad" / "status.json").write_text(json.dumps({"halted": 0, "error": 0, "tx_id": 0}))
    rep = S.check(root, "bad", ["impulse", "err_early_tlast_proc"])
    r.append(("checker rejects 1-ulp wrong output", bool(rep["impulse"]), rep["impulse"]))
    r.append(("checker rejects error path that does not halt", bool(rep["err_early_tlast_proc"]), rep["err_early_tlast_proc"]))
    shutil.rmtree(root)
    lines = [f"{'PASS' if ok else 'FAIL'}  {n}  {d}" for n, ok, d in r]
    lines.append(f"worst relative error vs np.convolve: {worst:.3e}")
    Path("results").mkdir(exist_ok=True); Path("results/model_tests.log").write_text("\n".join(lines) + "\n")
    print("\n".join(lines)); assert all(ok for _, ok, _ in r)
main()
