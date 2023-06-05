#############################################################################
##        Copyright (c) 1988 - 2020 Synopsys, Inc. All rights reserved.     #
##                                                                          #
##  This Synopsys TestMAX product and all associated documentation are      #
##  proprietary to Synopsys, Inc. and may only be used pursuant to the      #
##  terms and conditions of a written license agreement with Synopsys, Inc. #
##  All other use, reproduction, modification, or distribution of the       #
##  Synopsys Testmax product or associated documentation is                 #
##  strictly prohibited.                                                    #
##                                                                          #
#############################################################################
##                                                                          #
##  Version    : R-2020.09                                                  #
##  Created on : Fri Jul 31 17:32:37 IST 2020                               #
##                                                                          #
#############################################################################
# iLane global variable
set share_wrapper_en    $env(share_wrapper_en)
set Comp 		$env(Compr)

# ATPG variable
set spf  		$env(spf)
set fmodel 		$env(fmodel)

set filename atpg_${fmodel}_${spf}

set design_name or1200_dc_top

set netlistname ../03_dc/outputs/${design_name}.v

set_messages -log ./logs/tmax.${filename}.log -replace -level expert


echo ####################################
echo spf = $spf
echo fmodel = $fmodel
echo ####################################


# Reading Design Library and Netlist files
read_netlist -lib $env(ILANE_LIB_PATH)/vlg/saed32nm.v
read_netlist -lib $env(ILANE_LIB_PATH)/tmaxlib/sad*max
read_netlist -lib $env(ILANE_LIB_PATH)/tmaxlib/std_cells.max
read_netlist  $env(ILANE_LIB_PATH)/tmaxlib/sad*v

#read_netlist
set_netlist -redefined last
read_netlist ${netlistname}

set_build -black_box [ list  pll_1 pll_2 ]
run_build ${design_name}

# Capture window size definition
#set_atpg -min_ate 20

# To avoid cross clock domain MASTER-SHADOW identification issue(vcs-sim failure, i.e sram output to wrapper cell)
set_drc -noshadow
# Example : set_drc -nouse_pipelines is not supported for DFTMAX-Ultra designs. (M1012)
#if {regexp "scan" $spf match} {
	# for pattern porting
#	set_drc -nouse_pipelines
#	set_drc -pipeline_stages "2 2"
#} 

# add_pi_x.tcl forces X to the Wrapped Primary Inputs of the core
source -e -v ./scripts/add_pi_x.tcl
add_po_mask -all

set_rule X2 warning

# DRC for COMP mode
if {$fmodel == "sa"} {
	
	set_faults -model stuck
        
	run_drc -patternexec ${spf}_occ_bypass ../02_testmax/outputs/or1200.${spf}_occ_bypass.spc_disable.spf

}

report_compressor -shift_power_controller -verbose

report_scan_cells -all > reports/$filename.scan_cells.rpt
report_viol X2 > reports/$filename.X2.rpt

report_pi_cons
report_scan_enables

set_atpg -verbose
set_atpg -pwr_verbose

# Removing DFT IP faults
source -e -v ./scripts/add_nofault.tcl
add_equivalent_nofaults
add_fa -all
report_fa -su
report_nofa -sum

set_atpg -num_thread 4
if {[regexp "sccomp" $spf match]} {
   set_atpg -pattern 1000
} else {
# limit the number of patterns for non-compressed modes to reduce runtime
  set_atpg -pattern 10
} 
run_atpg 

report_fa -su
report_pat -su

report_fault -level 10 100 > ./reports/core.$spf.$fmodel.hier_fault.lst

write_fault  ./reports/core.$spf.$fmodel.fault.lst.gz -replace -compress gzip -all
 
#write_image  ./outputs/${filename}.image -replace

#set_patterns -pipeline_stages "2 2"
#run_sim
#Concat OCC + cascad OCC share core wrapping enablement in iLane
#occ concat daisy chain pattern porting limitation: only serial pattern is supported
write_patterns ./outputs/${filename}.stil -format stil -serial -replace -cellnames type

set_sim -num_thread 4
run_sim
report_power -per_pattern -percentage > ./logs/power_report.${filename}.log

# pattern porting debug
report_pattern -clocking -type -all > ./logs/pattern_report.${filename}.log

exit
