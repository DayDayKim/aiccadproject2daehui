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
#!/bin/csh -f

./common_cleanup.csh
source ./common_setup.csh

cd WORK

dft_shell -file ../scripts/testmax.tcl | tee ../logs/testmax.log

rm -R */simv* */csrc

cd ..

