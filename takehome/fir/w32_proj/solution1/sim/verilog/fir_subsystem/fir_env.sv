//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2026.1 (64-bit)
//Tool Version Limit: 2026.06
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================
`ifndef FIR_ENV__SV                                                                                   
    `define FIR_ENV__SV                                                                               
                                                                                                                    
                                                                                                                    
    class fir_env extends uvm_env;                                                                          
                                                                                                                    
        fir_virtual_sequencer fir_virtual_sqr;                                                      
        fir_config fir_cfg;                                                                         
                                                                                                                    
        svr_pkg::svr_env#(41) env_master_svr_s_in;
        svr_pkg::svr_env#(41) env_slave_svr_m_out;
        axi_pkg::axi_env#(6,4,4,3,1) axi_lite_control;
                                                                                                                    
        fir_reference_model   refm;                                                                         
                                                                                                                    
        fir_subsystem_monitor subsys_mon;                                                                   
                                                                                                                    
        `uvm_component_utils_begin(fir_env)                                                                 
        `uvm_field_object (env_master_svr_s_in,  UVM_DEFAULT | UVM_REFERENCE)
        `uvm_field_object (env_slave_svr_m_out,  UVM_DEFAULT | UVM_REFERENCE)
        `uvm_field_object (refm, UVM_DEFAULT | UVM_REFERENCE)                                                       
        `uvm_field_object (fir_virtual_sqr, UVM_DEFAULT | UVM_REFERENCE)                                    
        `uvm_field_object (fir_cfg        , UVM_DEFAULT)                                                    
        `uvm_component_utils_end                                                                                    
                                                                                                                    
        function new (string name = "fir_env", uvm_component parent = null);                              
            super.new(name, parent);                                                                                
        endfunction                                                                                                 
                                                                                                                    
        extern virtual function void build_phase(uvm_phase phase);                                                  
        extern virtual function void connect_phase(uvm_phase phase);                                                
        extern virtual task          run_phase(uvm_phase phase);                                                    
                                                                                                                    
    endclass                                                                                                        
                                                                                                                    
    function void fir_env::build_phase(uvm_phase phase);                                                    
        super.build_phase(phase);                                                                                   
        fir_cfg = fir_config::type_id::create("fir_cfg", this);                           
                                                                                                                    
        fir_cfg.port_s_in_cfg.svr_type = svr_pkg::SVR_MASTER ;
        env_master_svr_s_in  = svr_env#(41)::type_id::create("env_master_svr_s_in", this);
        uvm_config_db#(svr_pkg::svr_config)::set(this, "env_master_svr_s_in*", "cfg", fir_cfg.port_s_in_cfg);
        fir_cfg.port_s_in_cfg.prt_type = svr_pkg::AXIS;
        fir_cfg.port_s_in_cfg.is_active = svr_pkg::SVR_ACTIVE;
        fir_cfg.port_s_in_cfg.spec_cfg = svr_pkg::NORMAL;
        fir_cfg.port_s_in_cfg.reset_level = svr_pkg::RESET_LEVEL_LOW;
 
        fir_cfg.port_m_out_cfg.svr_type = svr_pkg::SVR_SLAVE ;
        env_slave_svr_m_out  = svr_env#(41)::type_id::create("env_slave_svr_m_out", this);
        uvm_config_db#(svr_pkg::svr_config)::set(this, "env_slave_svr_m_out*", "cfg", fir_cfg.port_m_out_cfg);
        fir_cfg.port_m_out_cfg.prt_type = svr_pkg::AXIS;
        fir_cfg.port_m_out_cfg.is_active = svr_pkg::SVR_ACTIVE;
        fir_cfg.port_m_out_cfg.spec_cfg = svr_pkg::NORMAL;
        fir_cfg.port_m_out_cfg.reset_level = svr_pkg::RESET_LEVEL_LOW;
 

        fir_cfg.control_cfg.set_default();
        fir_cfg.control_cfg.drv_type = axi_pkg::MASTER;
        fir_cfg.control_cfg.reset_level = axi_pkg::RESET_LEVEL_LOW;
        uvm_config_db#(axi_pkg::axi_cfg)::set(this, "axi_lite_control*", "cfg", fir_cfg.control_cfg);
        axi_lite_control = axi_pkg::axi_env#(6,4,4,3,1)::type_id::create("axi_lite_control", this);



        refm = fir_reference_model::type_id::create("refm", this);


        uvm_config_db#(fir_reference_model)::set(this, "*", "refm", refm);


        `uvm_info(this.get_full_name(), "set reference model by uvm_config_db", UVM_LOW)


        subsys_mon = fir_subsystem_monitor::type_id::create("subsys_mon", this);


        fir_virtual_sqr = fir_virtual_sequencer::type_id::create("fir_virtual_sqr", this);
        `uvm_info(this.get_full_name(), "build_phase done", UVM_LOW)
    endfunction


    function void fir_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);


        fir_virtual_sqr.svr_port_s_in_sqr = env_master_svr_s_in.m_agt.sqr;
        env_master_svr_s_in.m_agt.mon.item_collect_port.connect(subsys_mon.svr_master_s_in_imp);
 
        fir_virtual_sqr.svr_port_m_out_sqr = env_slave_svr_m_out.s_agt.sqr;
        env_slave_svr_m_out.s_agt.mon.item_collect_port.connect(subsys_mon.svr_slave_m_out_imp);
 
        if(fir_cfg.control_cfg.drv_type==axi_pkg::MASTER ||fir_cfg.control_cfg.drv_type==axi_pkg::SLAVE)
            fir_virtual_sqr.control_sqr = axi_lite_control.vsqr;
        axi_lite_control.item_wtr_port.connect(subsys_mon.control_wtr_imp);
        axi_lite_control.item_rtr_port.connect(subsys_mon.control_rtr_imp);
        refm.fir_cfg = fir_cfg;
        `uvm_info(this.get_full_name(), "connect phase done", UVM_LOW)
    endfunction


    task fir_env::run_phase(uvm_phase phase);
        `uvm_info(this.get_full_name(), "fir_env is running", UVM_LOW)
    endtask


`endif
