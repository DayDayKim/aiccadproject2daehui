/////////////////////////////////////////////////////////////////////////////
//        Copyright (c) 1988 - 2020 Synopsys, Inc. All rights reserved.     /
//                                                                          /
//  This Synopsys TestMAX product and all associated documentation are      /
//  proprietary to Synopsys, Inc. and may only be used pursuant to the      /
//  terms and conditions of a written license agreement with Synopsys, Inc. /
//  All other use, reproduction, modification, or distribution of the       /
//  Synopsys Testmax product or associated documentation is                 /
//  strictly prohibited.                                                    /
//                                                                          /
/////////////////////////////////////////////////////////////////////////////
//                                                                          /
//  Version    : R-2020.09                                                  /
//  Created on : Fri Jul 31 17:32:58 IST 2020                               /
//                                                                          /
/////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps
////////////////////////////////////////////////////////////////////////////////
// $Header: /home/austin/styson/try/ChipArch/verilog/RCS/des_functions.v,v 1.5 1999/05/03 21:04:01 styson Exp styson $
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//sde_make_gen_off
function automatic [1:64] key_permutation;
input   [1:64]  i;

reg     [1:64]  o;

  begin

    //
    // Table 12.2, Key Permutation (checked)
    //

    o[1:64] = {
      i[57], i[49], i[41], i[33], i[25], i[17], i[ 9], i[ 1], i[58], i[50], i[42], i[34], i[26], i[18],
      i[10], i[ 2], i[59], i[51], i[43], i[35], i[27], i[19], i[11], i[ 3], i[60], i[52], i[44], i[36],
      i[63], i[55], i[47], i[39], i[31], i[23], i[15], i[ 7], i[62], i[54], i[46], i[38], i[30], i[22],
      i[14], i[ 6], i[61], i[53], i[45], i[37], i[29], i[21], i[13], i[ 5], i[28], i[20], i[12], i[ 4],
      8'h00
      };

    key_permutation[1:64] = o[1:64];

  end
endfunction

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function automatic [1:64] initial_permutation;
input   [1:64]  i;

reg     [1:64]  o;

  begin

    //
    // Table 12.1, Initial Permutation (checked)
    //

    o[1:64] = {
      i[58], i[50], i[42], i[34], i[26], i[18], i[10], i[ 2], i[60], i[52], i[44], i[36], i[28], i[20], i[12], i[ 4],
      i[62], i[54], i[46], i[38], i[30], i[22], i[14], i[ 6], i[64], i[56], i[48], i[40], i[32], i[24], i[16], i[ 8],
      i[57], i[49], i[41], i[33], i[25], i[17], i[ 9], i[ 1], i[59], i[51], i[43], i[35], i[27], i[19], i[11], i[ 3],
      i[61], i[53], i[45], i[37], i[29], i[21], i[13], i[ 5], i[63], i[55], i[47], i[39], i[31], i[23], i[15], i[ 7]
      };

    initial_permutation[1:64] = o[1:64];

  end
endfunction

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function automatic [1:64] final_permutation;
input   [1:64]  i;

reg     [1:64]  o;

  begin
    //
    // Reverse final round results and
    // Table 12.8, Final Permutation (checked)
    //

    o[1:64] = { i[33:64], i[1:32] };

    o[1:64] = {
      o[40], o[ 8], o[48], o[16], o[56], o[24], o[64], o[32], o[39], o[ 7], o[47], o[15], o[55], o[23], o[63], o[31],
      o[38], o[ 6], o[46], o[14], o[54], o[22], o[62], o[30], o[37], o[ 5], o[45], o[13], o[53], o[21], o[61], o[29],
      o[36], o[ 4], o[44], o[12], o[52], o[20], o[60], o[28], o[35], o[ 3], o[43], o[11], o[51], o[19], o[59], o[27],
      o[34], o[ 2], o[42], o[10], o[50], o[18], o[58], o[26], o[33], o[ 1], o[41], o[ 9], o[49], o[17], o[57], o[25]
      };

    final_permutation[1:64] = o[1:64];

  end
endfunction

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function automatic [1:128] encrypt;
input   [1:64]  key_in;
input   [1:64]  data_in;
input   [3:0]   round;

integer         loop_count;

reg     [5:0]   sbox1_addr;
reg     [5:0]   sbox2_addr;
reg     [5:0]   sbox3_addr;
reg     [5:0]   sbox4_addr;
reg     [5:0]   sbox5_addr;
reg     [5:0]   sbox6_addr;
reg     [5:0]   sbox7_addr;
reg     [5:0]   sbox8_addr;

reg     [3:0]   sbox1[63:0];
reg     [3:0]   sbox2[63:0];
reg     [3:0]   sbox3[63:0];
reg     [3:0]   sbox4[63:0];
reg     [3:0]   sbox5[63:0];
reg     [3:0]   sbox6[63:0];
reg     [3:0]   sbox7[63:0];
reg     [3:0]   sbox8[63:0];

reg     [1:32]  l;              // left half of data_in
reg     [1:32]  r;              // right half of data_in
reg     [1:48]  e;              // expansion permutation of r
reg     [1:48]  x;              // e xor k
reg     [1:32]  s;              // s-box substitution of x
reg     [1:32]  p;              // p-box permutation of s

reg     [1:28]  kl;             // left half of key_in
reg     [1:28]  kr;             // right half of key_in
reg     [1:56]  ks;             // shifted halfs of key_in
reg     [1:48]  k;              // compression permutation of ks

reg     [1:64]  key_out;
reg     [1:64]  data_out;
reg     [1:128] key_data_out;

  begin

    sbox1[ 0] = 14; sbox1[ 1] =  4; sbox1[ 2] = 13; sbox1[ 3] =  1; sbox1[ 4] =  2; sbox1[ 5] = 15; sbox1[ 6] = 11; sbox1[ 7] =  8;
    sbox1[ 8] =  3; sbox1[ 9] = 10; sbox1[10] =  6; sbox1[11] = 12; sbox1[12] =  5; sbox1[13] =  9; sbox1[14] =  0; sbox1[15] =  7;
    sbox1[16] =  0; sbox1[17] = 15; sbox1[18] =  7; sbox1[19] =  4; sbox1[20] = 14; sbox1[21] =  2; sbox1[22] = 13; sbox1[23] =  1;
    sbox1[24] = 10; sbox1[25] =  6; sbox1[26] = 12; sbox1[27] = 11; sbox1[28] =  9; sbox1[29] =  5; sbox1[30] =  3; sbox1[31] =  8;
    sbox1[32] =  4; sbox1[33] =  1; sbox1[34] = 14; sbox1[35] =  8; sbox1[36] = 13; sbox1[37] =  6; sbox1[38] =  2; sbox1[39] = 11;
    sbox1[40] = 15; sbox1[41] = 12; sbox1[42] =  9; sbox1[43] =  7; sbox1[44] =  3; sbox1[45] = 10; sbox1[46] =  5; sbox1[47] =  0;
    sbox1[48] = 15; sbox1[49] = 12; sbox1[50] =  8; sbox1[51] =  2; sbox1[52] =  4; sbox1[53] =  9; sbox1[54] =  1; sbox1[55] =  7;
    sbox1[56] =  5; sbox1[57] = 11; sbox1[58] =  3; sbox1[59] = 14; sbox1[60] = 10; sbox1[61] =  0; sbox1[62] =  6; sbox1[63] = 13;

    sbox2[ 0] = 15; sbox2[ 1] =  1; sbox2[ 2] =  8; sbox2[ 3] = 14; sbox2[ 4] =  6; sbox2[ 5] = 11; sbox2[ 6] =  3; sbox2[ 7] =  4;
    sbox2[ 8] =  9; sbox2[ 9] =  7; sbox2[10] =  2; sbox2[11] = 13; sbox2[12] = 12; sbox2[13] =  0; sbox2[14] =  5; sbox2[15] = 10;
    sbox2[16] =  3; sbox2[17] = 13; sbox2[18] =  4; sbox2[19] =  7; sbox2[20] = 15; sbox2[21] =  2; sbox2[22] =  8; sbox2[23] = 14;
    sbox2[24] = 12; sbox2[25] =  0; sbox2[26] =  1; sbox2[27] = 10; sbox2[28] =  6; sbox2[29] =  9; sbox2[30] = 11; sbox2[31] =  5;
    sbox2[32] =  0; sbox2[33] =  4; sbox2[34] =  7; sbox2[35] = 11; sbox2[36] = 10; sbox2[37] =  4; sbox2[38] = 13; sbox2[39] =  1;
    sbox2[40] =  5; sbox2[41] =  8; sbox2[42] = 12; sbox2[43] =  6; sbox2[44] =  9; sbox2[45] =  3; sbox2[46] =  2; sbox2[47] = 15;
    sbox2[48] = 13; sbox2[49] =  8; sbox2[50] = 10; sbox2[51] =  1; sbox2[52] =  3; sbox2[53] = 15; sbox2[54] =  4; sbox2[55] =  2;
    sbox2[56] = 11; sbox2[57] =  6; sbox2[58] =  7; sbox2[59] = 12; sbox2[60] =  0; sbox2[61] =  5; sbox2[62] = 14; sbox2[63] =  9;

    sbox3[ 0] = 10; sbox3[ 1] =  0; sbox3[ 2] =  9; sbox3[ 3] = 14; sbox3[ 4] =  6; sbox3[ 5] =  3; sbox3[ 6] = 15; sbox3[ 7] =  5;
    sbox3[ 8] =  1; sbox3[ 9] = 13; sbox3[10] = 12; sbox3[11] =  7; sbox3[12] = 11; sbox3[13] =  4; sbox3[14] =  2; sbox3[15] =  8;
    sbox3[16] = 13; sbox3[17] =  7; sbox3[18] =  0; sbox3[19] =  9; sbox3[20] =  3; sbox3[21] =  4; sbox3[22] =  6; sbox3[23] = 10;
    sbox3[24] =  2; sbox3[25] =  8; sbox3[26] =  5; sbox3[27] = 14; sbox3[28] = 12; sbox3[29] = 11; sbox3[30] = 15; sbox3[31] =  1;
    sbox3[32] = 13; sbox3[33] =  6; sbox3[34] =  4; sbox3[35] =  9; sbox3[36] =  8; sbox3[37] = 15; sbox3[38] =  3; sbox3[39] =  0;
    sbox3[40] = 11; sbox3[41] =  1; sbox3[42] =  2; sbox3[43] = 12; sbox3[44] =  5; sbox3[45] = 10; sbox3[46] = 14; sbox3[47] =  7;
    sbox3[48] =  1; sbox3[49] = 10; sbox3[50] = 13; sbox3[51] =  0; sbox3[52] =  6; sbox3[53] =  9; sbox3[54] =  8; sbox3[55] =  7;
    sbox3[56] =  4; sbox3[57] = 15; sbox3[58] = 14; sbox3[59] =  3; sbox3[60] = 11; sbox3[61] =  5; sbox3[62] =  2; sbox3[63] = 12;

    sbox4[ 0] =  7; sbox4[ 1] = 13; sbox4[ 2] = 14; sbox4[ 3] =  3; sbox4[ 4] =  0; sbox4[ 5] =  6; sbox4[ 6] =  9; sbox4[ 7] = 10;
    sbox4[ 8] =  1; sbox4[ 9] =  2; sbox4[10] =  8; sbox4[11] =  5; sbox4[12] = 11; sbox4[13] = 12; sbox4[14] =  4; sbox4[15] = 15;
    sbox4[16] = 13; sbox4[17] =  8; sbox4[18] = 11; sbox4[19] =  5; sbox4[20] =  6; sbox4[21] = 15; sbox4[22] =  0; sbox4[23] =  3;
    sbox4[24] =  4; sbox4[25] =  7; sbox4[26] =  2; sbox4[27] = 12; sbox4[28] =  1; sbox4[29] = 10; sbox4[30] = 14; sbox4[31] =  9;
    sbox4[32] = 10; sbox4[33] =  6; sbox4[34] =  9; sbox4[35] =  0; sbox4[36] = 12; sbox4[37] = 11; sbox4[38] =  7; sbox4[39] = 13;
    sbox4[40] = 15; sbox4[41] =  1; sbox4[42] =  3; sbox4[43] = 14; sbox4[44] =  5; sbox4[45] =  2; sbox4[46] =  8; sbox4[47] =  4;
    sbox4[48] =  3; sbox4[49] = 15; sbox4[50] =  0; sbox4[51] =  6; sbox4[52] = 10; sbox4[53] =  1; sbox4[54] = 13; sbox4[55] =  8;
    sbox4[56] =  9; sbox4[57] =  4; sbox4[58] =  5; sbox4[59] = 11; sbox4[60] = 12; sbox4[61] =  7; sbox4[62] =  2; sbox4[63] = 14;

    sbox5[ 0] =  2; sbox5[ 1] = 12; sbox5[ 2] =  4; sbox5[ 3] =  1; sbox5[ 4] =  7; sbox5[ 5] = 10; sbox5[ 6] = 11; sbox5[ 7] =  6;
    sbox5[ 8] =  8; sbox5[ 9] =  5; sbox5[10] =  3; sbox5[11] = 15; sbox5[12] = 13; sbox5[13] =  0; sbox5[14] = 14; sbox5[15] =  9;
    sbox5[16] = 14; sbox5[17] = 11; sbox5[18] =  2; sbox5[19] = 12; sbox5[20] =  4; sbox5[21] =  7; sbox5[22] = 13; sbox5[23] =  1;
    sbox5[24] =  5; sbox5[25] =  0; sbox5[26] = 15; sbox5[27] = 10; sbox5[28] =  3; sbox5[29] =  9; sbox5[30] =  8; sbox5[31] =  6;
    sbox5[32] =  4; sbox5[33] =  2; sbox5[34] =  1; sbox5[35] = 11; sbox5[36] = 10; sbox5[37] = 13; sbox5[38] =  7; sbox5[39] =  8;
    sbox5[40] = 15; sbox5[41] =  9; sbox5[42] = 12; sbox5[43] =  5; sbox5[44] =  6; sbox5[45] =  3; sbox5[46] =  0; sbox5[47] = 14;
    sbox5[48] = 11; sbox5[49] =  8; sbox5[50] = 12; sbox5[51] =  7; sbox5[52] =  1; sbox5[53] = 14; sbox5[54] =  2; sbox5[55] = 13;
    sbox5[56] =  6; sbox5[57] = 15; sbox5[58] =  0; sbox5[59] =  9; sbox5[60] = 10; sbox5[61] =  4; sbox5[62] =  5; sbox5[63] =  3;

    sbox6[ 0] = 12; sbox6[ 1] =  1; sbox6[ 2] = 10; sbox6[ 3] = 15; sbox6[ 4] =  9; sbox6[ 5] =  2; sbox6[ 6] =  6; sbox6[ 7] =  8;
    sbox6[ 8] =  0; sbox6[ 9] = 13; sbox6[10] =  3; sbox6[11] =  4; sbox6[12] = 14; sbox6[13] =  7; sbox6[14] =  5; sbox6[15] = 11;
    sbox6[16] = 10; sbox6[17] = 15; sbox6[18] =  4; sbox6[19] =  2; sbox6[20] =  7; sbox6[21] = 12; sbox6[22] =  9; sbox6[23] =  5;
    sbox6[24] =  6; sbox6[25] =  1; sbox6[26] = 13; sbox6[27] = 14; sbox6[28] =  0; sbox6[29] = 11; sbox6[30] =  3; sbox6[31] =  8;
    sbox6[32] =  9; sbox6[33] = 14; sbox6[34] = 15; sbox6[35] =  5; sbox6[36] =  2; sbox6[37] =  8; sbox6[38] = 12; sbox6[39] =  3;
    sbox6[40] =  7; sbox6[41] =  0; sbox6[42] =  4; sbox6[43] = 10; sbox6[44] =  1; sbox6[45] = 13; sbox6[46] = 11; sbox6[47] =  6;
    sbox6[48] =  4; sbox6[49] =  3; sbox6[50] =  2; sbox6[51] = 12; sbox6[52] =  9; sbox6[53] =  5; sbox6[54] = 15; sbox6[55] = 10;
    sbox6[56] = 11; sbox6[57] = 14; sbox6[58] =  1; sbox6[59] =  7; sbox6[60] =  6; sbox6[61] =  0; sbox6[62] =  8; sbox6[63] = 13;

    sbox7[ 0] =  4; sbox7[ 1] = 11; sbox7[ 2] =  2; sbox7[ 3] = 14; sbox7[ 4] = 15; sbox7[ 5] =  0; sbox7[ 6] =  8; sbox7[ 7] = 13;
    sbox7[ 8] =  3; sbox7[ 9] = 12; sbox7[10] =  9; sbox7[11] =  7; sbox7[12] =  5; sbox7[13] = 10; sbox7[14] =  6; sbox7[15] =  1;
    sbox7[16] = 13; sbox7[17] =  0; sbox7[18] = 11; sbox7[19] =  7; sbox7[20] =  4; sbox7[21] =  9; sbox7[22] =  1; sbox7[23] = 10;
    sbox7[24] = 14; sbox7[25] =  3; sbox7[26] =  5; sbox7[27] = 12; sbox7[28] =  2; sbox7[29] = 15; sbox7[30] =  8; sbox7[31] =  6;
    sbox7[32] =  1; sbox7[33] =  4; sbox7[34] = 11; sbox7[35] = 13; sbox7[36] = 12; sbox7[37] =  3; sbox7[38] =  7; sbox7[39] = 14;
    sbox7[40] = 10; sbox7[41] = 15; sbox7[42] =  6; sbox7[43] =  8; sbox7[44] =  0; sbox7[45] =  5; sbox7[46] =  9; sbox7[47] =  2;
    sbox7[48] =  6; sbox7[49] = 11; sbox7[50] = 13; sbox7[51] =  8; sbox7[52] =  1; sbox7[53] =  4; sbox7[54] = 10; sbox7[55] =  7;
    sbox7[56] =  9; sbox7[57] =  5; sbox7[58] =  0; sbox7[59] = 15; sbox7[60] = 14; sbox7[61] =  2; sbox7[62] =  3; sbox7[63] = 12;

    sbox8[ 0] = 13; sbox8[ 1] =  2; sbox8[ 2] =  8; sbox8[ 3] =  4; sbox8[ 4] =  6; sbox8[ 5] = 15; sbox8[ 6] = 11; sbox8[ 7] =  1;
    sbox8[ 8] = 10; sbox8[ 9] =  9; sbox8[10] =  3; sbox8[11] = 14; sbox8[12] =  5; sbox8[13] =  0; sbox8[14] = 12; sbox8[15] =  7;
    sbox8[16] =  1; sbox8[17] = 15; sbox8[18] = 13; sbox8[19] =  8; sbox8[20] = 10; sbox8[21] =  3; sbox8[22] =  7; sbox8[23] =  4;
    sbox8[24] = 12; sbox8[25] =  5; sbox8[26] =  6; sbox8[27] = 11; sbox8[28] =  0; sbox8[29] = 14; sbox8[30] =  9; sbox8[31] =  2;
    sbox8[32] =  7; sbox8[33] = 11; sbox8[34] =  4; sbox8[35] =  1; sbox8[36] =  9; sbox8[37] = 12; sbox8[38] = 14; sbox8[39] =  2;
    sbox8[40] =  0; sbox8[41] =  6; sbox8[42] = 10; sbox8[43] = 13; sbox8[44] = 15; sbox8[45] =  3; sbox8[46] =  5; sbox8[47] =  8;
    sbox8[48] =  2; sbox8[49] =  1; sbox8[50] = 14; sbox8[51] =  7; sbox8[52] =  4; sbox8[53] = 10; sbox8[54] =  8; sbox8[55] = 13;
    sbox8[56] =  5; sbox8[57] = 12; sbox8[58] =  9; sbox8[59] =  0; sbox8[60] =  3; sbox8[61] =  5; sbox8[62] =  6; sbox8[63] = 11;

    // no_pragma map_to_operator ENCRYPT
    // no_pragma return_port_name key_data_out

    ////////////////////////////////////////////////////////////////////////////////
    // process key
    ////////////////////////////////////////////////////////////////////////////////

    //
    // split into left half and right half
    //

    kl[1:28] = key_in[ 1:28];
    kr[1:28] = key_in[29:56];

    //
    // Table 12.3, Number of Key Bits Shifted per Round (checked)
    //

    if (round == 4'b0000)
      begin
        ks[ 1:28] = { kl[2:28], kl[1]   }; // left shift 1
        ks[29:56] = { kr[2:28], kr[1]   }; // left shift 1
      end
    else if ( (round == 4'b0001) || (round == 4'b1000) || (round == 4'b1111) )
      begin
        ks[ 1:28] = { kl[2:28], kl[1]   }; // left shift 1
        ks[29:56] = { kr[2:28], kr[1]   }; // left shift 1
      end
    else
      begin
        ks[ 1:28] = { kl[3:28], kl[1:2] }; // left shift 2
        ks[29:56] = { kr[3:28], kr[1:2] }; // left shift 2
      end

    //
    // Table 12.4, Compression Permutation (checked)
    //

    k[1:48] = {
      ks[14], ks[17], ks[11], ks[24], ks[ 1], ks[ 5], ks[ 3], ks[28], ks[15], ks[ 6], ks[21], ks[10],
      ks[23], ks[19], ks[12], ks[ 4], ks[26], ks[ 8], ks[16], ks[ 7], ks[27], ks[20], ks[13], ks[ 2],
      ks[41], ks[52], ks[31], ks[37], ks[47], ks[55], ks[30], ks[40], ks[51], ks[45], ks[33], ks[48],
      ks[44], ks[49], ks[39], ks[56], ks[34], ks[53], ks[46], ks[42], ks[50], ks[36], ks[29], ks[32]
      };

    //
    // create key_out
    //

    key_out[1:64] = { ks[1:56], 8'h00 };

    ////////////////////////////////////////////////////////////////////////////////
    // process data
    ////////////////////////////////////////////////////////////////////////////////

    //
    // split into left half and right half
    //

    l[1:32] = data_in[ 1:32];
    r[1:32] = data_in[33:64];

    //
    // Table 12.5, Expansion Permutation (checked)
    //

    e[1:48] = {
      r[32], r[ 1], r[ 2], r[ 3], r[ 4], r[ 5], r[ 4], r[ 5], r[ 6], r[ 7], r[ 8], r[ 9],
      r[ 8], r[ 9], r[10], r[11], r[12], r[13], r[12], r[13], r[14], r[15], r[16], r[17],
      r[16], r[17], r[18], r[19], r[20], r[21], r[20], r[21], r[22], r[23], r[24], r[25],
      r[24], r[25], r[26], r[27], r[28], r[29], r[28], r[29], r[30], r[31], r[32], r[ 1]
      };

    //
    // xor with key
    //

    x[1:48] = e[1:48] ^ k[1:48];

    //
    // S-Box Substitution
    //

    sbox1_addr[5:0] = { x[ 1], x[ 6], x[ 2: 5] }; //  1 -  6
    sbox2_addr[5:0] = { x[ 7], x[12], x[ 8:11] }; //  7 - 12
    sbox3_addr[5:0] = { x[13], x[18], x[14:17] }; // 13 - 18
    sbox4_addr[5:0] = { x[19], x[24], x[20:23] }; // 19 - 24
    sbox5_addr[5:0] = { x[25], x[30], x[26:29] }; // 25 - 30
    sbox6_addr[5:0] = { x[31], x[36], x[32:35] }; // 31 - 36
    sbox7_addr[5:0] = { x[37], x[42], x[38:41] }; // 37 - 42
    sbox8_addr[5:0] = { x[43], x[48], x[44:47] }; // 43 - 48

    s[ 1: 4] = sbox1[sbox1_addr];
    s[ 5: 8] = sbox2[sbox2_addr];
    s[ 9:12] = sbox3[sbox3_addr]; //
    s[13:16] = sbox4[sbox4_addr]; //
    s[17:20] = sbox5[sbox5_addr];
    s[21:24] = sbox6[sbox6_addr];
    s[25:28] = sbox7[sbox7_addr]; //
    s[29:32] = sbox8[sbox8_addr]; //

    //
    // Table 12.7, P-Box Permutation (checked)
    //

    p[1:32] = {
      s[16], s[ 7], s[20], s[21], s[29], s[12], s[28], s[17],
      s[ 1], s[15], s[23], s[26], s[ 5], s[18], s[31], s[10],
      s[ 2], s[ 8], s[24], s[14], s[32], s[27], s[ 3], s[ 9],
      s[19], s[13], s[30], s[ 6], s[22], s[11], s[ 4], s[25]
      };


    //
    // create data_out
    //

    data_out[ 1:32] = r[1:32];           // left half
    data_out[33:64] = l[1:32] ^ p[1:32]; // right half

    //
    // create key_data_out
    //

    key_data_out[1:128] = { key_out[1:64], data_out[1:64] };

    encrypt[1:128] = key_data_out[1:128];

  end
endfunction

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

function automatic [1:128] decrypt;
input   [1:64]  key_in;
input   [1:64]  data_in;
input   [3:0]   round;

integer         loop_count;

reg     [5:0]   sbox1_addr;
reg     [5:0]   sbox2_addr;
reg     [5:0]   sbox3_addr;
reg     [5:0]   sbox4_addr;
reg     [5:0]   sbox5_addr;
reg     [5:0]   sbox6_addr;
reg     [5:0]   sbox7_addr;
reg     [5:0]   sbox8_addr;

reg     [3:0]   sbox1[63:0];
reg     [3:0]   sbox2[63:0];
reg     [3:0]   sbox3[63:0];
reg     [3:0]   sbox4[63:0];
reg     [3:0]   sbox5[63:0];
reg     [3:0]   sbox6[63:0];
reg     [3:0]   sbox7[63:0];
reg     [3:0]   sbox8[63:0];

reg     [1:32]  l;              // left half of data_in
reg     [1:32]  r;              // right half of data_in
reg     [1:48]  e;              // expansion permutation of r
reg     [1:48]  x;              // e xor k
reg     [1:32]  s;              // s-box substitution of x
reg     [1:32]  p;              // p-box permutation of s

reg     [1:28]  kl;             // left half of key_in
reg     [1:28]  kr;             // right half of key_in
reg     [1:56]  ks;             // shifted halfs of key_in
reg     [1:48]  k;              // compression permutation of ks

reg     [1:64]  key_out;
reg     [1:64]  data_out;
reg     [1:128] key_data_out;

  begin

    sbox1[ 0] = 14; sbox1[ 1] =  4; sbox1[ 2] = 13; sbox1[ 3] =  1; sbox1[ 4] =  2; sbox1[ 5] = 15; sbox1[ 6] = 11; sbox1[ 7] =  8;
    sbox1[ 8] =  3; sbox1[ 9] = 10; sbox1[10] =  6; sbox1[11] = 12; sbox1[12] =  5; sbox1[13] =  9; sbox1[14] =  0; sbox1[15] =  7;
    sbox1[16] =  0; sbox1[17] = 15; sbox1[18] =  7; sbox1[19] =  4; sbox1[20] = 14; sbox1[21] =  2; sbox1[22] = 13; sbox1[23] =  1;
    sbox1[24] = 10; sbox1[25] =  6; sbox1[26] = 12; sbox1[27] = 11; sbox1[28] =  9; sbox1[29] =  5; sbox1[30] =  3; sbox1[31] =  8;
    sbox1[32] =  4; sbox1[33] =  1; sbox1[34] = 14; sbox1[35] =  8; sbox1[36] = 13; sbox1[37] =  6; sbox1[38] =  2; sbox1[39] = 11;
    sbox1[40] = 15; sbox1[41] = 12; sbox1[42] =  9; sbox1[43] =  7; sbox1[44] =  3; sbox1[45] = 10; sbox1[46] =  5; sbox1[47] =  0;
    sbox1[48] = 15; sbox1[49] = 12; sbox1[50] =  8; sbox1[51] =  2; sbox1[52] =  4; sbox1[53] =  9; sbox1[54] =  1; sbox1[55] =  7;
    sbox1[56] =  5; sbox1[57] = 11; sbox1[58] =  3; sbox1[59] = 14; sbox1[60] = 10; sbox1[61] =  0; sbox1[62] =  6; sbox1[63] = 13;

    sbox2[ 0] = 15; sbox2[ 1] =  1; sbox2[ 2] =  8; sbox2[ 3] = 14; sbox2[ 4] =  6; sbox2[ 5] = 11; sbox2[ 6] =  3; sbox2[ 7] =  4;
    sbox2[ 8] =  9; sbox2[ 9] =  7; sbox2[10] =  2; sbox2[11] = 13; sbox2[12] = 12; sbox2[13] =  0; sbox2[14] =  5; sbox2[15] = 10;
    sbox2[16] =  3; sbox2[17] = 13; sbox2[18] =  4; sbox2[19] =  7; sbox2[20] = 15; sbox2[21] =  2; sbox2[22] =  8; sbox2[23] = 14;
    sbox2[24] = 12; sbox2[25] =  0; sbox2[26] =  1; sbox2[27] = 10; sbox2[28] =  6; sbox2[29] =  9; sbox2[30] = 11; sbox2[31] =  5;
    sbox2[32] =  0; sbox2[33] =  4; sbox2[34] =  7; sbox2[35] = 11; sbox2[36] = 10; sbox2[37] =  4; sbox2[38] = 13; sbox2[39] =  1;
    sbox2[40] =  5; sbox2[41] =  8; sbox2[42] = 12; sbox2[43] =  6; sbox2[44] =  9; sbox2[45] =  3; sbox2[46] =  2; sbox2[47] = 15;
    sbox2[48] = 13; sbox2[49] =  8; sbox2[50] = 10; sbox2[51] =  1; sbox2[52] =  3; sbox2[53] = 15; sbox2[54] =  4; sbox2[55] =  2;
    sbox2[56] = 11; sbox2[57] =  6; sbox2[58] =  7; sbox2[59] = 12; sbox2[60] =  0; sbox2[61] =  5; sbox2[62] = 14; sbox2[63] =  9;

    sbox3[ 0] = 10; sbox3[ 1] =  0; sbox3[ 2] =  9; sbox3[ 3] = 14; sbox3[ 4] =  6; sbox3[ 5] =  3; sbox3[ 6] = 15; sbox3[ 7] =  5;
    sbox3[ 8] =  1; sbox3[ 9] = 13; sbox3[10] = 12; sbox3[11] =  7; sbox3[12] = 11; sbox3[13] =  4; sbox3[14] =  2; sbox3[15] =  8;
    sbox3[16] = 13; sbox3[17] =  7; sbox3[18] =  0; sbox3[19] =  9; sbox3[20] =  3; sbox3[21] =  4; sbox3[22] =  6; sbox3[23] = 10;
    sbox3[24] =  2; sbox3[25] =  8; sbox3[26] =  5; sbox3[27] = 14; sbox3[28] = 12; sbox3[29] = 11; sbox3[30] = 15; sbox3[31] =  1;
    sbox3[32] = 13; sbox3[33] =  6; sbox3[34] =  4; sbox3[35] =  9; sbox3[36] =  8; sbox3[37] = 15; sbox3[38] =  3; sbox3[39] =  0;
    sbox3[40] = 11; sbox3[41] =  1; sbox3[42] =  2; sbox3[43] = 12; sbox3[44] =  5; sbox3[45] = 10; sbox3[46] = 14; sbox3[47] =  7;
    sbox3[48] =  1; sbox3[49] = 10; sbox3[50] = 13; sbox3[51] =  0; sbox3[52] =  6; sbox3[53] =  9; sbox3[54] =  8; sbox3[55] =  7;
    sbox3[56] =  4; sbox3[57] = 15; sbox3[58] = 14; sbox3[59] =  3; sbox3[60] = 11; sbox3[61] =  5; sbox3[62] =  2; sbox3[63] = 12;

    sbox4[ 0] =  7; sbox4[ 1] = 13; sbox4[ 2] = 14; sbox4[ 3] =  3; sbox4[ 4] =  0; sbox4[ 5] =  6; sbox4[ 6] =  9; sbox4[ 7] = 10;
    sbox4[ 8] =  1; sbox4[ 9] =  2; sbox4[10] =  8; sbox4[11] =  5; sbox4[12] = 11; sbox4[13] = 12; sbox4[14] =  4; sbox4[15] = 15;
    sbox4[16] = 13; sbox4[17] =  8; sbox4[18] = 11; sbox4[19] =  5; sbox4[20] =  6; sbox4[21] = 15; sbox4[22] =  0; sbox4[23] =  3;
    sbox4[24] =  4; sbox4[25] =  7; sbox4[26] =  2; sbox4[27] = 12; sbox4[28] =  1; sbox4[29] = 10; sbox4[30] = 14; sbox4[31] =  9;
    sbox4[32] = 10; sbox4[33] =  6; sbox4[34] =  9; sbox4[35] =  0; sbox4[36] = 12; sbox4[37] = 11; sbox4[38] =  7; sbox4[39] = 13;
    sbox4[40] = 15; sbox4[41] =  1; sbox4[42] =  3; sbox4[43] = 14; sbox4[44] =  5; sbox4[45] =  2; sbox4[46] =  8; sbox4[47] =  4;
    sbox4[48] =  3; sbox4[49] = 15; sbox4[50] =  0; sbox4[51] =  6; sbox4[52] = 10; sbox4[53] =  1; sbox4[54] = 13; sbox4[55] =  8;
    sbox4[56] =  9; sbox4[57] =  4; sbox4[58] =  5; sbox4[59] = 11; sbox4[60] = 12; sbox4[61] =  7; sbox4[62] =  2; sbox4[63] = 14;

    sbox5[ 0] =  2; sbox5[ 1] = 12; sbox5[ 2] =  4; sbox5[ 3] =  1; sbox5[ 4] =  7; sbox5[ 5] = 10; sbox5[ 6] = 11; sbox5[ 7] =  6;
    sbox5[ 8] =  8; sbox5[ 9] =  5; sbox5[10] =  3; sbox5[11] = 15; sbox5[12] = 13; sbox5[13] =  0; sbox5[14] = 14; sbox5[15] =  9;
    sbox5[16] = 14; sbox5[17] = 11; sbox5[18] =  2; sbox5[19] = 12; sbox5[20] =  4; sbox5[21] =  7; sbox5[22] = 13; sbox5[23] =  1;
    sbox5[24] =  5; sbox5[25] =  0; sbox5[26] = 15; sbox5[27] = 10; sbox5[28] =  3; sbox5[29] =  9; sbox5[30] =  8; sbox5[31] =  6;
    sbox5[32] =  4; sbox5[33] =  2; sbox5[34] =  1; sbox5[35] = 11; sbox5[36] = 10; sbox5[37] = 13; sbox5[38] =  7; sbox5[39] =  8;
    sbox5[40] = 15; sbox5[41] =  9; sbox5[42] = 12; sbox5[43] =  5; sbox5[44] =  6; sbox5[45] =  3; sbox5[46] =  0; sbox5[47] = 14;
    sbox5[48] = 11; sbox5[49] =  8; sbox5[50] = 12; sbox5[51] =  7; sbox5[52] =  1; sbox5[53] = 14; sbox5[54] =  2; sbox5[55] = 13;
    sbox5[56] =  6; sbox5[57] = 15; sbox5[58] =  0; sbox5[59] =  9; sbox5[60] = 10; sbox5[61] =  4; sbox5[62] =  5; sbox5[63] =  3;

    sbox6[ 0] = 12; sbox6[ 1] =  1; sbox6[ 2] = 10; sbox6[ 3] = 15; sbox6[ 4] =  9; sbox6[ 5] =  2; sbox6[ 6] =  6; sbox6[ 7] =  8;
    sbox6[ 8] =  0; sbox6[ 9] = 13; sbox6[10] =  3; sbox6[11] =  4; sbox6[12] = 14; sbox6[13] =  7; sbox6[14] =  5; sbox6[15] = 11;
    sbox6[16] = 10; sbox6[17] = 15; sbox6[18] =  4; sbox6[19] =  2; sbox6[20] =  7; sbox6[21] = 12; sbox6[22] =  9; sbox6[23] =  5;
    sbox6[24] =  6; sbox6[25] =  1; sbox6[26] = 13; sbox6[27] = 14; sbox6[28] =  0; sbox6[29] = 11; sbox6[30] =  3; sbox6[31] =  8;
    sbox6[32] =  9; sbox6[33] = 14; sbox6[34] = 15; sbox6[35] =  5; sbox6[36] =  2; sbox6[37] =  8; sbox6[38] = 12; sbox6[39] =  3;
    sbox6[40] =  7; sbox6[41] =  0; sbox6[42] =  4; sbox6[43] = 10; sbox6[44] =  1; sbox6[45] = 13; sbox6[46] = 11; sbox6[47] =  6;
    sbox6[48] =  4; sbox6[49] =  3; sbox6[50] =  2; sbox6[51] = 12; sbox6[52] =  9; sbox6[53] =  5; sbox6[54] = 15; sbox6[55] = 10;
    sbox6[56] = 11; sbox6[57] = 14; sbox6[58] =  1; sbox6[59] =  7; sbox6[60] =  6; sbox6[61] =  0; sbox6[62] =  8; sbox6[63] = 13;

    sbox7[ 0] =  4; sbox7[ 1] = 11; sbox7[ 2] =  2; sbox7[ 3] = 14; sbox7[ 4] = 15; sbox7[ 5] =  0; sbox7[ 6] =  8; sbox7[ 7] = 13;
    sbox7[ 8] =  3; sbox7[ 9] = 12; sbox7[10] =  9; sbox7[11] =  7; sbox7[12] =  5; sbox7[13] = 10; sbox7[14] =  6; sbox7[15] =  1;
    sbox7[16] = 13; sbox7[17] =  0; sbox7[18] = 11; sbox7[19] =  7; sbox7[20] =  4; sbox7[21] =  9; sbox7[22] =  1; sbox7[23] = 10;
    sbox7[24] = 14; sbox7[25] =  3; sbox7[26] =  5; sbox7[27] = 12; sbox7[28] =  2; sbox7[29] = 15; sbox7[30] =  8; sbox7[31] =  6;
    sbox7[32] =  1; sbox7[33] =  4; sbox7[34] = 11; sbox7[35] = 13; sbox7[36] = 12; sbox7[37] =  3; sbox7[38] =  7; sbox7[39] = 14;
    sbox7[40] = 10; sbox7[41] = 15; sbox7[42] =  6; sbox7[43] =  8; sbox7[44] =  0; sbox7[45] =  5; sbox7[46] =  9; sbox7[47] =  2;
    sbox7[48] =  6; sbox7[49] = 11; sbox7[50] = 13; sbox7[51] =  8; sbox7[52] =  1; sbox7[53] =  4; sbox7[54] = 10; sbox7[55] =  7;
    sbox7[56] =  9; sbox7[57] =  5; sbox7[58] =  0; sbox7[59] = 15; sbox7[60] = 14; sbox7[61] =  2; sbox7[62] =  3; sbox7[63] = 12;

    sbox8[ 0] = 13; sbox8[ 1] =  2; sbox8[ 2] =  8; sbox8[ 3] =  4; sbox8[ 4] =  6; sbox8[ 5] = 15; sbox8[ 6] = 11; sbox8[ 7] =  1;
    sbox8[ 8] = 10; sbox8[ 9] =  9; sbox8[10] =  3; sbox8[11] = 14; sbox8[12] =  5; sbox8[13] =  0; sbox8[14] = 12; sbox8[15] =  7;
    sbox8[16] =  1; sbox8[17] = 15; sbox8[18] = 13; sbox8[19] =  8; sbox8[20] = 10; sbox8[21] =  3; sbox8[22] =  7; sbox8[23] =  4;
    sbox8[24] = 12; sbox8[25] =  5; sbox8[26] =  6; sbox8[27] = 11; sbox8[28] =  0; sbox8[29] = 14; sbox8[30] =  9; sbox8[31] =  2;
    sbox8[32] =  7; sbox8[33] = 11; sbox8[34] =  4; sbox8[35] =  1; sbox8[36] =  9; sbox8[37] = 12; sbox8[38] = 14; sbox8[39] =  2;
    sbox8[40] =  0; sbox8[41] =  6; sbox8[42] = 10; sbox8[43] = 13; sbox8[44] = 15; sbox8[45] =  3; sbox8[46] =  5; sbox8[47] =  8;
    sbox8[48] =  2; sbox8[49] =  1; sbox8[50] = 14; sbox8[51] =  7; sbox8[52] =  4; sbox8[53] = 10; sbox8[54] =  8; sbox8[55] = 13;
    sbox8[56] =  5; sbox8[57] = 12; sbox8[58] =  9; sbox8[59] =  0; sbox8[60] =  3; sbox8[61] =  5; sbox8[62] =  6; sbox8[63] = 11;

    // no_pragma map_to_operator DECRYPT
    // no_pragma return_port_name key_data_out

    ////////////////////////////////////////////////////////////////////////////////
    // process key
    ////////////////////////////////////////////////////////////////////////////////

    //
    // split into left half and right half
    //

    kl[1:28] = key_in[ 1:28];
    kr[1:28] = key_in[29:56];

    //
    // Table 12.3, Number of Key Bits Shifted per Round (checked)
    //

    if (round == 4'b0000)
      begin
        ks[ 1:28] = { kl[1:28]            }; // right shift 0
        ks[29:56] = { kr[1:28]            }; // right shift 0
      end
    else if ( (round == 4'b0001) || (round == 4'b1000) || (round == 4'b1111) )
      begin
        ks[ 1:28] = { kl[28],    kl[1:27] }; // right shift 1
        ks[29:56] = { kr[28],    kr[1:27] }; // right shift 1
      end
    else
      begin
        ks[ 1:28] = { kl[27:28], kl[1:26] }; // right shift 2
        ks[29:56] = { kr[27:28], kr[1:26] }; // right shift 2
      end

    //
    // Table 12.4, Compression Permutation (checked)
    //

    k[1:48] = {
      ks[14], ks[17], ks[11], ks[24], ks[ 1], ks[ 5], ks[ 3], ks[28], ks[15], ks[ 6], ks[21], ks[10],
      ks[23], ks[19], ks[12], ks[ 4], ks[26], ks[ 8], ks[16], ks[ 7], ks[27], ks[20], ks[13], ks[ 2],
      ks[41], ks[52], ks[31], ks[37], ks[47], ks[55], ks[30], ks[40], ks[51], ks[45], ks[33], ks[48],
      ks[44], ks[49], ks[39], ks[56], ks[34], ks[53], ks[46], ks[42], ks[50], ks[36], ks[29], ks[32]
      };

    //
    // create key_out
    //

    key_out[1:64] = { ks[1:56], 8'h00 };

    ////////////////////////////////////////////////////////////////////////////////
    // process data
    ////////////////////////////////////////////////////////////////////////////////

    //
    // split into left half and right half
    //

    l[1:32] = data_in[ 1:32];
    r[1:32] = data_in[33:64];

    //
    // Table 12.5, Expansion Permutation (checked)
    //

    e[1:48] = {
      r[32], r[ 1], r[ 2], r[ 3], r[ 4], r[ 5], r[ 4], r[ 5], r[ 6], r[ 7], r[ 8], r[ 9],
      r[ 8], r[ 9], r[10], r[11], r[12], r[13], r[12], r[13], r[14], r[15], r[16], r[17],
      r[16], r[17], r[18], r[19], r[20], r[21], r[20], r[21], r[22], r[23], r[24], r[25],
      r[24], r[25], r[26], r[27], r[28], r[29], r[28], r[29], r[30], r[31], r[32], r[ 1]
      };

    //
    // xor with key
    //

    x[1:48] = e[1:48] ^ k[1:48];

    //
    // S-Box Substitution
    //

    sbox1_addr[5:0] = { x[ 1], x[ 6], x[ 2: 5] }; //  1 -  6
    sbox2_addr[5:0] = { x[ 7], x[12], x[ 8:11] }; //  7 - 12
    sbox3_addr[5:0] = { x[13], x[18], x[14:17] }; // 13 - 18
    sbox4_addr[5:0] = { x[19], x[24], x[20:23] }; // 19 - 24
    sbox5_addr[5:0] = { x[25], x[30], x[26:29] }; // 25 - 30
    sbox6_addr[5:0] = { x[31], x[36], x[32:35] }; // 31 - 36
    sbox7_addr[5:0] = { x[37], x[42], x[38:41] }; // 37 - 42
    sbox8_addr[5:0] = { x[43], x[48], x[44:47] }; // 43 - 48

    s[ 1: 4] = sbox1[sbox1_addr];
    s[ 5: 8] = sbox2[sbox2_addr];
    s[ 9:12] = sbox3[sbox3_addr];
    s[13:16] = sbox4[sbox4_addr];
    s[17:20] = sbox5[sbox5_addr];
    s[21:24] = sbox6[sbox6_addr];
    s[25:28] = sbox7[sbox7_addr];
    s[29:32] = sbox8[sbox8_addr];

    //
    // Table 12.7, P-Box Permutation (checked)
    //

    p[1:32] = {
      s[16], s[ 7], s[20], s[21], s[29], s[12], s[28], s[17],
      s[ 1], s[15], s[23], s[26], s[ 5], s[18], s[31], s[10],
      s[ 2], s[ 8], s[24], s[14], s[32], s[27], s[ 3], s[ 9],
      s[19], s[13], s[30], s[ 6], s[22], s[11], s[ 4], s[25]
      };


    //
    // create data_out
    //

    data_out[ 1:32] = r[1:32];           // left half
    data_out[33:64] = l[1:32] ^ p[1:32]; // right half

    //
    // create key_data_out
    //

    key_data_out[1:128] = { key_out[1:64], data_out[1:64] };

    decrypt[1:128] = key_data_out[1:128];

  end
endfunction
//sde_make_gen_on

////////////////////////////////////////////////////////////////////////////////
// end of file
////////////////////////////////////////////////////////////////////////////////
