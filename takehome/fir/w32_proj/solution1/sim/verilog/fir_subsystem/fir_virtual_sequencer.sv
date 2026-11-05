//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2026.1 (64-bit)
//Tool Version Limit: 2026.06
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef FIR_VIRTUAL_SEQUENCER__SV                        
    `define FIR_VIRTUAL_SEQUENCER__SV                    
                                                                       
    class fir_virtual_sequencer extends uvm_sequencer;         
        svr_master_sequencer#(41) svr_port_s_in_sqr;
        svr_slave_sequencer#(41) svr_port_m_out_sqr;
        axi_pkg::axi_virtual_sequencer control_sqr; 
 
        function new (string name, uvm_component parent);              
            super.new(name, parent);                                   
            //`uvm_info(this.get_full_name(), "new is called", UVM_LOW)
        endfunction                                                    
                                                                       
        `uvm_component_utils_begin(fir_virtual_sequencer)      
        `uvm_component_utils_end                                       
                                                                       
    endclass

`endif
