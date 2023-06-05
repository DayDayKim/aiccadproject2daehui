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
##  Created on : Fri Jul 31 17:32:34 IST 2020                               #
##                                                                          #
#############################################################################
set tmax_lib_verilog true
set share_wrapper_en    $env(share_wrapper_en)

# Design Setup
# enable for sdf-sim, disable to speed up full-flow
set fix_hold false

lappend search_path .

set design des_unit_core1

set search_path [concat ../../inputs  $env(ILANE_LIB_PATH)/db  ${search_path}]
set target_library [list saed32rvt_tt1p05v125c.db   ]
set synthetic_library dw_foundation.sldb
set link_library [concat {*} ${target_library} ${synthetic_library} saed32rvt_tt1p05v125c.db sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00.db ]

define_design_lib WORK -path ./WORK

## Read Verilog RTL
## Reading DFTMAX IP RTL generated by TestMAX
analyze -format sverilog -vcs "-f ../../3_scan/WORK/output/Verilog/sources.f"

elaborate  $design 
# read ctl model of memory macro
read_test_model -design sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00 -format ctl  $env(ILANE_LIB_PATH)/ctl/sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00.ctl

# Setting top design
current_design $design
link

#User defined scan synthesis constraint
set_scan_configuration -exclude_elements [list u_pll_gen]


# Using the generated dft constraints
source -e -v ../../3_scan/outputs/des_unit_dft_constraints.tcl
source -e -v ../../3_scan/outputs/sdc/des_unit_sdc_constraints_none_any.sdc.tcl
######################################################################

compile -scan

# Creating Test Protocol
create_test_protocol

# DFT Insertion to build scan chains
insert_dft 

###########################
# Writing Netlist with scan chains inserted and IP synthesized
write -format verilog -h -o ../outputs/${design}.v

exit
