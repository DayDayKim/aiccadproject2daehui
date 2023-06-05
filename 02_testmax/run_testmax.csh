
source ../common_cleanup.csh

cd WORK

source ../scripts/common_setup.csh

dft_shell -file ../scripts/testmax.tcl | tee ../logs/testmax.log

cd ..
