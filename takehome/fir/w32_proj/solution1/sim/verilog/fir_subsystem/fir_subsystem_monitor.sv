//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2026.1 (64-bit)
//Tool Version Limit: 2026.06
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef FIR_SUBSYSTEM_MONITOR_SV
`define FIR_SUBSYSTEM_MONITOR_SV

`uvm_analysis_imp_decl(_svr_master_s_in)
`uvm_analysis_imp_decl(_svr_slave_m_out)
`uvm_analysis_imp_decl(_axi_wtr_control)
`uvm_analysis_imp_decl(_axi_rtr_control)

class fir_subsystem_monitor extends uvm_component;

    fir_reference_model refm;
    fir_scoreboard scbd;

    `uvm_component_utils_begin(fir_subsystem_monitor)
    `uvm_component_utils_end

    uvm_analysis_imp_svr_master_s_in#(svr_pkg::svr_transfer#(41), fir_subsystem_monitor) svr_master_s_in_imp;
    uvm_analysis_imp_svr_slave_m_out#(svr_pkg::svr_transfer#(41), fir_subsystem_monitor) svr_slave_m_out_imp;
    uvm_analysis_imp_axi_wtr_control#(axi_pkg::axi_transfer, fir_subsystem_monitor) control_wtr_imp;
    uvm_analysis_imp_axi_rtr_control#(axi_pkg::axi_transfer, fir_subsystem_monitor) control_rtr_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(fir_reference_model)::get(this, "", "refm", refm))
            `uvm_fatal(this.get_full_name(), "No refm from high level")
        `uvm_info(this.get_full_name(), "get reference model by uvm_config_db", UVM_MEDIUM)
        scbd = fir_scoreboard::type_id::create("scbd", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    function new (string name = "", uvm_component parent = null);
        super.new(name, parent);
        svr_master_s_in_imp = new("svr_master_s_in_imp", this);
        svr_slave_m_out_imp = new("svr_slave_m_out_imp", this);
        control_wtr_imp = new("control_wtr_imp", this);
        control_rtr_imp = new("control_rtr_imp", this);
    endfunction

    virtual function void write_svr_master_s_in(svr_transfer#(41) tr);
        refm.write_svr_master_s_in(tr);
        scbd.write_svr_master_s_in(tr);
    endfunction

    virtual function void write_svr_slave_m_out(svr_transfer#(41) tr);
        refm.write_svr_slave_m_out(tr);
        scbd.write_svr_slave_m_out(tr);
    endfunction

    virtual function void write_axi_wtr_control(axi_transfer tr);
        refm.write_axi_wtr_control(tr);
        scbd.write_axi_wtr_control(tr);
    endfunction

    virtual function void write_axi_rtr_control(axi_transfer tr);
        refm.write_axi_rtr_control(tr);
        scbd.write_axi_rtr_control(tr);
    endfunction
endclass
`endif
