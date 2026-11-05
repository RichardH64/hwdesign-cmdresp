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
| `special_values` | PASS | PASS | PASS | PASS | NaN sign only | none |  |
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
