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
##  Created on : Fri Jul 31 17:32:30 IST 2020                               #
##                                                                          #
#############################################################################
#!/bin/csh

rm -rf inputs
rm -rf outputs
rm -rf logs
rm -rf WORK
rm -rf reports

mkdir inputs
mkdir outputs
mkdir logs
mkdir WORK
mkdir reports


#foreach i (inputs outputs logs WORK reports)
#if (-e $i) then
#rm -rf $i
#endif
#end

#foreach i (inputs outputs logs WORK reports)
#mkdir $i
#end
