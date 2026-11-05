# FIR Filter

Build a Vitis HLS kernel in this folder following the Waveflow stream_inband
example (https://sdrangan.github.io/waveflow/docs/examples/stream_inband/) and
the command-response pattern.

## Operation
A direct-form FIR filter:

y[n] = h[0]·x[n] + h[1]·x[n−1] + ... + h[N−1]·x[n−N+1]

The taps h and the number of taps N come from a CONFIG command. The samples x and their count nsamp come from a PROCESS command. Taps, samples and outputs are all float32.

The N terms are added starting from zero, with the most recent sample first: h[0]·x[n], then h[1]·x[n−1], and so on down to h[N−1]·x[n−N+1]. Each multiply and each add is rounded to float32. No fused multiply-add and no reordering of the sum is allowed, so the model and the kernel match bit for bit.

After a CONFIG, 0 is used for any previous samples that have not arrived yet. The last N−1 input samples are stored and carried over from one PROCESS command to the next, so splitting a stream across several PROCESS commands gives the same outputs as sending it in one. A new CONFIG replaces the taps in the filter (N may change) and resets the stored samples to 0.

One output comes back for each input sample, so a PROCESS with nsamp samples returns exactly nsamp outputs. There are no extra outputs at the end for the last N−1 samples.

## Requirements
Taps, samples and outputs are float32, one per 32-bit stream word. The hardware must handle up to 32 taps (N <= 32), which sets the size of the tap buffer and the stored samples, and up to 1024 samples per PROCESS command (nsamp <= 1024).

The throughput target is one output per clock in steady state (II = 1 on the sample loop). To reach it, the filter is a fully parallel pipeline: one multiplier and one adder per tap, chained in the summation order from the Operation section, with registers between stages, so a new sample enters every clock while earlier outputs are still moving through the chain. The pipeline is built for 32 taps. When N < 32, the terms with k >= N are skipped, not multiplied by zero, so the result is identical to summing only the N real terms. There is no resource target; report the usage from synthesis.

The clock target is an estimated clock under 10 ns. A slack warning caused by the clock-uncertainty margin is not a failure.

No Python timing model is required. Delete any scaffold files the build does not use.

## Commands and parameters
Every command starts with a header carrying the command type and a tx_id, an unsigned ID the host picks for each command. Each response header echoes that tx_id so the host can match responses to commands.

The command header is two 32-bit words. Word 0 holds cmd_type in bits 7:0 and tx_id in bits 23:8. Word 1 holds ntaps in bits 15:0 and nsamp in bits 31:16. cmd_type is CONFIG = 0, PROCESS = 1, END = 2, and any other value is an unknown command. The count a command does not use is 0.

- CONFIG: the header also carries ntaps, the number of taps. It is followed by a burst of ntaps float32 taps, with TLAST on the last one. The response is a header only, with no data, sent after all the taps have been read.
- PROCESS: the header also carries nsamp, the number of samples. It is followed by a burst of nsamp float32 samples, with TLAST on the last one. The response is a header echoing tx_id and nsamp, sent before the samples are processed, then nsamp outputs, with TLAST on the last output.
- END: header only. The response is a header only. The kernel then returns. 

Every response header carries tx_id and nsamp. nsamp is 0 for CONFIG and END.

ntaps and nsamp are unsigned. ntaps must be 1 to 32 and nsamp must be 1 to 1024. Any other value is invalid, and these are checked before any data is read. nsamp does not need to relate to ntaps; a PROCESS with fewer samples than taps is normal. Negative, NaN and infinite taps or samples are not errors and pass through the float math unchanged.

## Errors
Errors go in AXI-Lite status registers (halted, error code, tx_id).  On an
error the kernel closes any output burst it started with TLAST and returns
without reading more input.  Nothing persists between activations: the status
registers are cleared at the start of each one.

The errors are:

- n unknown command type
- a PROCESS before any CONFIG in the activation
- an invalid count: ntaps not 1 to 32, or nsamp not 1 to 1024
- a TLAST that arrives early, before the last word of a tap or sample burst
- a missing TLAST on the last word of a tap or sample burst

If a header has more than one problem, the error reported is the first in this order: unknown command, then PROCESS before CONFIG, then invalid count.

What is sent before each error is reported:

- Header errors (unknown command, PROCESS before CONFIG, invalid count): nothing is sent for that command, and no data after the header is read.
- Early or missing TLAST in a CONFIG burst: nothing is sent for that command, since its response comes after the taps.
- Early TLAST in a PROCESS burst: the response header and the outputs for the earlier samples have already been sent. The sample that carries the early TLAST is still - - - processed, and its output is written with TLAST, closing the burst. This follows stream_inband.
- Missing TLAST in a PROCESS burst: all nsamp outputs have been sent, and the kernel puts TLAST on the last one itself.

The error codes are 0 NO_ERROR, 1 UNKNOWN_CMD, 2 NO_CONFIG, 3 BAD_COUNT, 4 TLAST_EARLY and 5 NO_TLAST. TLAST_EARLY and NO_TLAST are shared by tap and sample bursts; the host tells them apart by the failing command's tx_id.

## Verification
The Python model is checked against these hand-computed examples:

- Impulse: h = [1, 2, 3], x = [1, 0, 0, 2] gives [1, 2, 3, 2].
- Carry-over: h = [1, 2]. PROCESS with [1, 2] gives [1, 4], then PROCESS with [3] gives [7].
- Reconfig: after that, CONFIG with h = [2], then PROCESS with [1] gives [2], since the stored samples were reset.

The model is also checked against np.convolve of all samples since the last CONFIG, cut to the input length. NumPy computes in float64 and in its own order, so this comparison uses a relative tolerance of 1e-5 plus an absolute tolerance of 1e-5. The bit-exact comparison is between the model, C simulation and co-simulation.

All non-NaN outputs must match bit for bit. A NaN output only has to be a NaN in both, since the NaN's sign and payload are not defined by IEEE float and differ between x86 and the FPGA.

The scenarios cover: ntaps = 1 and 32; nsamp = 1 and 1024; a PROCESS with fewer samples than taps; several PROCESS commands in a row; a CONFIG with a different ntaps in the middle of an activation; and one activation for each error, each followed by a fresh activation that must pass. Error activations send nothing after the failing command, since co-simulation cannot replay unread input.

Compare the model, C simulation and co-simulation bit for bit, apart from NaN outputs, as above.  Run
co-simulation once: one testbench run that walks through every scenario in
order, calling the kernel once per activation with fresh streams, including
each error activation and the fresh activation after it.

## results.md
Write results.md with these sections:
- Interface: the command and response layouts, how values pack into words,
  the status registers and the error codes.
- Design: the loop structure, where state is kept, and how the throughput
  target is reached.
- Targets: each target above with the required value, the measured value,
  PASS/FAIL and the file it came from (co-simulation for timing; synthesis
  for clock, II and resources).  Always report the latency and throughput
  from co-simulation and the estimated clock and resources from synthesis,
  writing "no target" where this prompt sets none.
- Verification: the model's check against the hand-computed examples and the
  reference; then one row per scenario saying whether the model, C simulation
  and co-simulation agree, and for each error scenario the status it set and
  whether the fresh activation after it passed. Name the source file of each.
- Assumptions: every place this prompt was silent or ambiguous and what you
  chose, apart from interface details already given under Interface.
- Open Items: questions you could not settle, and anything that failed or was
  not done, or "None".
- Run History: one row per run, with the prompt version, what was built or
  changed, and what passed, so that a later run can continue from here.

Every number and PASS/FAIL in Targets and Verification names the file it came
from (a log, a comparison output or a synthesis report), and that file stays in
this folder to be committed: a reviewer opens them to check results.md.

## Revision history
| Version | Change | Why |
| --- | --- | --- |
| 1 | First version | Initial specification |
| 2 | NaN outputs only need to be NaN; everything else bit for bit | Run 1: RTL and x86 give NaNs with different sign bits (assumption 6, open item 1); I kept its choice |
| 2 | Tolerance, header layout, codes, error codes, tool version and staging written in; no Python timing model; slack warning is not a failure | Run 1 assumptions 1 to 5 and 7 to 9, open items 2 and 3 |
