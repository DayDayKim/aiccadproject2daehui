set tmax_lib_verilog true

lappend search_path .

set design or1200_dc_top

set search_path [concat ../../verilog  $env(ILANE_LIB_PATH)/db  ${search_path}]
set target_library [list saed32rvt_tt1p05v125c.db   ]
set synthetic_library dw_foundation.sldb
set link_library [concat {*} ${target_library} ${synthetic_library} saed32rvt_tt1p05v125c.db sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00.db]

define_design_lib WORK -path ./WORK



analyze -format sverilog -vcs "-f ../scripts/sms_rtl.f"

elaborate  $design 

current_design $design

link



set compile_enable_constant_propagation_with_no_boundary_opt false
set compile_preserve_subdesign_interfaces true

#----------- clock definition --------------------------------------------
create_clock           -name clkgrp_noc              [get_ports clk]                   -period 1 -waveform { 0 0.5 } 
create_clock           -name clkgrp_st               [get_ports REFCLK]                -period 2 -waveform { 0 1 } 
#create_generated_clock -name clkgrp_st_div1          [get_pins u_pll_gen/pll_clk_1]          -source [get_ports REFCLK]              -divide_by 1 -master_clock clkgrp_st      -add
create_generated_clock -name clkgrp_st_div2          [get_pins u_pll_gen/pll_clk_2]          -source [get_ports REFCLK]              -divide_by 2 -master_clock clkgrp_st      -add
#create_generated_clock -name clkgrp_st_div4          [get_pins u_pll_gen/pll_clk_4]          -source [get_ports REFCLK]              -divide_by 4 -master_clock clkgrp_st      -add

#----------- reset definition --------------------------------------------
#Define asserts require to make clock path transparent and configure MBIST mode
set_case_analysis 0 RST
#set_dont_touch_net [get_pins u_pll_gen/pll_clk_1]
set_dont_touch_net [get_pins u_pll_gen/pll_clk_2]
#set_dont_touch_net [get_pins u_pll_gen/pll_clk_4]

######################################################################

compile

######################################################################


report_area 
set uniquify_naming_style "${design}_%s_%d"
uniquify -force


change_names -rules verilog -hierarchy

write -format verilog -h -o ../outputs/${design}.v

write -format verilog -h -o ../outputs/${design}_nopll.v

report_timing > ../reports/${design}_timing.rpt
report_area   > ../reports/${design}_area.rpt
report_power  > ../reports/${design}_power.rpt


exit
