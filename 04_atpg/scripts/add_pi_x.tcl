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
add_pi_constraints x  vl_sms_or1200_dc_top_proc_1_sms_1_bisr_mode
add_pi_constraints x  vl_sms_or1200_dc_top_proc_1_sms_1_fast_mode
add_pi_constraints x  vl_sms_or1200_dc_top_proc_1_sms_1_par_algo_mode
add_pi_constraints x  vl_sms_or1200_dc_top_proc_1_sms_1_par_algo_sel[0]
add_pi_constraints x  vl_sms_or1200_dc_top_proc_1_sms_1_par_algo_sel[1]
add_pi_constraints x  vl_sms_or1200_dc_top_proc_1_sms_1_smart_bist
add_pi_constraints x  vl_sms_or1200_dc_top_proc_2_sms_2_bisr_mode
add_pi_constraints x  vl_sms_or1200_dc_top_proc_2_sms_2_fast_mode
add_pi_constraints x  vl_sms_or1200_dc_top_proc_2_sms_2_par_algo_mode
add_pi_constraints x  vl_sms_or1200_dc_top_proc_2_sms_2_par_algo_sel[0]
add_pi_constraints x  vl_sms_or1200_dc_top_proc_2_sms_2_par_algo_sel[1]
add_pi_constraints x  vl_sms_or1200_dc_top_proc_2_sms_2_smart_bist
add_pi_constraints x  vl_sms_R1_CaptureWR
add_pi_constraints x  vl_sms_R1_SelectWIR
add_pi_constraints x  vl_sms_R1_ShiftWR
add_pi_constraints x  vl_sms_R1_UpdateWR
add_pi_constraints x  vl_sms_R1_WSI
add_pi_constraints x  vl_sms_or1200_dc_top_proc_1_sms_1_index_based_repair
add_pi_constraints x  vl_sms_or1200_dc_top_proc_2_sms_2_index_based_repair

#input [31:0] dcsb_dat_i;
add_pi_constraints x  dcsb_dat_i[31]
add_pi_constraints x  dcsb_dat_i[30]
add_pi_constraints x  dcsb_dat_i[29]
add_pi_constraints x  dcsb_dat_i[28]
add_pi_constraints x  dcsb_dat_i[27]
add_pi_constraints x  dcsb_dat_i[26]
add_pi_constraints x  dcsb_dat_i[25]
add_pi_constraints x  dcsb_dat_i[24]
add_pi_constraints x  dcsb_dat_i[23]
add_pi_constraints x  dcsb_dat_i[22]
add_pi_constraints x  dcsb_dat_i[21]
add_pi_constraints x  dcsb_dat_i[20]
add_pi_constraints x  dcsb_dat_i[19]
add_pi_constraints x  dcsb_dat_i[18]
add_pi_constraints x  dcsb_dat_i[17]
add_pi_constraints x  dcsb_dat_i[16]
add_pi_constraints x  dcsb_dat_i[15]
add_pi_constraints x  dcsb_dat_i[14]
add_pi_constraints x  dcsb_dat_i[13]
add_pi_constraints x  dcsb_dat_i[12]
add_pi_constraints x  dcsb_dat_i[11]
add_pi_constraints x  dcsb_dat_i[10]
add_pi_constraints x  dcsb_dat_i[9]
add_pi_constraints x  dcsb_dat_i[8]
add_pi_constraints x  dcsb_dat_i[7]
add_pi_constraints x  dcsb_dat_i[6]
add_pi_constraints x  dcsb_dat_i[5]
add_pi_constraints x  dcsb_dat_i[4]
add_pi_constraints x  dcsb_dat_i[3]
add_pi_constraints x  dcsb_dat_i[2]
add_pi_constraints x  dcsb_dat_i[1]
add_pi_constraints x  dcsb_dat_i[0]

#  input [31:0] dcqmem_adr_i;
add_pi_constraints x  dcqmem_adr_i[31]
add_pi_constraints x  dcqmem_adr_i[30]
add_pi_constraints x  dcqmem_adr_i[29]
add_pi_constraints x  dcqmem_adr_i[28]
add_pi_constraints x  dcqmem_adr_i[27]
add_pi_constraints x  dcqmem_adr_i[26]
add_pi_constraints x  dcqmem_adr_i[25]
add_pi_constraints x  dcqmem_adr_i[24]
add_pi_constraints x  dcqmem_adr_i[23]
add_pi_constraints x  dcqmem_adr_i[22]
add_pi_constraints x  dcqmem_adr_i[21]
add_pi_constraints x  dcqmem_adr_i[20]
add_pi_constraints x  dcqmem_adr_i[19]
add_pi_constraints x  dcqmem_adr_i[18]
add_pi_constraints x  dcqmem_adr_i[17]
add_pi_constraints x  dcqmem_adr_i[16]
add_pi_constraints x  dcqmem_adr_i[15]
add_pi_constraints x  dcqmem_adr_i[14]
add_pi_constraints x  dcqmem_adr_i[13]
add_pi_constraints x  dcqmem_adr_i[12]
add_pi_constraints x  dcqmem_adr_i[11]
add_pi_constraints x  dcqmem_adr_i[10]
add_pi_constraints x  dcqmem_adr_i[9]
add_pi_constraints x  dcqmem_adr_i[8]
add_pi_constraints x  dcqmem_adr_i[7]
add_pi_constraints x  dcqmem_adr_i[6]
add_pi_constraints x  dcqmem_adr_i[5]
add_pi_constraints x  dcqmem_adr_i[4]
add_pi_constraints x  dcqmem_adr_i[3]
add_pi_constraints x  dcqmem_adr_i[2]
add_pi_constraints x  dcqmem_adr_i[1]
add_pi_constraints x  dcqmem_adr_i[0]

#  input [3:0] dcqmem_sel_i;
add_pi_constraints x  dcqmem_sel_i[3]
add_pi_constraints x  dcqmem_sel_i[2]
add_pi_constraints x  dcqmem_sel_i[1]
add_pi_constraints x  dcqmem_sel_i[0]

#  input [3:0] dcqmem_tag_i;
add_pi_constraints x  dcqmem_tag_i[3]
add_pi_constraints x  dcqmem_tag_i[2]
add_pi_constraints x  dcqmem_tag_i[1]
add_pi_constraints x  dcqmem_tag_i[0]

#  input [31:0] dcqmem_dat_i;
add_pi_constraints x  dcqmem_dat_i[31]
add_pi_constraints x  dcqmem_dat_i[30]
add_pi_constraints x  dcqmem_dat_i[29]
add_pi_constraints x  dcqmem_dat_i[28]
add_pi_constraints x  dcqmem_dat_i[27]
add_pi_constraints x  dcqmem_dat_i[26]
add_pi_constraints x  dcqmem_dat_i[25]
add_pi_constraints x  dcqmem_dat_i[24]
add_pi_constraints x  dcqmem_dat_i[23]
add_pi_constraints x  dcqmem_dat_i[22]
add_pi_constraints x  dcqmem_dat_i[21]
add_pi_constraints x  dcqmem_dat_i[20]
add_pi_constraints x  dcqmem_dat_i[19]
add_pi_constraints x  dcqmem_dat_i[18]
add_pi_constraints x  dcqmem_dat_i[17]
add_pi_constraints x  dcqmem_dat_i[16]
add_pi_constraints x  dcqmem_dat_i[15]
add_pi_constraints x  dcqmem_dat_i[14]
add_pi_constraints x  dcqmem_dat_i[13]
add_pi_constraints x  dcqmem_dat_i[12]
add_pi_constraints x  dcqmem_dat_i[11]
add_pi_constraints x  dcqmem_dat_i[10]
add_pi_constraints x  dcqmem_dat_i[9]
add_pi_constraints x  dcqmem_dat_i[8]
add_pi_constraints x  dcqmem_dat_i[7]
add_pi_constraints x  dcqmem_dat_i[6]
add_pi_constraints x  dcqmem_dat_i[5]
add_pi_constraints x  dcqmem_dat_i[4]
add_pi_constraints x  dcqmem_dat_i[3]
add_pi_constraints x  dcqmem_dat_i[2]
add_pi_constraints x  dcqmem_dat_i[1]
add_pi_constraints x  dcqmem_dat_i[0]

#  input [31:0] spr_dat_i;
add_pi_constraints x  spr_dat_i[31]
add_pi_constraints x  spr_dat_i[30]
add_pi_constraints x  spr_dat_i[29]
add_pi_constraints x  spr_dat_i[28]
add_pi_constraints x  spr_dat_i[27]
add_pi_constraints x  spr_dat_i[26]
add_pi_constraints x  spr_dat_i[25]
add_pi_constraints x  spr_dat_i[24]
add_pi_constraints x  spr_dat_i[23]
add_pi_constraints x  spr_dat_i[22]
add_pi_constraints x  spr_dat_i[21]
add_pi_constraints x  spr_dat_i[20]
add_pi_constraints x  spr_dat_i[19]
add_pi_constraints x  spr_dat_i[18]
add_pi_constraints x  spr_dat_i[17]
add_pi_constraints x  spr_dat_i[16]
add_pi_constraints x  spr_dat_i[15]
add_pi_constraints x  spr_dat_i[14]
add_pi_constraints x  spr_dat_i[13]
add_pi_constraints x  spr_dat_i[12]
add_pi_constraints x  spr_dat_i[11]
add_pi_constraints x  spr_dat_i[10]
add_pi_constraints x  spr_dat_i[9]
add_pi_constraints x  spr_dat_i[8]
add_pi_constraints x  spr_dat_i[7]
add_pi_constraints x  spr_dat_i[6]
add_pi_constraints x  spr_dat_i[5]
add_pi_constraints x  spr_dat_i[4]
add_pi_constraints x  spr_dat_i[3]
add_pi_constraints x  spr_dat_i[2]
add_pi_constraints x  spr_dat_i[1]
add_pi_constraints x  spr_dat_i[0]

#  input [31:0] spr_addr;
add_pi_constraints x  spr_addr[31]
add_pi_constraints x  spr_addr[30]
add_pi_constraints x  spr_addr[29]
add_pi_constraints x  spr_addr[28]
add_pi_constraints x  spr_addr[27]
add_pi_constraints x  spr_addr[26]
add_pi_constraints x  spr_addr[25]
add_pi_constraints x  spr_addr[24]
add_pi_constraints x  spr_addr[23]
add_pi_constraints x  spr_addr[22]
add_pi_constraints x  spr_addr[21]
add_pi_constraints x  spr_addr[20]
add_pi_constraints x  spr_addr[19]
add_pi_constraints x  spr_addr[18]
add_pi_constraints x  spr_addr[17]
add_pi_constraints x  spr_addr[16]
add_pi_constraints x  spr_addr[15]
add_pi_constraints x  spr_addr[14]
add_pi_constraints x  spr_addr[13]
add_pi_constraints x  spr_addr[12]
add_pi_constraints x  spr_addr[11]
add_pi_constraints x  spr_addr[10]
add_pi_constraints x  spr_addr[9]
add_pi_constraints x  spr_addr[8]
add_pi_constraints x  spr_addr[7]
add_pi_constraints x  spr_addr[6]
add_pi_constraints x  spr_addr[5]
add_pi_constraints x  spr_addr[4]
add_pi_constraints x  spr_addr[3]
add_pi_constraints x  spr_addr[2]
add_pi_constraints x  spr_addr[1]
add_pi_constraints x  spr_addr[0]

add_pi_constraints x  dcqmem_we_i


