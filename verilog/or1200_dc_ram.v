//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's DC RAMs                                            ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://opencores.org/project,or1k                           ////
////                                                              ////
////  Description                                                 ////
////  Instatiation of DC RAM blocks.                              ////
////                                                              ////
////  To Do:                                                      ////
////   - make it smaller and faster                               ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
//
// $Log: or1200_dc_ram.v,v $
// Revision 2.0  2010/06/30 11:00:00  ORSoC
// Minor update: 
// Coding style changed.
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_dc_ram(
	// Reset and clock
	clk, rst,

`ifdef OR1200_BIST
	// RAM BIST
	mbist_si_i, mbist_so_o, mbist_ctrl_i,
`endif

	// Internal i/f
	addr, en, we, datain, dataout
);

parameter dw = `OR1200_OPERAND_WIDTH;
parameter aw = `OR1200_DCINDX;

//
// I/O
//
input				clk;
input				rst;
input	[aw-1:0]		addr;
input				en;
input	[3:0]			we;
input	[dw-1:0]		datain;
output	[dw-1:0]		dataout;

`ifdef OR1200_BIST
//
// RAM BIST
//
input				mbist_si_i;
input [`OR1200_MBIST_CTRL_WIDTH - 1:0] mbist_ctrl_i;       // bist chain shift control
output				mbist_so_o;
`endif

`ifdef OR1200_NO_DC

//
// Data cache not implemented
//
assign dataout = {dw{1'b0}};
`ifdef OR1200_BIST
assign mbist_so_o = mbist_si_i;
`endif

`else

//
// Instantiation of RAM block
//
//   or1200_spram_32_bw #
//     (
//      .aw(`OR1200_DCINDX),
//      .dw(dw)
//      )
//   dc_ram
//     (
//`ifdef OR1200_BIST
//      // RAM BIST
//      .mbist_si_i(mbist_si_i),
//      .mbist_so_o(mbist_so_o),
//      .mbist_ctrl_i(mbist_ctrl_i),
//`endif
//      .clk(clk),
//      .ce(en),
//      .we(we),
//      .addr(addr),
//      .di(datain),
//      .doq(dataout)
//      );
//

wire clkout;

buffer u_divider_inst (.a(clk), .z(clkout));

assign gated_clkout = clkout & (!rst);

sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00 dc_ram0 (
	.QA(dataout),
	.QB(),
	.ADRA(addr),
	.ADRB(addr),
	.DA(datain),
	.DB(datain),
	.WEA(we[0]),
	.MEA(en),
	.WEB(we[0]),
	.MEB(en),
	.CLKB(gated_clkout),
	.CLKA(gated_clkout),
		.FISO(1'b0),
		.TEST1A(1'b0),
		.TEST_RNMA(1'b0),
		.RMEA(1'b0),
		.RMA(4'b0010),
		.PIPEMEA(1'b1),
		.SI_DA(1'b0),
		.SE_INA(1'b0),
		.SI_CNTRA(1'b0),
		.LS(1'b0),
		.BC1(1'b0),
		.BC2(1'b0),
		.TEST1B(1'b0),
		.TEST_RNMB(1'b0),
		.RMEB(1'b0),
		.RMB(4'b0010),
		.PIPEMEB(1'b1),
		.SI_DB(1'b0),
		.SE_INB(1'b0),
		.SI_CNTRB(1'b0) 
	);
		
`endif

endmodule // or1200_dc_ram
