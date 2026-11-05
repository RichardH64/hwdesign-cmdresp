set moduleName fir_Pipeline_VITIS_LOOP_139_5
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set isPipelined_legacy 1
set pipeline_type loop_auto_rewind
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
set C_modelName {fir_Pipeline_VITIS_LOOP_139_5}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ add_ln146 int 10 regular  }
	{ empty_19 int 27 regular  }
	{ ntaps int 32 regular  }
	{ empty_20 int 28 regular  }
	{ empty_21 int 29 regular  }
	{ empty_22 int 30 regular  }
	{ empty_23 int 31 regular  }
	{ count int 11 regular  }
	{ s_in_V_data_V int 32 regular {axi_s 0 volatile  { s_in Data } }  }
	{ s_in_V_keep_V int 4 regular {axi_s 0 volatile  { s_in Keep } }  }
	{ s_in_V_strb_V int 4 regular {axi_s 0 volatile  { s_in Strb } }  }
	{ s_in_V_last_V int 1 regular {axi_s 0 volatile  { s_in Last } }  }
	{ empty_24 float 32 regular  }
	{ empty_25 float 32 regular  }
	{ empty_26 float 32 regular  }
	{ empty_27 float 32 regular  }
	{ empty_28 float 32 regular  }
	{ empty_29 float 32 regular  }
	{ empty_30 float 32 regular  }
	{ empty_31 float 32 regular  }
	{ empty_32 float 32 regular  }
	{ empty_33 float 32 regular  }
	{ empty_34 float 32 regular  }
	{ empty_35 float 32 regular  }
	{ empty_36 float 32 regular  }
	{ empty_37 float 32 regular  }
	{ empty_38 float 32 regular  }
	{ empty_39 float 32 regular  }
	{ empty_40 float 32 regular  }
	{ empty_41 float 32 regular  }
	{ empty_42 float 32 regular  }
	{ empty_43 float 32 regular  }
	{ empty_44 float 32 regular  }
	{ empty_45 float 32 regular  }
	{ empty_46 float 32 regular  }
	{ empty_47 float 32 regular  }
	{ empty_48 float 32 regular  }
	{ empty_49 float 32 regular  }
	{ empty_50 float 32 regular  }
	{ empty_51 float 32 regular  }
	{ empty_52 float 32 regular  }
	{ empty_53 float 32 regular  }
	{ empty_54 float 32 regular  }
	{ empty float 32 regular  }
	{ m_out_V_data_V int 32 regular {axi_s 1 volatile  { m_out Data } }  }
	{ m_out_V_keep_V int 4 regular {axi_s 1 volatile  { m_out Keep } }  }
	{ m_out_V_strb_V int 4 regular {axi_s 1 volatile  { m_out Strb } }  }
	{ m_out_V_last_V int 1 regular {axi_s 1 volatile  { m_out Last } }  }
	{ win_30_out float 32 regular {pointer 2}  }
	{ win_29_out float 32 regular {pointer 2}  }
	{ win_28_out float 32 regular {pointer 2}  }
	{ win_27_out float 32 regular {pointer 2}  }
	{ win_26_out float 32 regular {pointer 2}  }
	{ win_25_out float 32 regular {pointer 2}  }
	{ win_24_out float 32 regular {pointer 2}  }
	{ win_23_out float 32 regular {pointer 2}  }
	{ win_22_out float 32 regular {pointer 2}  }
	{ win_21_out float 32 regular {pointer 2}  }
	{ win_20_out float 32 regular {pointer 2}  }
	{ win_19_out float 32 regular {pointer 2}  }
	{ win_18_out float 32 regular {pointer 2}  }
	{ win_17_out float 32 regular {pointer 2}  }
	{ win_16_out float 32 regular {pointer 2}  }
	{ win_15_out float 32 regular {pointer 2}  }
	{ win_14_out float 32 regular {pointer 2}  }
	{ win_13_out float 32 regular {pointer 2}  }
	{ win_12_out float 32 regular {pointer 2}  }
	{ win_11_out float 32 regular {pointer 2}  }
	{ win_10_out float 32 regular {pointer 2}  }
	{ win_9_out float 32 regular {pointer 2}  }
	{ win_8_out float 32 regular {pointer 2}  }
	{ win_7_out float 32 regular {pointer 2}  }
	{ win_6_out float 32 regular {pointer 2}  }
	{ win_5_out float 32 regular {pointer 2}  }
	{ win_4_out float 32 regular {pointer 2}  }
	{ win_3_out float 32 regular {pointer 2}  }
	{ win_2_out float 32 regular {pointer 2}  }
	{ win_1_out float 32 regular {pointer 2}  }
	{ win_out float 32 regular {pointer 2}  }
	{ err_1_out int 8 regular {pointer 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "add_ln146", "interface" : "wire", "bitwidth" : 10, "direction" : "READONLY"} , 
 	{ "Name" : "empty_19", "interface" : "wire", "bitwidth" : 27, "direction" : "READONLY"} , 
 	{ "Name" : "ntaps", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_20", "interface" : "wire", "bitwidth" : 28, "direction" : "READONLY"} , 
 	{ "Name" : "empty_21", "interface" : "wire", "bitwidth" : 29, "direction" : "READONLY"} , 
 	{ "Name" : "empty_22", "interface" : "wire", "bitwidth" : 30, "direction" : "READONLY"} , 
 	{ "Name" : "empty_23", "interface" : "wire", "bitwidth" : 31, "direction" : "READONLY"} , 
 	{ "Name" : "count", "interface" : "wire", "bitwidth" : 11, "direction" : "READONLY"} , 
 	{ "Name" : "s_in_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "s_in_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "s_in_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "s_in_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "empty_24", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_25", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_26", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_27", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_28", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_29", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_30", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_31", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_32", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_33", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_34", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_35", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_36", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_37", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_38", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_39", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_40", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_41", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_42", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_43", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_44", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_45", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_46", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_47", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_48", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_49", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_50", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_51", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_52", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_53", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty_54", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "empty", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "m_out_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "m_out_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "win_30_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_29_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_28_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_27_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_26_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_25_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_24_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_23_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_22_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_21_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_20_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_19_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_18_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_17_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_16_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_15_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_14_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_13_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_12_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_11_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_10_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_9_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_8_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_7_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_6_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_5_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_4_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_3_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_2_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_1_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "win_out", "interface" : "wire", "bitwidth" : 32, "direction" : "READWRITE"} , 
 	{ "Name" : "err_1_out", "interface" : "wire", "bitwidth" : 8, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 153
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ s_in_TVALID sc_in sc_logic 1 invld 8 } 
	{ m_out_TREADY sc_in sc_logic 1 outacc 44 } 
	{ add_ln146 sc_in sc_lv 10 signal 0 } 
	{ empty_19 sc_in sc_lv 27 signal 1 } 
	{ ntaps sc_in sc_lv 32 signal 2 } 
	{ empty_20 sc_in sc_lv 28 signal 3 } 
	{ empty_21 sc_in sc_lv 29 signal 4 } 
	{ empty_22 sc_in sc_lv 30 signal 5 } 
	{ empty_23 sc_in sc_lv 31 signal 6 } 
	{ count sc_in sc_lv 11 signal 7 } 
	{ s_in_TDATA sc_in sc_lv 32 signal 8 } 
	{ s_in_TREADY sc_out sc_logic 1 inacc 11 } 
	{ s_in_TKEEP sc_in sc_lv 4 signal 9 } 
	{ s_in_TSTRB sc_in sc_lv 4 signal 10 } 
	{ s_in_TLAST sc_in sc_lv 1 signal 11 } 
	{ empty_24 sc_in sc_lv 32 signal 12 } 
	{ empty_25 sc_in sc_lv 32 signal 13 } 
	{ empty_26 sc_in sc_lv 32 signal 14 } 
	{ empty_27 sc_in sc_lv 32 signal 15 } 
	{ empty_28 sc_in sc_lv 32 signal 16 } 
	{ empty_29 sc_in sc_lv 32 signal 17 } 
	{ empty_30 sc_in sc_lv 32 signal 18 } 
	{ empty_31 sc_in sc_lv 32 signal 19 } 
	{ empty_32 sc_in sc_lv 32 signal 20 } 
	{ empty_33 sc_in sc_lv 32 signal 21 } 
	{ empty_34 sc_in sc_lv 32 signal 22 } 
	{ empty_35 sc_in sc_lv 32 signal 23 } 
	{ empty_36 sc_in sc_lv 32 signal 24 } 
	{ empty_37 sc_in sc_lv 32 signal 25 } 
	{ empty_38 sc_in sc_lv 32 signal 26 } 
	{ empty_39 sc_in sc_lv 32 signal 27 } 
	{ empty_40 sc_in sc_lv 32 signal 28 } 
	{ empty_41 sc_in sc_lv 32 signal 29 } 
	{ empty_42 sc_in sc_lv 32 signal 30 } 
	{ empty_43 sc_in sc_lv 32 signal 31 } 
	{ empty_44 sc_in sc_lv 32 signal 32 } 
	{ empty_45 sc_in sc_lv 32 signal 33 } 
	{ empty_46 sc_in sc_lv 32 signal 34 } 
	{ empty_47 sc_in sc_lv 32 signal 35 } 
	{ empty_48 sc_in sc_lv 32 signal 36 } 
	{ empty_49 sc_in sc_lv 32 signal 37 } 
	{ empty_50 sc_in sc_lv 32 signal 38 } 
	{ empty_51 sc_in sc_lv 32 signal 39 } 
	{ empty_52 sc_in sc_lv 32 signal 40 } 
	{ empty_53 sc_in sc_lv 32 signal 41 } 
	{ empty_54 sc_in sc_lv 32 signal 42 } 
	{ empty sc_in sc_lv 32 signal 43 } 
	{ m_out_TDATA sc_out sc_lv 32 signal 44 } 
	{ m_out_TVALID sc_out sc_logic 1 outvld 47 } 
	{ m_out_TKEEP sc_out sc_lv 4 signal 45 } 
	{ m_out_TSTRB sc_out sc_lv 4 signal 46 } 
	{ m_out_TLAST sc_out sc_lv 1 signal 47 } 
	{ win_30_out_i sc_in sc_lv 32 signal 48 } 
	{ win_30_out_o sc_out sc_lv 32 signal 48 } 
	{ win_30_out_o_ap_vld sc_out sc_logic 1 outvld 48 } 
	{ win_29_out_i sc_in sc_lv 32 signal 49 } 
	{ win_29_out_o sc_out sc_lv 32 signal 49 } 
	{ win_29_out_o_ap_vld sc_out sc_logic 1 outvld 49 } 
	{ win_28_out_i sc_in sc_lv 32 signal 50 } 
	{ win_28_out_o sc_out sc_lv 32 signal 50 } 
	{ win_28_out_o_ap_vld sc_out sc_logic 1 outvld 50 } 
	{ win_27_out_i sc_in sc_lv 32 signal 51 } 
	{ win_27_out_o sc_out sc_lv 32 signal 51 } 
	{ win_27_out_o_ap_vld sc_out sc_logic 1 outvld 51 } 
	{ win_26_out_i sc_in sc_lv 32 signal 52 } 
	{ win_26_out_o sc_out sc_lv 32 signal 52 } 
	{ win_26_out_o_ap_vld sc_out sc_logic 1 outvld 52 } 
	{ win_25_out_i sc_in sc_lv 32 signal 53 } 
	{ win_25_out_o sc_out sc_lv 32 signal 53 } 
	{ win_25_out_o_ap_vld sc_out sc_logic 1 outvld 53 } 
	{ win_24_out_i sc_in sc_lv 32 signal 54 } 
	{ win_24_out_o sc_out sc_lv 32 signal 54 } 
	{ win_24_out_o_ap_vld sc_out sc_logic 1 outvld 54 } 
	{ win_23_out_i sc_in sc_lv 32 signal 55 } 
	{ win_23_out_o sc_out sc_lv 32 signal 55 } 
	{ win_23_out_o_ap_vld sc_out sc_logic 1 outvld 55 } 
	{ win_22_out_i sc_in sc_lv 32 signal 56 } 
	{ win_22_out_o sc_out sc_lv 32 signal 56 } 
	{ win_22_out_o_ap_vld sc_out sc_logic 1 outvld 56 } 
	{ win_21_out_i sc_in sc_lv 32 signal 57 } 
	{ win_21_out_o sc_out sc_lv 32 signal 57 } 
	{ win_21_out_o_ap_vld sc_out sc_logic 1 outvld 57 } 
	{ win_20_out_i sc_in sc_lv 32 signal 58 } 
	{ win_20_out_o sc_out sc_lv 32 signal 58 } 
	{ win_20_out_o_ap_vld sc_out sc_logic 1 outvld 58 } 
	{ win_19_out_i sc_in sc_lv 32 signal 59 } 
	{ win_19_out_o sc_out sc_lv 32 signal 59 } 
	{ win_19_out_o_ap_vld sc_out sc_logic 1 outvld 59 } 
	{ win_18_out_i sc_in sc_lv 32 signal 60 } 
	{ win_18_out_o sc_out sc_lv 32 signal 60 } 
	{ win_18_out_o_ap_vld sc_out sc_logic 1 outvld 60 } 
	{ win_17_out_i sc_in sc_lv 32 signal 61 } 
	{ win_17_out_o sc_out sc_lv 32 signal 61 } 
	{ win_17_out_o_ap_vld sc_out sc_logic 1 outvld 61 } 
	{ win_16_out_i sc_in sc_lv 32 signal 62 } 
	{ win_16_out_o sc_out sc_lv 32 signal 62 } 
	{ win_16_out_o_ap_vld sc_out sc_logic 1 outvld 62 } 
	{ win_15_out_i sc_in sc_lv 32 signal 63 } 
	{ win_15_out_o sc_out sc_lv 32 signal 63 } 
	{ win_15_out_o_ap_vld sc_out sc_logic 1 outvld 63 } 
	{ win_14_out_i sc_in sc_lv 32 signal 64 } 
	{ win_14_out_o sc_out sc_lv 32 signal 64 } 
	{ win_14_out_o_ap_vld sc_out sc_logic 1 outvld 64 } 
	{ win_13_out_i sc_in sc_lv 32 signal 65 } 
	{ win_13_out_o sc_out sc_lv 32 signal 65 } 
	{ win_13_out_o_ap_vld sc_out sc_logic 1 outvld 65 } 
	{ win_12_out_i sc_in sc_lv 32 signal 66 } 
	{ win_12_out_o sc_out sc_lv 32 signal 66 } 
	{ win_12_out_o_ap_vld sc_out sc_logic 1 outvld 66 } 
	{ win_11_out_i sc_in sc_lv 32 signal 67 } 
	{ win_11_out_o sc_out sc_lv 32 signal 67 } 
	{ win_11_out_o_ap_vld sc_out sc_logic 1 outvld 67 } 
	{ win_10_out_i sc_in sc_lv 32 signal 68 } 
	{ win_10_out_o sc_out sc_lv 32 signal 68 } 
	{ win_10_out_o_ap_vld sc_out sc_logic 1 outvld 68 } 
	{ win_9_out_i sc_in sc_lv 32 signal 69 } 
	{ win_9_out_o sc_out sc_lv 32 signal 69 } 
	{ win_9_out_o_ap_vld sc_out sc_logic 1 outvld 69 } 
	{ win_8_out_i sc_in sc_lv 32 signal 70 } 
	{ win_8_out_o sc_out sc_lv 32 signal 70 } 
	{ win_8_out_o_ap_vld sc_out sc_logic 1 outvld 70 } 
	{ win_7_out_i sc_in sc_lv 32 signal 71 } 
	{ win_7_out_o sc_out sc_lv 32 signal 71 } 
	{ win_7_out_o_ap_vld sc_out sc_logic 1 outvld 71 } 
	{ win_6_out_i sc_in sc_lv 32 signal 72 } 
	{ win_6_out_o sc_out sc_lv 32 signal 72 } 
	{ win_6_out_o_ap_vld sc_out sc_logic 1 outvld 72 } 
	{ win_5_out_i sc_in sc_lv 32 signal 73 } 
	{ win_5_out_o sc_out sc_lv 32 signal 73 } 
	{ win_5_out_o_ap_vld sc_out sc_logic 1 outvld 73 } 
	{ win_4_out_i sc_in sc_lv 32 signal 74 } 
	{ win_4_out_o sc_out sc_lv 32 signal 74 } 
	{ win_4_out_o_ap_vld sc_out sc_logic 1 outvld 74 } 
	{ win_3_out_i sc_in sc_lv 32 signal 75 } 
	{ win_3_out_o sc_out sc_lv 32 signal 75 } 
	{ win_3_out_o_ap_vld sc_out sc_logic 1 outvld 75 } 
	{ win_2_out_i sc_in sc_lv 32 signal 76 } 
	{ win_2_out_o sc_out sc_lv 32 signal 76 } 
	{ win_2_out_o_ap_vld sc_out sc_logic 1 outvld 76 } 
	{ win_1_out_i sc_in sc_lv 32 signal 77 } 
	{ win_1_out_o sc_out sc_lv 32 signal 77 } 
	{ win_1_out_o_ap_vld sc_out sc_logic 1 outvld 77 } 
	{ win_out_i sc_in sc_lv 32 signal 78 } 
	{ win_out_o sc_out sc_lv 32 signal 78 } 
	{ win_out_o_ap_vld sc_out sc_logic 1 outvld 78 } 
	{ err_1_out sc_out sc_lv 8 signal 79 } 
	{ err_1_out_ap_vld sc_out sc_logic 1 outvld 79 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "s_in_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "s_in_V_data_V", "role": "default" }} , 
 	{ "name": "m_out_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "m_out_V_data_V", "role": "default" }} , 
 	{ "name": "add_ln146", "direction": "in", "datatype": "sc_lv", "bitwidth":10, "type": "signal", "bundle":{"name": "add_ln146", "role": "default" }} , 
 	{ "name": "empty_19", "direction": "in", "datatype": "sc_lv", "bitwidth":27, "type": "signal", "bundle":{"name": "empty_19", "role": "default" }} , 
 	{ "name": "ntaps", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "ntaps", "role": "default" }} , 
 	{ "name": "empty_20", "direction": "in", "datatype": "sc_lv", "bitwidth":28, "type": "signal", "bundle":{"name": "empty_20", "role": "default" }} , 
 	{ "name": "empty_21", "direction": "in", "datatype": "sc_lv", "bitwidth":29, "type": "signal", "bundle":{"name": "empty_21", "role": "default" }} , 
 	{ "name": "empty_22", "direction": "in", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "empty_22", "role": "default" }} , 
 	{ "name": "empty_23", "direction": "in", "datatype": "sc_lv", "bitwidth":31, "type": "signal", "bundle":{"name": "empty_23", "role": "default" }} , 
 	{ "name": "count", "direction": "in", "datatype": "sc_lv", "bitwidth":11, "type": "signal", "bundle":{"name": "count", "role": "default" }} , 
 	{ "name": "s_in_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "s_in_V_data_V", "role": "default" }} , 
 	{ "name": "s_in_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "s_in_V_last_V", "role": "default" }} , 
 	{ "name": "s_in_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "s_in_V_keep_V", "role": "default" }} , 
 	{ "name": "s_in_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "s_in_V_strb_V", "role": "default" }} , 
 	{ "name": "s_in_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "s_in_V_last_V", "role": "default" }} , 
 	{ "name": "empty_24", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_24", "role": "default" }} , 
 	{ "name": "empty_25", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_25", "role": "default" }} , 
 	{ "name": "empty_26", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_26", "role": "default" }} , 
 	{ "name": "empty_27", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_27", "role": "default" }} , 
 	{ "name": "empty_28", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_28", "role": "default" }} , 
 	{ "name": "empty_29", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_29", "role": "default" }} , 
 	{ "name": "empty_30", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_30", "role": "default" }} , 
 	{ "name": "empty_31", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_31", "role": "default" }} , 
 	{ "name": "empty_32", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_32", "role": "default" }} , 
 	{ "name": "empty_33", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_33", "role": "default" }} , 
 	{ "name": "empty_34", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_34", "role": "default" }} , 
 	{ "name": "empty_35", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_35", "role": "default" }} , 
 	{ "name": "empty_36", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_36", "role": "default" }} , 
 	{ "name": "empty_37", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_37", "role": "default" }} , 
 	{ "name": "empty_38", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_38", "role": "default" }} , 
 	{ "name": "empty_39", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_39", "role": "default" }} , 
 	{ "name": "empty_40", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_40", "role": "default" }} , 
 	{ "name": "empty_41", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_41", "role": "default" }} , 
 	{ "name": "empty_42", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_42", "role": "default" }} , 
 	{ "name": "empty_43", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_43", "role": "default" }} , 
 	{ "name": "empty_44", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_44", "role": "default" }} , 
 	{ "name": "empty_45", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_45", "role": "default" }} , 
 	{ "name": "empty_46", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_46", "role": "default" }} , 
 	{ "name": "empty_47", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_47", "role": "default" }} , 
 	{ "name": "empty_48", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_48", "role": "default" }} , 
 	{ "name": "empty_49", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_49", "role": "default" }} , 
 	{ "name": "empty_50", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_50", "role": "default" }} , 
 	{ "name": "empty_51", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_51", "role": "default" }} , 
 	{ "name": "empty_52", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_52", "role": "default" }} , 
 	{ "name": "empty_53", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_53", "role": "default" }} , 
 	{ "name": "empty_54", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty_54", "role": "default" }} , 
 	{ "name": "empty", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "empty", "role": "default" }} , 
 	{ "name": "m_out_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "m_out_V_data_V", "role": "default" }} , 
 	{ "name": "m_out_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "m_out_V_last_V", "role": "default" }} , 
 	{ "name": "m_out_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m_out_V_keep_V", "role": "default" }} , 
 	{ "name": "m_out_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "m_out_V_strb_V", "role": "default" }} , 
 	{ "name": "m_out_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "m_out_V_last_V", "role": "default" }} , 
 	{ "name": "win_30_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_30_out", "role": "i" }} , 
 	{ "name": "win_30_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_30_out", "role": "o" }} , 
 	{ "name": "win_30_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_30_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_29_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_29_out", "role": "i" }} , 
 	{ "name": "win_29_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_29_out", "role": "o" }} , 
 	{ "name": "win_29_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_29_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_28_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_28_out", "role": "i" }} , 
 	{ "name": "win_28_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_28_out", "role": "o" }} , 
 	{ "name": "win_28_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_28_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_27_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_27_out", "role": "i" }} , 
 	{ "name": "win_27_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_27_out", "role": "o" }} , 
 	{ "name": "win_27_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_27_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_26_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_26_out", "role": "i" }} , 
 	{ "name": "win_26_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_26_out", "role": "o" }} , 
 	{ "name": "win_26_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_26_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_25_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_25_out", "role": "i" }} , 
 	{ "name": "win_25_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_25_out", "role": "o" }} , 
 	{ "name": "win_25_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_25_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_24_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_24_out", "role": "i" }} , 
 	{ "name": "win_24_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_24_out", "role": "o" }} , 
 	{ "name": "win_24_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_24_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_23_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_23_out", "role": "i" }} , 
 	{ "name": "win_23_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_23_out", "role": "o" }} , 
 	{ "name": "win_23_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_23_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_22_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_22_out", "role": "i" }} , 
 	{ "name": "win_22_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_22_out", "role": "o" }} , 
 	{ "name": "win_22_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_22_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_21_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_21_out", "role": "i" }} , 
 	{ "name": "win_21_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_21_out", "role": "o" }} , 
 	{ "name": "win_21_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_21_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_20_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_20_out", "role": "i" }} , 
 	{ "name": "win_20_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_20_out", "role": "o" }} , 
 	{ "name": "win_20_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_20_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_19_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_19_out", "role": "i" }} , 
 	{ "name": "win_19_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_19_out", "role": "o" }} , 
 	{ "name": "win_19_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_19_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_18_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_18_out", "role": "i" }} , 
 	{ "name": "win_18_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_18_out", "role": "o" }} , 
 	{ "name": "win_18_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_18_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_17_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_17_out", "role": "i" }} , 
 	{ "name": "win_17_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_17_out", "role": "o" }} , 
 	{ "name": "win_17_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_17_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_16_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_16_out", "role": "i" }} , 
 	{ "name": "win_16_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_16_out", "role": "o" }} , 
 	{ "name": "win_16_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_16_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_15_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_15_out", "role": "i" }} , 
 	{ "name": "win_15_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_15_out", "role": "o" }} , 
 	{ "name": "win_15_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_15_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_14_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_14_out", "role": "i" }} , 
 	{ "name": "win_14_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_14_out", "role": "o" }} , 
 	{ "name": "win_14_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_14_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_13_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_13_out", "role": "i" }} , 
 	{ "name": "win_13_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_13_out", "role": "o" }} , 
 	{ "name": "win_13_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_13_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_12_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_12_out", "role": "i" }} , 
 	{ "name": "win_12_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_12_out", "role": "o" }} , 
 	{ "name": "win_12_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_12_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_11_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_11_out", "role": "i" }} , 
 	{ "name": "win_11_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_11_out", "role": "o" }} , 
 	{ "name": "win_11_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_11_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_10_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_10_out", "role": "i" }} , 
 	{ "name": "win_10_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_10_out", "role": "o" }} , 
 	{ "name": "win_10_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_10_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_9_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_9_out", "role": "i" }} , 
 	{ "name": "win_9_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_9_out", "role": "o" }} , 
 	{ "name": "win_9_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_9_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_8_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_8_out", "role": "i" }} , 
 	{ "name": "win_8_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_8_out", "role": "o" }} , 
 	{ "name": "win_8_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_8_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_7_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_7_out", "role": "i" }} , 
 	{ "name": "win_7_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_7_out", "role": "o" }} , 
 	{ "name": "win_7_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_7_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_6_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_6_out", "role": "i" }} , 
 	{ "name": "win_6_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_6_out", "role": "o" }} , 
 	{ "name": "win_6_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_6_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_5_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_5_out", "role": "i" }} , 
 	{ "name": "win_5_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_5_out", "role": "o" }} , 
 	{ "name": "win_5_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_5_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_4_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_4_out", "role": "i" }} , 
 	{ "name": "win_4_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_4_out", "role": "o" }} , 
 	{ "name": "win_4_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_4_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_3_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_3_out", "role": "i" }} , 
 	{ "name": "win_3_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_3_out", "role": "o" }} , 
 	{ "name": "win_3_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_3_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_2_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_2_out", "role": "i" }} , 
 	{ "name": "win_2_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_2_out", "role": "o" }} , 
 	{ "name": "win_2_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_2_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_1_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_1_out", "role": "i" }} , 
 	{ "name": "win_1_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_1_out", "role": "o" }} , 
 	{ "name": "win_1_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_1_out", "role": "o_ap_vld" }} , 
 	{ "name": "win_out_i", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_out", "role": "i" }} , 
 	{ "name": "win_out_o", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "win_out", "role": "o" }} , 
 	{ "name": "win_out_o_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "win_out", "role": "o_ap_vld" }} , 
 	{ "name": "err_1_out", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "err_1_out", "role": "default" }} , 
 	{ "name": "err_1_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "err_1_out", "role": "ap_vld" }}  ]}

set ArgLastReadFirstWriteLatency {
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
		err_1_out {Type O LastRead -1 FirstWrite 195}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "198", "Max" : "1221"}
	, {"Name" : "Interval", "Min" : "2", "Max" : "1025"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	add_ln146 { ap_none {  { add_ln146 in_data 0 10 } } }
	empty_19 { ap_none {  { empty_19 in_data 0 27 } } }
	ntaps { ap_none {  { ntaps in_data 0 32 } } }
	empty_20 { ap_none {  { empty_20 in_data 0 28 } } }
	empty_21 { ap_none {  { empty_21 in_data 0 29 } } }
	empty_22 { ap_none {  { empty_22 in_data 0 30 } } }
	empty_23 { ap_none {  { empty_23 in_data 0 31 } } }
	count { ap_none {  { count in_data 0 11 } } }
	s_in_V_data_V { axis {  { s_in_TVALID in_vld 0 1 }  { s_in_TDATA in_data 0 32 } } }
	s_in_V_keep_V { axis {  { s_in_TKEEP in_data 0 4 } } }
	s_in_V_strb_V { axis {  { s_in_TSTRB in_data 0 4 } } }
	s_in_V_last_V { axis {  { s_in_TREADY in_acc 1 1 }  { s_in_TLAST in_data 0 1 } } }
	empty_24 { ap_none {  { empty_24 in_data 0 32 } } }
	empty_25 { ap_none {  { empty_25 in_data 0 32 } } }
	empty_26 { ap_none {  { empty_26 in_data 0 32 } } }
	empty_27 { ap_none {  { empty_27 in_data 0 32 } } }
	empty_28 { ap_none {  { empty_28 in_data 0 32 } } }
	empty_29 { ap_none {  { empty_29 in_data 0 32 } } }
	empty_30 { ap_none {  { empty_30 in_data 0 32 } } }
	empty_31 { ap_none {  { empty_31 in_data 0 32 } } }
	empty_32 { ap_none {  { empty_32 in_data 0 32 } } }
	empty_33 { ap_none {  { empty_33 in_data 0 32 } } }
	empty_34 { ap_none {  { empty_34 in_data 0 32 } } }
	empty_35 { ap_none {  { empty_35 in_data 0 32 } } }
	empty_36 { ap_none {  { empty_36 in_data 0 32 } } }
	empty_37 { ap_none {  { empty_37 in_data 0 32 } } }
	empty_38 { ap_none {  { empty_38 in_data 0 32 } } }
	empty_39 { ap_none {  { empty_39 in_data 0 32 } } }
	empty_40 { ap_none {  { empty_40 in_data 0 32 } } }
	empty_41 { ap_none {  { empty_41 in_data 0 32 } } }
	empty_42 { ap_none {  { empty_42 in_data 0 32 } } }
	empty_43 { ap_none {  { empty_43 in_data 0 32 } } }
	empty_44 { ap_none {  { empty_44 in_data 0 32 } } }
	empty_45 { ap_none {  { empty_45 in_data 0 32 } } }
	empty_46 { ap_none {  { empty_46 in_data 0 32 } } }
	empty_47 { ap_none {  { empty_47 in_data 0 32 } } }
	empty_48 { ap_none {  { empty_48 in_data 0 32 } } }
	empty_49 { ap_none {  { empty_49 in_data 0 32 } } }
	empty_50 { ap_none {  { empty_50 in_data 0 32 } } }
	empty_51 { ap_none {  { empty_51 in_data 0 32 } } }
	empty_52 { ap_none {  { empty_52 in_data 0 32 } } }
	empty_53 { ap_none {  { empty_53 in_data 0 32 } } }
	empty_54 { ap_none {  { empty_54 in_data 0 32 } } }
	empty { ap_none {  { empty in_data 0 32 } } }
	m_out_V_data_V { axis {  { m_out_TREADY out_acc 0 1 }  { m_out_TDATA out_data 1 32 } } }
	m_out_V_keep_V { axis {  { m_out_TKEEP out_data 1 4 } } }
	m_out_V_strb_V { axis {  { m_out_TSTRB out_data 1 4 } } }
	m_out_V_last_V { axis {  { m_out_TVALID out_vld 1 1 }  { m_out_TLAST out_data 1 1 } } }
	win_30_out { ap_ovld {  { win_30_out_i in_data 0 32 }  { win_30_out_o out_data 1 32 }  { win_30_out_o_ap_vld out_vld 1 1 } } }
	win_29_out { ap_ovld {  { win_29_out_i in_data 0 32 }  { win_29_out_o out_data 1 32 }  { win_29_out_o_ap_vld out_vld 1 1 } } }
	win_28_out { ap_ovld {  { win_28_out_i in_data 0 32 }  { win_28_out_o out_data 1 32 }  { win_28_out_o_ap_vld out_vld 1 1 } } }
	win_27_out { ap_ovld {  { win_27_out_i in_data 0 32 }  { win_27_out_o out_data 1 32 }  { win_27_out_o_ap_vld out_vld 1 1 } } }
	win_26_out { ap_ovld {  { win_26_out_i in_data 0 32 }  { win_26_out_o out_data 1 32 }  { win_26_out_o_ap_vld out_vld 1 1 } } }
	win_25_out { ap_ovld {  { win_25_out_i in_data 0 32 }  { win_25_out_o out_data 1 32 }  { win_25_out_o_ap_vld out_vld 1 1 } } }
	win_24_out { ap_ovld {  { win_24_out_i in_data 0 32 }  { win_24_out_o out_data 1 32 }  { win_24_out_o_ap_vld out_vld 1 1 } } }
	win_23_out { ap_ovld {  { win_23_out_i in_data 0 32 }  { win_23_out_o out_data 1 32 }  { win_23_out_o_ap_vld out_vld 1 1 } } }
	win_22_out { ap_ovld {  { win_22_out_i in_data 0 32 }  { win_22_out_o out_data 1 32 }  { win_22_out_o_ap_vld out_vld 1 1 } } }
	win_21_out { ap_ovld {  { win_21_out_i in_data 0 32 }  { win_21_out_o out_data 1 32 }  { win_21_out_o_ap_vld out_vld 1 1 } } }
	win_20_out { ap_ovld {  { win_20_out_i in_data 0 32 }  { win_20_out_o out_data 1 32 }  { win_20_out_o_ap_vld out_vld 1 1 } } }
	win_19_out { ap_ovld {  { win_19_out_i in_data 0 32 }  { win_19_out_o out_data 1 32 }  { win_19_out_o_ap_vld out_vld 1 1 } } }
	win_18_out { ap_ovld {  { win_18_out_i in_data 0 32 }  { win_18_out_o out_data 1 32 }  { win_18_out_o_ap_vld out_vld 1 1 } } }
	win_17_out { ap_ovld {  { win_17_out_i in_data 0 32 }  { win_17_out_o out_data 1 32 }  { win_17_out_o_ap_vld out_vld 1 1 } } }
	win_16_out { ap_ovld {  { win_16_out_i in_data 0 32 }  { win_16_out_o out_data 1 32 }  { win_16_out_o_ap_vld out_vld 1 1 } } }
	win_15_out { ap_ovld {  { win_15_out_i in_data 0 32 }  { win_15_out_o out_data 1 32 }  { win_15_out_o_ap_vld out_vld 1 1 } } }
	win_14_out { ap_ovld {  { win_14_out_i in_data 0 32 }  { win_14_out_o out_data 1 32 }  { win_14_out_o_ap_vld out_vld 1 1 } } }
	win_13_out { ap_ovld {  { win_13_out_i in_data 0 32 }  { win_13_out_o out_data 1 32 }  { win_13_out_o_ap_vld out_vld 1 1 } } }
	win_12_out { ap_ovld {  { win_12_out_i in_data 0 32 }  { win_12_out_o out_data 1 32 }  { win_12_out_o_ap_vld out_vld 1 1 } } }
	win_11_out { ap_ovld {  { win_11_out_i in_data 0 32 }  { win_11_out_o out_data 1 32 }  { win_11_out_o_ap_vld out_vld 1 1 } } }
	win_10_out { ap_ovld {  { win_10_out_i in_data 0 32 }  { win_10_out_o out_data 1 32 }  { win_10_out_o_ap_vld out_vld 1 1 } } }
	win_9_out { ap_ovld {  { win_9_out_i in_data 0 32 }  { win_9_out_o out_data 1 32 }  { win_9_out_o_ap_vld out_vld 1 1 } } }
	win_8_out { ap_ovld {  { win_8_out_i in_data 0 32 }  { win_8_out_o out_data 1 32 }  { win_8_out_o_ap_vld out_vld 1 1 } } }
	win_7_out { ap_ovld {  { win_7_out_i in_data 0 32 }  { win_7_out_o out_data 1 32 }  { win_7_out_o_ap_vld out_vld 1 1 } } }
	win_6_out { ap_ovld {  { win_6_out_i in_data 0 32 }  { win_6_out_o out_data 1 32 }  { win_6_out_o_ap_vld out_vld 1 1 } } }
	win_5_out { ap_ovld {  { win_5_out_i in_data 0 32 }  { win_5_out_o out_data 1 32 }  { win_5_out_o_ap_vld out_vld 1 1 } } }
	win_4_out { ap_ovld {  { win_4_out_i in_data 0 32 }  { win_4_out_o out_data 1 32 }  { win_4_out_o_ap_vld out_vld 1 1 } } }
	win_3_out { ap_ovld {  { win_3_out_i in_data 0 32 }  { win_3_out_o out_data 1 32 }  { win_3_out_o_ap_vld out_vld 1 1 } } }
	win_2_out { ap_ovld {  { win_2_out_i in_data 0 32 }  { win_2_out_o out_data 1 32 }  { win_2_out_o_ap_vld out_vld 1 1 } } }
	win_1_out { ap_ovld {  { win_1_out_i in_data 0 32 }  { win_1_out_o out_data 1 32 }  { win_1_out_o_ap_vld out_vld 1 1 } } }
	win_out { ap_ovld {  { win_out_i in_data 0 32 }  { win_out_o out_data 1 32 }  { win_out_o_ap_vld out_vld 1 1 } } }
	err_1_out { ap_vld {  { err_1_out out_data 1 8 }  { err_1_out_ap_vld out_vld 1 1 } } }
}
