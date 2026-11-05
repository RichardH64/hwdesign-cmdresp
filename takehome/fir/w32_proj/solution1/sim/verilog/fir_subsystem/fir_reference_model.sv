//==============================================================
//Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2026.1 (64-bit)
//Tool Version Limit: 2026.06
//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//
//==============================================================

`ifndef FIR_REFERENCE_MODEL_SV
`define FIR_REFERENCE_MODEL_SV

class fir_reference_model extends uvm_component;
`define TV_IN_halted ""
`define TV_OUT_halted "../tv/rtldatafile/rtl.fir.autotvout_halted.dat"
`define TV_IN_error ""
`define TV_OUT_error "../tv/rtldatafile/rtl.fir.autotvout_error.dat"
`define TV_IN_tx_id ""
`define TV_OUT_tx_id "../tv/rtldatafile/rtl.fir.autotvout_tx_id.dat"
    bit  read_data_finish_control;
    event allaxilite_read_data_finish;
    event allsvr_input_done;
    event allsvr_output_done;
    event write_start_finish;
    int trans_num_total = 40;
    int trans_num_idx;
    int ap_done_cnt=1;
    event dut2tb_ap_ready;
    event dut2tb_ap_done;
    event ap_ready_for_nexttrans;
    event ap_done_for_nexttrans;
    event finish;
    fir_config fir_cfg;
    virtual interface misc_interface misc_if;

    mem_model_pages#(1,8) mem_blk_pages_control_halted;
    mem_model_pages#(8,8) mem_blk_pages_control_error;
    mem_model_pages#(16,8) mem_blk_pages_control_tx_id;
    int svr_s_in_delay;
    covergroup svr_s_in_cov;
        delay: coverpoint svr_s_in_delay
        {
            bins norm[2] = { [0 : 1] };
        }
    endgroup
    int svr_m_out_delay;
    covergroup svr_m_out_cov;
        delay: coverpoint svr_m_out_delay
        {
            bins norm[2] = { [0 : 1] };
        }
    endgroup
    
    `uvm_component_utils_begin(fir_reference_model)
        `uvm_field_int (trans_num_idx, UVM_DEFAULT)
    `uvm_component_utils_end

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual misc_interface)::get(this, "", "misc_if", misc_if))
            `uvm_fatal(this.get_full_name(), "No misc_if from high level")
    endfunction

    function new (string name = "", uvm_component parent = null);
        super.new (name, parent);
        svr_s_in_cov = new;
        svr_m_out_cov = new;
        trans_num_idx= 0;
    endfunction

    virtual task run_phase(uvm_phase phase);
        string fpath[$];
misc_if.dut2tb_ap_done = 0;

        mem_blk_pages_control_halted = mem_model_pages#(1,8)::type_id::create("mem_blk_pages_control_halted");
        mem_blk_pages_control_halted.init_pages(trans_num_total, 1*((1+7)/8), 16);
        mem_blk_pages_control_halted.tvoutdump_atinit(`TV_OUT_halted);


        mem_blk_pages_control_error = mem_model_pages#(8,8)::type_id::create("mem_blk_pages_control_error");
        mem_blk_pages_control_error.init_pages(trans_num_total, 1*((8+7)/8), 32);
        mem_blk_pages_control_error.tvoutdump_atinit(`TV_OUT_error);


        mem_blk_pages_control_tx_id = mem_model_pages#(16,8)::type_id::create("mem_blk_pages_control_tx_id");
        mem_blk_pages_control_tx_id.init_pages(trans_num_total, 1*((16+7)/8), 48);
        mem_blk_pages_control_tx_id.tvoutdump_atinit(`TV_OUT_tx_id);

        fork
            forever begin
                fork
                    begin
                        wait(read_data_finish_control);
                    end
                join
                `uvm_info("", "trigger_allaxilite_read_data_finish", UVM_LOW)
                @(posedge misc_if.clock);
                read_data_finish_control = 0;
                -> allaxilite_read_data_finish;
            end
            forever begin
                //this is non-pipeline case
                forever begin
                    @(negedge misc_if.clock);
                    if(misc_if.dut2tb_ap_done===1) break;
                end
                @(posedge misc_if.clock);
                @allaxilite_read_data_finish;
                @(posedge misc_if.clock);
                -> ap_ready_for_nexttrans;
                `uvm_info(this.get_full_name(), "trigger event ap_ready_for_nexttrans", UVM_LOW)
                fork
                    begin
                        misc_if.ap_ready_for_nexttrans = 1;
                        @(posedge misc_if.clock);
                        misc_if.ap_ready_for_nexttrans = 0;
                    end
                join_none
            end
            forever begin
                forever begin
                    @(negedge misc_if.clock);
                    if(misc_if.dut2tb_ap_done===1) break;
                end
                @(posedge misc_if.clock);
                fork
                    begin
                        @(negedge misc_if.clock);
                        -> misc_if.dut2tb_ap_done_evt;
                        #0;
                        -> misc_if.dut2tb_ap_ready_evt;
                    end
                join_none
                @allaxilite_read_data_finish;
                @(posedge misc_if.clock);
                -> ap_done_for_nexttrans;
                `uvm_info(this.get_full_name(), "trigger event ap_done_for_nexttrans", UVM_LOW)
                fork
                    begin
                        misc_if.ap_done_for_nexttrans = 1;
                        @(posedge misc_if.clock);
                        misc_if.ap_done_for_nexttrans = 0;
                    end
                join_none
            end

            forever begin
                forever begin
                    @(negedge misc_if.clock);
                    if (misc_if.dut2tb_ap_ready === 1)   break;
                end
                @(posedge misc_if.clock);
                `uvm_info(this.get_full_name(), "trigger event DUT2TB_AP_READY", UVM_LOW)
                -> dut2tb_ap_ready;
                 misc_if.tb2dut_ap_start = 0;
            end
            forever begin
                forever begin
                    @(negedge misc_if.clock);
                    if (misc_if.dut2tb_ap_done_kernel === 1)   break;
                end
                @(posedge misc_if.clock);
                fork
                    begin
                        @(negedge misc_if.clock);
                        `uvm_info(this.get_full_name(), "trigger event dut2tb_ap_done_kernel_evt", UVM_LOW)
                        -> misc_if.dut2tb_ap_done_kernel_evt;
                    end
                join_none
            end
        join
    endtask

    virtual function void write_svr_master_s_in(svr_transfer#(41) tr);
    //  trans_size++;
        svr_s_in_delay = tr.delay;
        svr_s_in_cov.sample();
        `uvm_info(this.get_full_name(), "port a collected one pkt", UVM_DEBUG);
    endfunction

    virtual function void write_svr_slave_m_out(svr_transfer#(41) tr);
    //  trans_size++;
        svr_m_out_delay = tr.delay;
        svr_m_out_cov.sample();
        `uvm_info(this.get_full_name(), "port a collected one pkt", UVM_DEBUG);
    endfunction

    virtual function void write_axi_wtr_control(axi_pkg::axi_transfer tr);
        if(tr.addr == 0 && tr.len == 0 && tr.data[0][0]==1) begin //addr 0 and bit 0 are parameter
            -> write_start_finish;
            misc_if.tb2dut_ap_start = 1;
        end
    endfunction
    virtual function void write_axi_rtr_control(axi_pkg::axi_transfer tr);
            `uvm_info("receive axi read data", tr.sprint(), UVM_HIGH)
        if(tr.addr == 0 && tr.len == 0) begin
            if(tr.data[0][1]==1) begin  //bit 1 is parameter
                `uvm_info("status polling", "ap_done is polled", UVM_LOW);
                fork
                    begin
                        misc_if.dut2tb_ap_done = 1;
                        @(posedge misc_if.clock);
                        #0;
                        misc_if.dut2tb_ap_done = 0;
                        misc_if.tb2dut_ap_continue = 0;
                        -> dut2tb_ap_done;
                    end
                join_none
            end
            begin
                misc_if.dut2tb_ap_idle = tr.data[0][2];
            end
        end else begin
            mem_blk_pages_control_halted.write_elems_frontpage(tr.data, tr.byte_addr);
            mem_blk_pages_control_error.write_elems_frontpage(tr.data, tr.byte_addr);
            mem_blk_pages_control_tx_id.write_elems_frontpage(tr.data, tr.byte_addr);
        end
    endfunction
endclass
`endif
