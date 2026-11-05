set moduleName fir
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set restart_counter_num 0
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 6
set C_modelName {fir}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ s_in_V_data_V int 32 regular {axi_s 0 volatile  { s_in Data } }  }
	{ s_in_V_keep_V int 4 regular {axi_s 0 volatile  { s_in Keep } }  }
	{ s_in_V_strb_V int 4 regular {axi_s 0 volatile  { s_in Strb } }  }
	{ s_in_V_last_V int 1 regular {axi_s 0 volatile  { s_in Last } }  }
	{ m_out_V_data_V int 32 regular {axi_s 1 volatile  { m_out Data } }  }
	{ m_out_V_keep_V int 4 regular {axi_s 1 volatile  { m_out Keep } }  }
	{ m_out_V_strb_V int 4 regular {axi_s 1 volatile  { m_out Strb } }  }
	{ m_out_V_last_V int 1 regular {axi_s 1 volatile  { m_out Last } }  }
	{ halted int 1 regular {axi_slave 1}  }
	{ error int 8 regular {axi_slave 1}  }
	{ tx_id int 16 regular {axi_slave 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "s_in_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "s_in_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "s_in_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "s_in_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "m_out_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "halted", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 1, "direction" : "WRITEONLY", "offset" : {"out":16}, "offset_end" : {"out":23}} , 
 	{ "Name" : "error", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 8, "direction" : "WRITEONLY", "offset" : {"out":32}, "offset_end" : {"out":39}} , 
 	{ "Name" : "tx_id", "interface" : "axi_slave", "bundle":"control","type":"ap_vld","bitwidth" : 16, "direction" : "WRITEONLY", "offset" : {"out":48}, "offset_end" : {"out":55}} ]}
# RTL Port declarations: 
set portNum 32
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ s_in_TDATA sc_in sc_lv 32 signal 0 } 
	{ s_in_TVALID sc_in sc_logic 1 invld 3 } 
	{ s_in_TREADY sc_out sc_logic 1 inacc 3 } 
	{ s_in_TKEEP sc_in sc_lv 4 signal 1 } 
	{ s_in_TSTRB sc_in sc_lv 4 signal 2 } 
	{ s_in_TLAST sc_in sc_lv 1 signal 3 } 
	{ m_out_TDATA sc_out sc_lv 32 signal 4 } 
	{ m_out_TVALID sc_out sc_logic 1 outvld 7 } 
	{ m_out_TREADY sc_in sc_logic 1 outacc 7 } 
	{ m_out_TKEEP sc_out sc_lv 4 signal 5 } 
	{ m_out_TSTRB sc_out sc_lv 4 signal 6 } 
	{ m_out_TLAST sc_out sc_lv 1 signal 7 } 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"fir","role":"start","value":"0","valid_bit":"0"},{"name":"fir","role":"continue","value":"0","valid_bit":"4"},{"name":"fir","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"fir","role":"start","value":"0","valid_bit":"0"},{"name":"fir","role":"done","value":"0","valid_bit":"1"},{"name":"fir","role":"idle","value":"0","valid_bit":"2"},{"name":"fir","role":"ready","value":"0","valid_bit":"3"},{"name":"fir","role":"auto_start","value":"0","valid_bit":"7"},{"name":"halted","role":"data","value":"16"}, {"name":"halted","role":"valid","value":"20","valid_bit":"0"},{"name":"error","role":"data","value":"32"}, {"name":"error","role":"valid","value":"36","valid_bit":"0"},{"name":"tx_id","role":"data","value":"48"}, {"name":"tx_id","role":"valid","value":"52","valid_bit":"0"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "s_in_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_in_V_data_V", "role": "default" }} , 
 	{ "name": "s_in_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "s_in_V_last_V", "role": "default" }} , 
 	{ "name": "s_in_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "s_in_V_last_V", "role": "default" }} , 
 	{ "name": "s_in_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "s_in_V_keep_V", "role": "default" }} , 
 	{ "name": "s_in_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "s_in_V_strb_V", "role": "default" }} , 
 	{ "name": "s_in_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_in_V_last_V", "role": "default" }} , 
 	{ "name": "m_out_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "m_out_V_data_V", "role": "default" }} , 
 	{ "name": "m_out_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "m_out_V_last_V", "role": "default" }} , 
 	{ "name": "m_out_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "m_out_V_last_V", "role": "default" }} , 
 	{ "name": "m_out_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m_out_V_keep_V", "role": "default" }} , 
 	{ "name": "m_out_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m_out_V_strb_V", "role": "default" }} , 
 	{ "name": "m_out_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_out_V_last_V", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	fir {
		s_in_V_data_V {Type I LastRead 2 FirstWrite -1}
		s_in_V_keep_V {Type I LastRead 2 FirstWrite -1}
		s_in_V_strb_V {Type I LastRead 2 FirstWrite -1}
		s_in_V_last_V {Type I LastRead 2 FirstWrite -1}
		m_out_V_data_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_keep_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_strb_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_last_V {Type O LastRead -1 FirstWrite 0}
		halted {Type O LastRead -1 FirstWrite 7}
		error {Type O LastRead -1 FirstWrite 7}
		tx_id {Type O LastRead -1 FirstWrite 7}}
	write_axi4_stream_32_s {
		this_tx_id_val {Type I LastRead 0 FirstWrite -1}
		this_nsamp_val {Type I LastRead 0 FirstWrite -1}
		m_out_V_data_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_keep_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_strb_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_last_V {Type O LastRead -1 FirstWrite 0}}
	fir_Pipeline_VITIS_LOOP_139_5 {
		add_ln146 {Type I LastRead 0 FirstWrite -1}
		empty_19 {Type I LastRead 0 FirstWrite -1}
		ntaps {Type I LastRead 0 FirstWrite -1}
		empty_20 {Type I LastRead 0 FirstWrite -1}
		empty_21 {Type I LastRead 0 FirstWrite -1}
		empty_22 {Type I LastRead 0 FirstWrite -1}
		empty_23 {Type I LastRead 0 FirstWrite -1}
		count {Type I LastRead 0 FirstWrite -1}
		s_in_V_data_V {Type I LastRead 1 FirstWrite -1}
		s_in_V_keep_V {Type I LastRead 1 FirstWrite -1}
		s_in_V_strb_V {Type I LastRead 1 FirstWrite -1}
		s_in_V_last_V {Type I LastRead 1 FirstWrite -1}
		empty_24 {Type I LastRead 0 FirstWrite -1}
		empty_25 {Type I LastRead 0 FirstWrite -1}
		empty_26 {Type I LastRead 0 FirstWrite -1}
		empty_27 {Type I LastRead 0 FirstWrite -1}
		empty_28 {Type I LastRead 0 FirstWrite -1}
		empty_29 {Type I LastRead 0 FirstWrite -1}
		empty_30 {Type I LastRead 0 FirstWrite -1}
		empty_31 {Type I LastRead 0 FirstWrite -1}
		empty_32 {Type I LastRead 0 FirstWrite -1}
		empty_33 {Type I LastRead 0 FirstWrite -1}
		empty_34 {Type I LastRead 0 FirstWrite -1}
		empty_35 {Type I LastRead 0 FirstWrite -1}
		empty_36 {Type I LastRead 0 FirstWrite -1}
		empty_37 {Type I LastRead 0 FirstWrite -1}
		empty_38 {Type I LastRead 0 FirstWrite -1}
		empty_39 {Type I LastRead 0 FirstWrite -1}
		empty_40 {Type I LastRead 0 FirstWrite -1}
		empty_41 {Type I LastRead 0 FirstWrite -1}
		empty_42 {Type I LastRead 0 FirstWrite -1}
		empty_43 {Type I LastRead 0 FirstWrite -1}
		empty_44 {Type I LastRead 0 FirstWrite -1}
		empty_45 {Type I LastRead 0 FirstWrite -1}
		empty_46 {Type I LastRead 0 FirstWrite -1}
		empty_47 {Type I LastRead 0 FirstWrite -1}
		empty_48 {Type I LastRead 0 FirstWrite -1}
		empty_49 {Type I LastRead 0 FirstWrite -1}
		empty_50 {Type I LastRead 0 FirstWrite -1}
		empty_51 {Type I LastRead 0 FirstWrite -1}
		empty_52 {Type I LastRead 0 FirstWrite -1}
		empty_53 {Type I LastRead 0 FirstWrite -1}
		empty_54 {Type I LastRead 0 FirstWrite -1}
		empty {Type I LastRead 0 FirstWrite -1}
		m_out_V_data_V {Type O LastRead -1 FirstWrite 196}
		m_out_V_keep_V {Type O LastRead -1 FirstWrite 196}
		m_out_V_strb_V {Type O LastRead -1 FirstWrite 196}
		m_out_V_last_V {Type O LastRead -1 FirstWrite 196}
		win_30_out {Type IO LastRead 1 FirstWrite 1}
		win_29_out {Type IO LastRead 13 FirstWrite 13}
		win_28_out {Type IO LastRead 13 FirstWrite 13}
		win_27_out {Type IO LastRead 25 FirstWrite 25}
		win_26_out {Type IO LastRead 31 FirstWrite 31}
		win_25_out {Type IO LastRead 31 FirstWrite 31}
		win_24_out {Type IO LastRead 43 FirstWrite 43}
		win_23_out {Type IO LastRead 43 FirstWrite 43}
		win_22_out {Type IO LastRead 55 FirstWrite 55}
		win_21_out {Type IO LastRead 55 FirstWrite 55}
		win_20_out {Type IO LastRead 67 FirstWrite 67}
		win_19_out {Type IO LastRead 67 FirstWrite 67}
		win_18_out {Type IO LastRead 79 FirstWrite 79}
		win_17_out {Type IO LastRead 79 FirstWrite 79}
		win_16_out {Type IO LastRead 91 FirstWrite 91}
		win_15_out {Type IO LastRead 91 FirstWrite 91}
		win_14_out {Type IO LastRead 103 FirstWrite 103}
		win_13_out {Type IO LastRead 103 FirstWrite 103}
		win_12_out {Type IO LastRead 115 FirstWrite 115}
		win_11_out {Type IO LastRead 115 FirstWrite 115}
		win_10_out {Type IO LastRead 127 FirstWrite 127}
		win_9_out {Type IO LastRead 127 FirstWrite 127}
		win_8_out {Type IO LastRead 139 FirstWrite 139}
		win_7_out {Type IO LastRead 139 FirstWrite 139}
		win_6_out {Type IO LastRead 151 FirstWrite 151}
		win_5_out {Type IO LastRead 157 FirstWrite 157}
		win_4_out {Type IO LastRead 163 FirstWrite 163}
		win_3_out {Type IO LastRead 169 FirstWrite 169}
		win_2_out {Type IO LastRead 175 FirstWrite 175}
		win_1_out {Type IO LastRead 181 FirstWrite 181}
		win_out {Type IO LastRead 181 FirstWrite 181}
		err_1_out {Type O LastRead -1 FirstWrite 195}}
	fir_Pipeline_VITIS_LOOP_104_3 {
		add_ln104_1 {Type I LastRead 0 FirstWrite -1}
		s_in_V_data_V {Type I LastRead 0 FirstWrite -1}
		s_in_V_keep_V {Type I LastRead 0 FirstWrite -1}
		s_in_V_strb_V {Type I LastRead 0 FirstWrite -1}
		s_in_V_last_V {Type I LastRead 0 FirstWrite -1}
		count {Type I LastRead 0 FirstWrite -1}
		p_out {Type O LastRead -1 FirstWrite 0}
		p_out1 {Type O LastRead -1 FirstWrite 0}
		p_out2 {Type O LastRead -1 FirstWrite 0}
		p_out3 {Type O LastRead -1 FirstWrite 0}
		p_out4 {Type O LastRead -1 FirstWrite 0}
		p_out5 {Type O LastRead -1 FirstWrite 0}
		p_out6 {Type O LastRead -1 FirstWrite 0}
		p_out7 {Type O LastRead -1 FirstWrite 0}
		p_out8 {Type O LastRead -1 FirstWrite 0}
		p_out9 {Type O LastRead -1 FirstWrite 0}
		p_out10 {Type O LastRead -1 FirstWrite 0}
		p_out11 {Type O LastRead -1 FirstWrite 0}
		p_out12 {Type O LastRead -1 FirstWrite 0}
		p_out13 {Type O LastRead -1 FirstWrite 0}
		p_out14 {Type O LastRead -1 FirstWrite 0}
		p_out15 {Type O LastRead -1 FirstWrite 0}
		p_out16 {Type O LastRead -1 FirstWrite 0}
		p_out17 {Type O LastRead -1 FirstWrite 0}
		p_out18 {Type O LastRead -1 FirstWrite 0}
		p_out19 {Type O LastRead -1 FirstWrite 0}
		p_out20 {Type O LastRead -1 FirstWrite 0}
		p_out21 {Type O LastRead -1 FirstWrite 0}
		p_out22 {Type O LastRead -1 FirstWrite 0}
		p_out23 {Type O LastRead -1 FirstWrite 0}
		p_out24 {Type O LastRead -1 FirstWrite 0}
		p_out25 {Type O LastRead -1 FirstWrite 0}
		p_out26 {Type O LastRead -1 FirstWrite 0}
		p_out27 {Type O LastRead -1 FirstWrite 0}
		p_out28 {Type O LastRead -1 FirstWrite 0}
		p_out29 {Type O LastRead -1 FirstWrite 0}
		p_out30 {Type O LastRead -1 FirstWrite 0}
		p_out31 {Type O LastRead -1 FirstWrite 0}
		err_2_out {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "0", "Max" : "0"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	s_in_V_data_V { axis {  { s_in_TDATA in_data 0 32 } } }
	s_in_V_keep_V { axis {  { s_in_TKEEP in_data 0 4 } } }
	s_in_V_strb_V { axis {  { s_in_TSTRB in_data 0 4 } } }
	s_in_V_last_V { axis {  { s_in_TVALID in_vld 0 1 }  { s_in_TREADY in_acc 1 1 }  { s_in_TLAST in_data 0 1 } } }
	m_out_V_data_V { axis {  { m_out_TDATA out_data 1 32 } } }
	m_out_V_keep_V { axis {  { m_out_TKEEP out_data 1 4 } } }
	m_out_V_strb_V { axis {  { m_out_TSTRB out_data 1 4 } } }
	m_out_V_last_V { axis {  { m_out_TVALID out_vld 1 1 }  { m_out_TREADY out_acc 0 1 }  { m_out_TLAST out_data 1 1 } } }
}

set maxi_interface_dict [dict create]

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
