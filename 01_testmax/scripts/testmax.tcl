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
##  Created on : Fri Jul 31 17:32:32 IST 2020                               #
##                                                                          #
#############################################################################

#-------------------------------------------------------------
# 1.loading design / global setting 
#-------------------------------------------------------------
set netlist_flow $env(netlist_flow)

set search_path [concat . $env(ILANE_LIB_PATH) ${search_path}] 
set_app_options -as_user_default -name hdlin.analyze_searching_verbose_mode -value true

set libs_path [getenv ILANE_LIB_PATH]
# nlib created for standard cells and memories 
create_lib -ref_libs [list  $libs_path/NDM/sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00_lib.ndm \
                            $libs_path/NDM/saed32rvt_c.ndm]  memory_stdlib_io.nlib

#Read the Verilogs or filelist
if { $netlist_flow == "yes"  } {
	analyze -format verilog -vcs "~/project1/1_synthesis/outputs/des_unit_core1.v" 
} else {
	analyze -format sverilog -vcs "-f ../scripts/sms_rtl.f" 
}

set design des_unit_core1

elaborate $design 

#This command is used to link the top module
set_top_module $design    


#This is for updating the tools with any ports created on the fly
setup_rtl_flow    

#-------------------------------------------------------------------
# 2. enable dft specification  
#-------------------------------------------------------------------

# Enable Clients for MBIST; Defining the shadow server
set_dft_configuration  -mbist      enable
set_dft_configuration  -dft_access enable

#Define MBIST Configurations
set_mbist_configuration -masis_file                         "$env(ILANE_LIB_PATH)/masis"                  
set_mbist_configuration -compiler_libraries                 "$env(ILANE_LIB_PATH)/complib.6x"
set_mbist_configuration -simulation_models                  "$env(ILANE_LIB_PATH)/sms_sim_model" 
set_mbist_configuration -simulation_models_sourcelist       "../scripts/define.f"
set_mbist_configuration -project_name                       $design\_prj

#to stop sms pins and memory pins propagate to top
set_mbist_configuration -setup_options [list extract_rcl.connect_proc_clocks 1 \
                                             extract_rcl.connect_proc_resets 1 \
                                             extract_rcl.limited_test_pin_propagation true \
                                             extract_rcl.connect_proc_dms 1] \
                                             -custom_algorithm on

report_mbist_configuration -algorithm all

# talgo_prog_enable 1 treg_algo 1 treg_enable 1: programable mbist hardware enablement smart_bist_en 1: smart bist enablement
#srv_smart_bist_en 1 enable_hard_repair true: smart_bist and hard_repair enablement
set_dft_access_element -type shadow_server -parameter [list srv_smart_bist_en 1 enable_hard_repair true] 

set_dft_access_element -type processor     -parameter [list add_user_pins_to_builder_list false \
                                                            smart_bist_en 1 \
                                                            talgo_prog_enable 1 \
                                                            treg_algo 1 \
                                                            treg_enable 1] \
                                                            -algorithm [list -default VLMP_46N42N6p \
                                                                            -hardwired VLMP_46N42N6p \
                                                                            VLP1_26N_CH_MP \
                                                                            VLP1_26N_SO_MP \
                                                                            VLP2_26N_CH_MP \
                                                                            VLP2_26N_SO_MP]

set_dft_access_element -type wrapper       -parameter [list add_user_pins_to_builder_list false \
                                                        dft_mpr_errors_severity 2 \
                                                        smpr_list "RM RME RMA RMB RMEA RMEB TEST1 TEST1A TEST1B TEST_RNM TEST_RNMA TEST_RNMB"]

#----------- clock definition --------------------------------------------
create_clock           -name clkgrp_noc              [get_ports clk_noc_i]                         -period 1 -waveform { 0 0.5 } 
create_clock           -name clkgrp_st               [get_ports REFCLK]                            -period 2 -waveform { 0 1 }   
create_generated_clock -name clkgrp_st_div1          [get_pins u_pll_gen/pll_clk_1]                -source [get_ports REFCLK]        -divide_by 1 -master_clock clkgrp_st      -add
create_generated_clock -name clkgrp_st_div2          [get_pins u_pll_gen/pll_clk_2]                -source [get_ports REFCLK]        -divide_by 2 -master_clock clkgrp_st      -add
create_generated_clock -name clkgrp_st_div4          [get_pins u_pll_gen/pll_clk_4]                -source [get_ports REFCLK]        -divide_by 4 -master_clock clkgrp_st      -add
create_generated_clock -name clkgrp_st_div2_memcore  [get_pins inst_memory_core1/u_divider_inst/z] -source [get_ports REFCLK]        -divide_by 2 -master_clock clkgrp_st      -add

#----------- reset definition --------------------------------------------
#Define asserts require to make clock path transparent and configure MBIST mode
set_case_analysis 0 RST

#----------- plan_dft-----------------------------------------------------
plan_dft > ../logs/plan_dft.log

#----------- generate_dft-------------------------------------------------
# creating standalone MBIST logics like sub-server, wrapper, processor etc; to create RCL file for connecting these standlone logics
#Kick multi job run to speedup SMS IP generation
exec sed -i {s/project \$p create/set_jcs_parameter jcs_max_jobs 20\n&/} ./scripts/${design}\_prj.ish
generate_dft > ../logs/generate_dft.log

#----------- connect_dft---------------------------------------------------
# RTL modifications through modify_rtl are allowed only before connect_dft
# Connecting DFT-IP to Functional RTL
# RCL converted to TCL scripts as input to connect the standalone MBIST logics to the input RTL
connect_dft > ../logs/connect_dft.log

#----------- write_sms_constraint---------------------------------------------------
write_dft_constraint -sms -sms_outdir SMS_constraints

#----------- validate_dft---------------------------------------------------
#Validating connectivity and rules, checks for the connectivity between newly generates logic
validate_dft -check connectivity > ../logs/validate_dft_con_chk.log

#Integrity checker for verifing the connectivity between SMS/SHS components
validate_dft -check verify_mbist_components > ../logs/validate_dft_con_mbist_cmp_ckhs.log
 
#Simulates the SMS/SHS inserted design BIST algorithms
validate_dft -check verify_mbist_system -fast_mode on > ../logs/validate_dft_verify_mbist_sys.log

exit
