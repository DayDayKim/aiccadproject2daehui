//////////////////////////////////////////////////////////////////////////////
//        Copyright (c) 1988 - 2020 Synopsys, Inc. All rights reserved.     //
//                                                                          //
//  This Synopsys TestMAX product and all associated documentation are      //
//  proprietary to Synopsys, Inc. and may only be used pursuant to the      //
//  terms and conditions of a written license agreement with Synopsys, Inc. //
//  All other use, reproduction, modification, or distribution of the       //
//  Synopsys Testmax product or associated documentation is                 //
//  strictly prohibited.                                                    //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//  Version    : R-2020.09                                                  //
//  Created on : Fri Jul 31 17:32:52 IST 2020                               //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module clock_generator ( clk ,rst, pll_clk_1, pll_clk_2, pll_clk_4 );
output pll_clk_1;
output reg pll_clk_2;
output reg pll_clk_4;
input clk ;
input rst;
assign pll_clk_1 = clk;
always @(posedge clk, posedge rst)
begin
if (rst)
     pll_clk_2 <= 1'b0;
else
     pll_clk_2 <= ~pll_clk_2;   
end
always @(posedge pll_clk_2, posedge rst)
begin
if (rst)
     pll_clk_4 <= 1'b0;
else
     pll_clk_4 <= ~pll_clk_4;
end

endmodule

module clock_control_chain_selector (wrp_if_of_mode, occ_si, occ_si_extest, occ_scan_in);
input wrp_if_of_mode, occ_si, occ_si_extest;
output occ_scan_in;

assign occ_scan_in = (wrp_if_of_mode)? occ_si_extest: occ_si;
  
endmodule


module pll_source (ref_clk, pll_out);
input  ref_clk;
output pll_out;

assign pll_out = ref_clk;
endmodule


module frequency_divider_by2 ( clk ,rst,out_clk );
output reg out_clk;
input clk ;
input rst;
always @(posedge clk)
begin
if (~rst)
     out_clk <= 1'b0;
else
     out_clk <= ~out_clk;	
end
endmodule

module buffer (a, z); 
 input a;
output z;

assign z = a ; 

endmodule

