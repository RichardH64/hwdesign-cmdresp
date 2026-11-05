set ModuleHierarchy {[{
"Name" : "fir", "RefName" : "fir","ID" : "0","Type" : "sequential",
"SubLoops" : [
	{"Name" : "VITIS_LOOP_75_2","RefName" : "VITIS_LOOP_75_2","ID" : "1","Type" : "no",
	"SubInsts" : [
	{"Name" : "grp_write_axi4_stream_32_s_fu_503", "RefName" : "write_axi4_stream_32_s","ID" : "2","Type" : "sequential"},
	{"Name" : "grp_fir_Pipeline_VITIS_LOOP_139_5_fu_519", "RefName" : "fir_Pipeline_VITIS_LOOP_139_5","ID" : "3","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_139_5","RefName" : "VITIS_LOOP_139_5","ID" : "4","Type" : "pipeline"},]},
	{"Name" : "grp_fir_Pipeline_VITIS_LOOP_104_3_fu_611", "RefName" : "fir_Pipeline_VITIS_LOOP_104_3","ID" : "5","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_104_3","RefName" : "VITIS_LOOP_104_3","ID" : "6","Type" : "pipeline"},]},]},]
}]}