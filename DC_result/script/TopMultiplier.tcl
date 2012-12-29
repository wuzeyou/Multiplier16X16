##################################
#created by PAN YU CHEN		 #
##################################
set   result_path   "../result"
set   report_path   "../report"


#################################
set   search_path   "../src/  \
		     ../"

set   target_library  "smic13_tt.db"
set   link_library    "* smic13_tt.db"
set	  module_name	  TopMultiplier
##################################

read_file -format verilog ../src/Booth_Classic.v
read_file -format verilog ../src/CS_Adder32.v
read_file -format verilog ../src/FullAdder.v
read_file -format verilog ../src/HalfAdder.v
read_file -format verilog ../src/WallaceTree16X16.v

define_design_lib WORK -path  "../work"
analyze -format	verilog -lib WORK ${module_name}.v
elaborate $module_name -arch "verilog"  -lib WORK

current_design	$module_name
link
uniquify
link
ungroup -flatten -all

source ../script/TopMultiplier_CONST.con

compile -map_effort medium -ungroup_all
ungroup -flatten -all

write -format verilog -output $result_path/${module_name}_gate.v

################################

report_qor    > $report_path/${module_name}_qor.rpt
report_timing >	$report_path/${module_name}_timing.rpt
report_power  >	$report_path/${module_name}_power.rpt

################################

	
