// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2026.1 (64-bit)
// Tool Version Limit: 2026.06
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================

extern "C" void AESL_WRAP_fir (
hls::stream<struct ap_axis<32, 0, 0, 0 > > (&s_in),
hls::stream<struct ap_axis<32, 0, 0, 0 > > (&m_out),
volatile void* halted,
volatile void* error,
volatile void* tx_id);
