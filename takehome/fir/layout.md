# Wire layout (32-bit words)

Obtained by serializing instances with Waveflow (`results/layout_dump.txt`).

## Command header (2 words, no TLAST)

| Word | Bits | Field | Type |
| --- | --- | --- | --- |
| 0 | 7:0 | cmd_type (0 CONFIG, 1 PROCESS, 2 END, else unknown) | uint8 |
| 0 | 23:8 | tx_id | uint16 |
| 0 | 31:24 | unused (0) | |
| 1 | 15:0 | ntaps (CONFIG; 0 otherwise) | uint16 |
| 1 | 31:16 | nsamp (PROCESS; 0 otherwise) | uint16 |

Example PROCESS tx=0xABCD, ntaps=0x123, nsamp=0x400 -> `0x00abcd01 0x04000123`.

## Response header (1 word, TLAST on it)

| Word | Bits | Field | Type |
| --- | --- | --- | --- |
| 0 | 15:0 | tx_id (echo) | uint16 |
| 0 | 31:16 | nsamp (echo for PROCESS; 0 for CONFIG and END) | uint16 |

Example tx=0xABCD nsamp=0x400 -> `0x0400abcd`.

## Response footer

None.

## Burst words (taps in, samples in, outputs out)

One float32 per word (IEEE-754 bits, e.g. 1.0 -> `0x3f800000`). TLAST on the last word of
the burst. Taps are in order h[0]..h[ntaps-1]; samples and outputs in time order.

## Decisions

- Zero-length commands: ntaps = 0 or nsamp = 0 is BAD_COUNT (halts); no zero-length bursts exist.
- Error precedence: unknown command, then PROCESS before CONFIG, then invalid count.
- Packing: one float32 per word, no sub-word packing, no odd final word.
- Rounding/saturation: IEEE float32 multiply and add, round to nearest even, no FMA; no saturation.
- tx_id in the status: the tx_id of the failing command (0 when no error).
- Footer: none. END is answered with a response header.
