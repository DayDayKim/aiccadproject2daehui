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


add_nofault -instance core_occ_ctr*
add_nofault -instance rst_ctr*
add_nofault -instance U_DFT_TOP_IP_0


# SRAM
add_nofault -module   sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00

