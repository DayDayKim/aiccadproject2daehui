#############################################################################
#!/bin/csh -f

../common_cleanup.csh
source ../common_setup.csh

cd WORK

$SPYGLASS_HOME/bin/spyglass -goal test_goal -project ../scripts/options_RTL.prj -batch

cd ..

cp -rf WORK/FUSA_WORK_DIR/*/consolidated_reports/or1200_dc_top_test_goal/soft_error_* reports/
cp -rf WORK/FUSA_WORK_DIR/*/consolidated_reports/or1200_dc_top_test_goal/spyglass.log logs/
cp -rf WORK/FUSA_WORK_DIR/*/consolidated_reports/or1200_dc_top_test_goal/moresimple.rpt logs/

