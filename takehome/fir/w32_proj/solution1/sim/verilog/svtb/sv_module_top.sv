//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2026.1 (64-bit)
//Tool Version Limit: 2026.06
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef SV_MODULE_TOP_SV
`define SV_MODULE_TOP_SV


`timescale 1ns/1ps


`include "uvm_macros.svh"
import uvm_pkg::*;
import file_agent_pkg::*;
import svr_pkg::*;
import fir_subsystem_pkg::*;
`include "fir_subsys_test_sequence_lib.sv"
`include "fir_test_lib.sv"


module sv_module_top;


    misc_interface              misc_if ( .clock(apatb_fir_top.AESL_clock), .reset(apatb_fir_top.AESL_reset) );
    assign misc_if.tb2dut_ap_start_kernel = apatb_fir_top.AESL_inst_fir.ap_start;
    assign misc_if.dut2tb_ap_ready = apatb_fir_top.AESL_inst_fir.ap_ready;
    assign misc_if.dut2tb_ap_done_kernel = apatb_fir_top.AESL_inst_fir.ap_done;
    initial begin
        uvm_config_db #(virtual misc_interface)::set(null, "uvm_test_top.top_env.*", "misc_if", misc_if);
    end


    svr_if #(41)  svr_s_in_if    (.clk  (apatb_fir_top.AESL_clock), .rst(apatb_fir_top.AESL_reset));
    assign svr_s_in_if.ready = apatb_fir_top.s_in_TREADY;
    assign apatb_fir_top.s_in_TVALID = svr_s_in_if.valid;
    assign apatb_fir_top.s_in_TDATA = svr_s_in_if.data[31:0];
    assign apatb_fir_top.s_in_TKEEP = svr_s_in_if.data[35:32];
    assign apatb_fir_top.s_in_TSTRB = svr_s_in_if.data[39:36];
    assign apatb_fir_top.s_in_TLAST = svr_s_in_if.data[40:40];
    initial begin
        uvm_config_db #( virtual svr_if#(41) )::set(null, "uvm_test_top.top_env.env_master_svr_s_in.*", "vif", svr_s_in_if);
    end


    svr_if #(41)  svr_m_out_if    (.clk  (apatb_fir_top.AESL_clock), .rst(apatb_fir_top.AESL_reset));
    assign apatb_fir_top.m_out_TREADY = svr_m_out_if.ready;
    assign svr_m_out_if.valid = apatb_fir_top.m_out_TVALID;
    assign svr_m_out_if.data[31:0] = apatb_fir_top.m_out_TDATA;
    assign svr_m_out_if.data[35:32] = apatb_fir_top.m_out_TKEEP;
    assign svr_m_out_if.data[39:36] = apatb_fir_top.m_out_TSTRB;
    assign svr_m_out_if.data[40:40] = apatb_fir_top.m_out_TLAST;
    initial begin
        uvm_config_db #( virtual svr_if#(41) )::set(null, "uvm_test_top.top_env.env_slave_svr_m_out.*", "vif", svr_m_out_if);
    end


    axi_if #(6,4,4,3,1)  axi_control_if (.clk  (apatb_fir_top.AESL_clock), .rst(apatb_fir_top.AESL_reset));
    assign apatb_fir_top.control_AWADDR = axi_control_if.AWADDR;
    assign apatb_fir_top.control_AWVALID = axi_control_if.AWVALID;
    assign axi_control_if.AWREADY = apatb_fir_top.control_AWREADY;
    assign apatb_fir_top.control_WVALID = axi_control_if.WVALID;
    assign axi_control_if.WREADY = apatb_fir_top.control_WREADY;
    assign apatb_fir_top.control_WDATA = axi_control_if.WDATA;
    assign apatb_fir_top.control_WSTRB = axi_control_if.WSTRB;
    assign apatb_fir_top.control_ARADDR = axi_control_if.ARADDR;
    assign apatb_fir_top.control_ARVALID = axi_control_if.ARVALID;
    assign axi_control_if.ARREADY = apatb_fir_top.control_ARREADY;
    assign axi_control_if.RVALID = apatb_fir_top.control_RVALID;
    assign apatb_fir_top.control_RREADY = axi_control_if.RREADY;
    assign axi_control_if.RDATA = apatb_fir_top.control_RDATA;
    assign axi_control_if.RRESP = apatb_fir_top.control_RRESP;
    assign axi_control_if.BVALID = apatb_fir_top.control_BVALID;
    assign apatb_fir_top.control_BREADY = axi_control_if.BREADY;
    assign axi_control_if.BRESP = apatb_fir_top.control_BRESP;
    assign axi_control_if.BID = 0;
    assign axi_control_if.RID = 0;
    assign axi_control_if.RLAST = 1;
    initial begin
        uvm_config_db #( virtual axi_if#(6,4,4,3,1) )::set(null, "uvm_test_top.top_env.axi_lite_control.*", "vif", axi_control_if);
    end


    initial begin
        run_test();
    end
endmodule
`endif
