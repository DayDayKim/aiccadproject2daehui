rm -rf outputs
rm -rf logs
rm -rf WORK
rm -rf reports

mkdir outputs
mkdir logs
mkdir WORK
mkdir reports

cd WORK

source ../scripts/common_setup.csh

dft_shell -file ../scripts/testmax.tcl | tee ../logs/testmax.log
