# FIR filter -- results

Frame: Waveflow `stream_inband` (host-launched kernel, AXI-Stream in/out, AXI-Lite status; chosen
because the prompt names it and asks for ap_start/status registers and Vitis csim/cosim).
Part xc7z020clg484-1, clock target 10 ns, Vitis HLS 2026.1 (installed; the frame text says 2025.1).
Everything is in `fir/`; rebuild with `python fir_build.py --force --through summary` (log: `build_log.txt`).
Last run: run 2, prompt version 2 (see Run History).

## Interface

Stream words are 32 bits (`in_bw = out_bw = 32`); full layouts in `layout.md` (from
`results/layout_dump.txt`).

- **Command header** (2 words): word0 = `cmd_type[7:0]`, `tx_id[23:8]`; word1 = `ntaps[15:0]`, `nsamp[31:16]`.
  `cmd_type`: CONFIG 0, PROCESS 1, END 2, anything else is an unknown command.
- **CONFIG**: header (ntaps), then ntaps float32 taps h[0]..h[N-1], one per word, TLAST on the last.
  Response: header only, sent after all taps are read.
- **PROCESS**: header (nsamp), then nsamp float32 samples, TLAST on the last. Response: header
  (`tx_id[15:0]`, `nsamp[31:16]`, TLAST), sent before processing, then nsamp float32 outputs, TLAST on the last.
- **END**: header only; response is a header (tx_id, nsamp = 0); the kernel returns with status clear.
- **Status registers (AXI-Lite, read-only)**: `halted` 0x10, `error` 0x20, `tx_id` 0x30
  (from `w32_proj/solution1/syn/report/csynth.rpt`). Cleared at the start of each activation. Nothing else is written over AXI-Lite.
- **Error codes** (`error`): 0 NO_ERROR, 1 UNKNOWN_CMD, 2 NO_CONFIG (PROCESS before CONFIG),
  3 BAD_COUNT (ntaps not 1..32 / nsamp not 1..1024), 4 TLAST_EARLY (taps or samples), 5 NO_TLAST (taps or samples).
  `tx_id` register = tx_id of the failing command.

## Design

- State lives in registers inside the kernel body, local to one activation: `taps[32]`, the
  sample window `win[32]` (`win[k]` = x[n-k]), `ntaps`, and a `configured` flag. All arrays are completely partitioned.
- Loops: a command loop (read header, check, dispatch); a CONFIG tap loop (II = 1); a PROCESS sample loop over nsamp
  (`VITIS_LOOP_139_5`, `#pragma HLS PIPELINE II=1`) that per iteration reads a sample, shifts the window,
  evaluates the 32-term chain and writes one output.
- Chain: 32 multipliers (`taps[k]*win[k]`) and 32 adders in summation order k = 0..31, starting from
  +0.0f; each multiply and add is a separate statement (no FMA, no reordering). Terms with k >= ntaps are skipped
  by a select on the adder output, not multiplied by zero. Vitis pipelines the loop (depth 197) so a new sample enters each clock.
- Early TLAST in PROCESS sets a `stop` flag (loop-carried, one-cycle) rather than breaking, so the loop stays at II = 1; the
  iteration with the early TLAST still writes its output with TLAST, and later iterations neither read nor write.
- CONFIG resets the window to 0 and replaces the taps; the window carries across PROCESS commands.

## Targets

| Target | Required | Measured | Result | Source |
|---|---|---|---|---|
| Sample-loop II | 1 | 1 (`VITIS_LOOP_139_5`, iteration latency 197) | PASS | `results/loop_df_w32.csv`, `results/synth/fir_csynth.rpt` |
| Throughput (co-sim) | 1 output/clock steady state | 1.000 cycles/output: timing (1024 samples) 1273 vs ntaps_32 (100 samples) 349 cycles -> (1273-349)/(1024-100) = 1.00 | PASS | `results/cosim/transactions.txt`, `results/cosim/transaction_index.txt` |
| Latency (co-sim), `timing` activation (CONFIG 32 taps, PROCESS 1024, END) | no target | 1273 cycles (interval 1287); fixed overhead 249 cycles (32 tap reads, headers, 197-deep pipeline fill) | no target | `results/cosim/transactions.txt` (transaction 11), `results/cosim/fir_cosim.rpt` |
| Estimated clock | < 10 ns | 7.432 ns (uncertainty 2.70 ns) | PASS | `results/synth/fir_csynth.rpt` |
| Resources | no target | BRAM 0, DSP 160 (72%), FF 21011 (19%), LUT 28498 (53%), URAM 0 | no target | `results/resources_w32.json`, `results/synth/csynth.rpt` |
| Taps 1..32, nsamp 1..1024 | supported | scenarios ntaps_1/32, nsamp_1/1024 pass in C sim and co-sim | PASS | `results/check_csim.json`, `results/check_cosim.json` |
| C sim / co-sim vs model | bit for bit, except NaN outputs (only need to be NaN in both) | all 40 scenarios agree: non-NaN words identical, NaN words are NaN in both (`special_values` NaN words differ in sign bit only, allowed by prompt v2) | PASS | `results/check_csim.json`, `results/check_cosim.json`, `data/w32/*/{model,csim,cosim}` |

`csynth.rpt` also prints "Timing" as the issue type with slack -0.13 ns for the top; Vitis emits this because the
7.432 ns estimate exceeds the 7.3 ns budget left after the 2.7 ns clock-uncertainty margin
(`logs/hls_run_tcl.log`, HLS 200-871). The prompt (v2) says a slack warning from the clock-uncertainty margin is not a failure, so it is not a FAIL.

## Verification

- Hand-computed examples and `np.convolve` (relative tolerance 1e-5, absolute 1e-5 near zero), split-stream equality, and the checker
  rejecting a 1-ulp wrong output and an error path that does not halt: all PASS, `results/model_tests.log` (from `test_model.py`).
- Each row below compares the recorded output to the expected response computed from the scenario intent
  (`scenarios.py`): `results/check_model.json`, `check_pysim.json`, `check_csim.json`, `check_cosim.json`.
  Co-sim ran all 40 scenarios in a single `cosim_design` run (`results/cosim/fir_cosim.rpt`, 40 transactions, status Pass).
  Error scenarios send only the words the kernel reads; each is followed by its own fresh activation (CONFIG, PROCESS, END).
  pysim cannot omit TLAST, so the two missing-TLAST scenarios and their expected statuses are n/a for pysim.

| Scenario | Model | pysim | C sim | Co-sim | model=csim=cosim bitwise | Status set (cosim) | Fresh activation after |
|---|---|---|---|---|---|---|---|
| `impulse` | PASS | PASS | PASS | PASS | yes | none |  |
| `carry_reconfig` | PASS | PASS | PASS | PASS | yes | none |  |
| `ntaps_1` | PASS | PASS | PASS | PASS | yes | none |  |
| `ntaps_32` | PASS | PASS | PASS | PASS | yes | none |  |
| `nsamp_1` | PASS | PASS | PASS | PASS | yes | none |  |
| `nsamp_1024` | PASS | PASS | PASS | PASS | yes | none |  |
| `few_samples` | PASS | PASS | PASS | PASS | yes | none |  |
| `multi_process` | PASS | PASS | PASS | PASS | yes | none |  |
| `reconfig_ntaps` | PASS | PASS | PASS | PASS | yes | none |  |
| `special_values` | PASS | PASS | PASS | PASS | yes (NaN words: NaN in all) | none |  |
| `max_tx_id` | PASS | PASS | PASS | PASS | yes | none |  |
| `timing` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_unknown_cmd` | PASS | PASS | PASS | PASS | yes | halted=1 UNKNOWN_CMD tx_id=91 | `fresh_after_unknown_cmd`: PASS |
| `fresh_after_unknown_cmd` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_unknown_cmd_bad_count` | PASS | PASS | PASS | PASS | yes | halted=1 UNKNOWN_CMD tx_id=92 | `fresh_after_unknown_cmd_bad_count`: PASS |
| `fresh_after_unknown_cmd_bad_count` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_process_before_config` | PASS | PASS | PASS | PASS | yes | halted=1 NO_CONFIG tx_id=93 | `fresh_after_process_before_config`: PASS |
| `fresh_after_process_before_config` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_process_before_config_bad_count` | PASS | PASS | PASS | PASS | yes | halted=1 NO_CONFIG tx_id=94 | `fresh_after_process_before_config_bad_count`: PASS |
| `fresh_after_process_before_config_bad_count` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_bad_ntaps_0` | PASS | PASS | PASS | PASS | yes | halted=1 BAD_COUNT tx_id=95 | `fresh_after_bad_ntaps_0`: PASS |
| `fresh_after_bad_ntaps_0` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_bad_ntaps_33` | PASS | PASS | PASS | PASS | yes | halted=1 BAD_COUNT tx_id=96 | `fresh_after_bad_ntaps_33`: PASS |
| `fresh_after_bad_ntaps_33` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_bad_ntaps_65535` | PASS | PASS | PASS | PASS | yes | halted=1 BAD_COUNT tx_id=97 | `fresh_after_bad_ntaps_65535`: PASS |
| `fresh_after_bad_ntaps_65535` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_bad_nsamp_0` | PASS | PASS | PASS | PASS | yes | halted=1 BAD_COUNT tx_id=98 | `fresh_after_bad_nsamp_0`: PASS |
| `fresh_after_bad_nsamp_0` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_bad_nsamp_1025` | PASS | PASS | PASS | PASS | yes | halted=1 BAD_COUNT tx_id=99 | `fresh_after_bad_nsamp_1025`: PASS |
| `fresh_after_bad_nsamp_1025` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_early_tlast_cfg` | PASS | PASS | PASS | PASS | yes | halted=1 TLAST_EARLY tx_id=81 | `fresh_after_early_tlast_cfg`: PASS |
| `fresh_after_early_tlast_cfg` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_no_tlast_cfg` | PASS | n/a | PASS | PASS | yes | halted=1 NO_TLAST tx_id=82 | `fresh_after_no_tlast_cfg`: PASS |
| `fresh_after_no_tlast_cfg` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_early_tlast_proc` | PASS | PASS | PASS | PASS | yes | halted=1 TLAST_EARLY tx_id=83 | `fresh_after_early_tlast_proc`: PASS |
| `fresh_after_early_tlast_proc` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_early_tlast_proc_after_ok` | PASS | PASS | PASS | PASS | yes | halted=1 TLAST_EARLY tx_id=84 | `fresh_after_early_tlast_proc_after_ok`: PASS |
| `fresh_after_early_tlast_proc_after_ok` | PASS | PASS | PASS | PASS | yes | none |  |
| `err_no_tlast_proc` | PASS | n/a | PASS | PASS | yes | halted=1 NO_TLAST tx_id=85 | `fresh_after_no_tlast_proc`: PASS |
| `fresh_after_no_tlast_proc` | PASS | PASS | PASS | PASS | yes | none |  |

## Assumptions

Prompt v2 now states the header layout, cmd_type values, response-header contents, error codes, the tolerance (rtol 1e-5 + atol 1e-5),
the NaN rule, and that error activations send nothing after the failing command; those are no longer assumptions (see Interface).
Remaining choices where the prompt is silent or ambiguous:

- `cmd_type` is a uint8 field (not a Waveflow enum, which cannot carry an unknown value); `ntaps` and `nsamp` are uint16.
- END is answered with a header (tx_id, nsamp = 0) and the kernel returns with status clear.
- `tx_id` status register = tx_id of the failing command.
- A CONFIG error leaves nothing sent; the old state is irrelevant because the kernel halts.
- Because error activations send nothing after the bad command, "no data after a bad header is read" holds by construction in co-sim and is not tested with queued data behind the header.
- NaN: x86 (model, C sim) gives `0xffc00000` for invalid operations (inf-inf, 0*inf); RTL gives `0x7fc00000`. The checker (`scenarios.py`) treats any NaN as equal to any NaN and
  everything else (words, TLAST, burst boundaries, status) exactly. This is the rule in prompt v2. NaN inputs propagate as NaN. Denormal handling is not tested separately.
- The prompt's "- - -" in the early-TLAST-in-PROCESS bullet and "n unknown command type" are read as typos.
- Pysim (not required by the prompt) is kept as a functional check only; its timing seeds in `fir.py` are scaffold defaults and are not used or reported.
- Tool version: Vitis HLS 2026.1 (the installed one; the prompt does not name a version). Python 3.12 venv with `~/waveflow` installed was used to drive the build.
- The process document asks to stop for review after Stage 1; the task asked for the full build in one go, so Stage 1 and 2 were done together.

## Open Items

- Slack in `csynth.rpt` for the top is -0.13 ns against the 7.3 ns budget left after the 2.7 ns uncertainty (HLS 200-871); not a FAIL under prompt v2.
- Error-path scenarios do not test queued data behind a bad header (co-sim cannot replay unread input; prompt v2 accepts this).
- Otherwise none. Run 1's open items are closed: the NaN rule is now in the prompt; the Python timing model is not required; unused scaffold files were deleted in run 2
  (`fir_figures.py`, `fir_calibrate.py`, `timing_analysis.py`, and the unused `ExtractPyTimingStep` / `ErrorVcdStep` classes in `fir_build.py`).

## Run History

| Run | Prompt version | What was built / changed | What passed |
|---|---|---|---|
| 1 | 1 | Scaffolded `stream_inband` as `fir`; FIR schemas, `fir_eval`, `fir_stream_model`, 40 scenarios, C++ body (32-term chain, II=1), testbench, build DAG (32-bit only) | model, pysim, C sim, co-sim (40/40 vs expected; NaN sign note), synthesis: II 1, 7.432 ns, DSP 160 |
| 2 | 2 | Read prompt v2: no kernel change needed (NaN rule already what the checker implements, header/codes already matched). Deleted unused scaffold files and dead build steps; rewrote Assumptions/Open Items/Targets to v2; forced a full rebuild (`--force`): model, pysim, csim, csynth, cosim | model, pysim, C sim, co-sim 40/40 (NaN rule), synthesis II 1, 7.432 ns (< 10 ns), latency 1273 cycles for the timing activation, DSP 160; results identical to run 1 |
