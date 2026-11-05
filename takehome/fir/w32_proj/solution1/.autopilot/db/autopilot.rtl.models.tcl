set SynModuleInfo {
  {SRCNAME write_axi4_stream<32> MODELNAME write_axi4_stream_32_s RTLNAME fir_write_axi4_stream_32_s}
  {SRCNAME fir_Pipeline_VITIS_LOOP_139_5 MODELNAME fir_Pipeline_VITIS_LOOP_139_5 RTLNAME fir_fir_Pipeline_VITIS_LOOP_139_5
    SUBMODULES {
      {MODELNAME fir_fadd_32ns_32ns_32_5_full_dsp_1 RTLNAME fir_fadd_32ns_32ns_32_5_full_dsp_1 BINDTYPE op TYPE fadd IMPL fulldsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME fir_fmul_32ns_32ns_32_4_max_dsp_1 RTLNAME fir_fmul_32ns_32ns_32_4_max_dsp_1 BINDTYPE op TYPE fmul IMPL maxdsp LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME fir_flow_control_loop_pipe_sequential_init RTLNAME fir_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME fir_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME fir_Pipeline_VITIS_LOOP_104_3 MODELNAME fir_Pipeline_VITIS_LOOP_104_3 RTLNAME fir_fir_Pipeline_VITIS_LOOP_104_3}
  {SRCNAME fir MODELNAME fir RTLNAME fir IS_TOP 1
    SUBMODULES {
      {MODELNAME fir_control_s_axi RTLNAME fir_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
      {MODELNAME fir_regslice_both RTLNAME fir_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
    }
  }
}
