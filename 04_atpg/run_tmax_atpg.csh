./cleanup.csh
source ../common_setup.csh

tmax2 -nogui scripts/tmax_atpg_parametrize.tcl -env fmodel sa  -env spf sccomp
tmax2 -nogui scripts/tmax_atpg_parametrize.tcl -env fmodel sa  -env spf scan

