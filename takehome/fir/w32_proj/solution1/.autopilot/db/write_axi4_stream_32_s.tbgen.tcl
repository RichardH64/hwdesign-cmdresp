set moduleName write_axi4_stream_32_s
set isTopModule 0
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
set C_modelName {write_axi4_stream<32>}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ this_tx_id_val int 16 regular  }
	{ this_nsamp_val int 16 regular  }
	{ m_out_V_data_V int 32 regular {axi_s 1 volatile  { m_out Data } }  }
	{ m_out_V_keep_V int 4 regular {axi_s 1 volatile  { m_out Keep } }  }
	{ m_out_V_strb_V int 4 regular {axi_s 1 volatile  { m_out Strb } }  }
	{ m_out_V_last_V int 1 regular {axi_s 1 volatile  { m_out Last } }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "this_tx_id_val", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "this_nsamp_val", "interface" : "wire", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "m_out_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 14
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ this_tx_id_val sc_in sc_lv 16 signal 0 } 
	{ this_nsamp_val sc_in sc_lv 16 signal 1 } 
	{ m_out_TDATA sc_out sc_lv 32 signal 2 } 
	{ m_out_TVALID sc_out sc_logic 1 outvld 5 } 
	{ m_out_TREADY sc_in sc_logic 1 outacc 2 } 
	{ m_out_TKEEP sc_out sc_lv 4 signal 3 } 
	{ m_out_TSTRB sc_out sc_lv 4 signal 4 } 
	{ m_out_TLAST sc_out sc_lv 1 signal 5 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "this_tx_id_val", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "this_tx_id_val", "role": "default" }} , 
 	{ "name": "this_nsamp_val", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "this_nsamp_val", "role": "default" }} , 
 	{ "name": "m_out_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "m_out_V_data_V", "role": "default" }} , 
 	{ "name": "m_out_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "m_out_V_last_V", "role": "default" }} , 
 	{ "name": "m_out_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "m_out_V_data_V", "role": "default" }} , 
 	{ "name": "m_out_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m_out_V_keep_V", "role": "default" }} , 
 	{ "name": "m_out_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m_out_V_strb_V", "role": "default" }} , 
 	{ "name": "m_out_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_out_V_last_V", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	write_axi4_stream_32_s {
		this_tx_id_val {Type I LastRead 0 FirstWrite -1}
		this_nsamp_val {Type I LastRead 0 FirstWrite -1}
		m_out_V_data_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_keep_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_strb_V {Type O LastRead -1 FirstWrite 0}
		m_out_V_last_V {Type O LastRead -1 FirstWrite 0}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "1", "Max" : "1"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	this_tx_id_val { ap_none {  { this_tx_id_val in_data 0 16 } } }
	this_nsamp_val { ap_none {  { this_nsamp_val in_data 0 16 } } }
	m_out_V_data_V { axis {  { m_out_TDATA out_data 1 32 }  { m_out_TREADY out_acc 0 1 } } }
	m_out_V_keep_V { axis {  { m_out_TKEEP out_data 1 4 } } }
	m_out_V_strb_V { axis {  { m_out_TSTRB out_data 1 4 } } }
	m_out_V_last_V { axis {  { m_out_TVALID out_vld 1 1 }  { m_out_TLAST out_data 1 1 } } }
}
