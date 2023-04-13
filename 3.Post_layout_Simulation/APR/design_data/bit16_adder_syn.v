/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : R-2020.09-SP5
// Date      : Wed Jan  5 20:45:33 2022
/////////////////////////////////////////////////////////////


module controller ( clk, rst, LFSR_load, MISR_load, finish );
  input clk, rst;
  output LFSR_load, MISR_load, finish;
  wire   N8, N9, N10, N11, n1, n2, n5, n6, n7, n80, n90, n100, n110, n3, n4;
  wire   [2:0] current_state;
  wire   [4:0] count;
  wire   [1:0] next_state;
  wire   [4:2] add_119_carry;

  DFFRQX2 current_state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(n1), .Q(
        current_state[1]) );
  DFFRQX2 current_state_reg_2_ ( .D(n3), .CK(clk), .RN(n1), .Q(
        current_state[2]) );
  DFFRQX2 count_reg_2_ ( .D(N9), .CK(clk), .RN(n1), .Q(count[2]) );
  DFFRQX2 current_state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(n1), .Q(
        current_state[0]) );
  DFFRQX2 count_reg_1_ ( .D(N8), .CK(clk), .RN(n1), .Q(count[1]) );
  DFFRQX2 count_reg_4_ ( .D(N11), .CK(clk), .RN(n1), .Q(count[4]) );
  DFFRQX2 count_reg_3_ ( .D(N10), .CK(clk), .RN(n1), .Q(count[3]) );
  DFFRX1 count_reg_0_ ( .D(n2), .CK(clk), .RN(n1), .Q(count[0]), .QN(n2) );
  INVX2 U3 ( .A(n6), .Y(MISR_load) );
  ADDHX1 U4 ( .A(count[1]), .B(count[0]), .CO(add_119_carry[2]), .S(N8) );
  ADDHX1 U5 ( .A(count[2]), .B(add_119_carry[2]), .CO(add_119_carry[3]), .S(N9) );
  ADDHX1 U6 ( .A(count[3]), .B(add_119_carry[3]), .CO(add_119_carry[4]), .S(
        N10) );
  AOI2BB1X2 U7 ( .A0N(n80), .A1N(n90), .B0(current_state[2]), .Y(next_state[0]) );
  NOR4BX2 U8 ( .AN(count[1]), .B(n110), .C(current_state[0]), .D(n2), .Y(n80)
         );
  AOI21X1 U9 ( .A0(n7), .A1(current_state[0]), .B0(current_state[1]), .Y(n90)
         );
  NAND3XL U10 ( .A(count[3]), .B(count[2]), .C(count[4]), .Y(n110) );
  AND3X2 U11 ( .A(count[2]), .B(count[1]), .C(n100), .Y(n7) );
  NOR3X1 U12 ( .A(n2), .B(count[4]), .C(count[3]), .Y(n100) );
  OAI2BB2X2 U13 ( .B0(current_state[0]), .B1(n6), .A0N(n7), .A1N(LFSR_load), 
        .Y(next_state[1]) );
  NOR3BX1 U14 ( .AN(current_state[0]), .B(current_state[1]), .C(
        current_state[2]), .Y(LFSR_load) );
  NOR3X1 U15 ( .A(current_state[0]), .B(current_state[1]), .C(n4), .Y(finish)
         );
  INVX2 U16 ( .A(n5), .Y(n3) );
  AOI31X1 U17 ( .A0(current_state[1]), .A1(n4), .A2(current_state[0]), .B0(
        finish), .Y(n5) );
  INVX2 U18 ( .A(current_state[2]), .Y(n4) );
  NAND2X2 U19 ( .A(current_state[1]), .B(n4), .Y(n6) );
  INVX2 U20 ( .A(rst), .Y(n1) );
  XOR2X1 U21 ( .A(add_119_carry[4]), .B(count[4]), .Y(N11) );
endmodule


module LFSR ( clk, rst, load, data_in, data_out );
  output [15:0] data_out;
  input clk, rst, load, data_in;
  wire   N4, N5, n1, n2;

  DFFRQX2 data_out_reg_10_ ( .D(data_out[0]), .CK(clk), .RN(n1), .Q(
        data_out[10]) );
  DFFRQX2 data_out_reg_9_ ( .D(data_out[1]), .CK(clk), .RN(n1), .Q(data_out[9]) );
  DFFRQX2 data_out_reg_12_ ( .D(data_out[2]), .CK(clk), .RN(n1), .Q(
        data_out[12]) );
  DFFRQX2 data_out_reg_13_ ( .D(data_out[3]), .CK(clk), .RN(n1), .Q(
        data_out[13]) );
  DFFRQX2 data_out_reg_7_ ( .D(data_out[3]), .CK(clk), .RN(n1), .Q(data_out[7]) );
  DFFRQX2 data_out_reg_14_ ( .D(data_out[4]), .CK(clk), .RN(n1), .Q(
        data_out[14]) );
  DFFRQX2 data_out_reg_8_ ( .D(data_out[4]), .CK(clk), .RN(n1), .Q(data_out[8]) );
  DFFRQX2 data_out_reg_11_ ( .D(data_out[5]), .CK(clk), .RN(n1), .Q(
        data_out[11]) );
  DFFRQX2 data_out_reg_15_ ( .D(data_out[6]), .CK(clk), .RN(n1), .Q(
        data_out[15]) );
  DFFRQX2 data_out_reg_6_ ( .D(data_out[5]), .CK(clk), .RN(n1), .Q(data_out[6]) );
  DFFRQX2 data_out_reg_2_ ( .D(data_out[1]), .CK(clk), .RN(n1), .Q(data_out[2]) );
  DFFRQX2 data_out_reg_3_ ( .D(data_out[2]), .CK(clk), .RN(n1), .Q(data_out[3]) );
  DFFRQX2 data_out_reg_4_ ( .D(data_out[3]), .CK(clk), .RN(n1), .Q(data_out[4]) );
  DFFRQX2 data_out_reg_0_ ( .D(N4), .CK(clk), .RN(n1), .Q(data_out[0]) );
  DFFRQX2 data_out_reg_5_ ( .D(data_out[4]), .CK(clk), .RN(n1), .Q(data_out[5]) );
  DFFRQX2 data_out_reg_1_ ( .D(N5), .CK(clk), .RN(n1), .Q(data_out[1]) );
  OAI2BB2X2 U3 ( .B0(load), .B1(n2), .A0N(load), .A1N(data_in), .Y(N4) );
  XNOR2X1 U4 ( .A(data_out[5]), .B(data_out[1]), .Y(n2) );
  XOR2X1 U5 ( .A(data_out[4]), .B(data_out[0]), .Y(N5) );
  INVX2 U6 ( .A(rst), .Y(n1) );
endmodule


module Adder_DW01_add_0 ( A, B, CI, SUM, CO );
  input [16:0] A;
  input [16:0] B;
  output [16:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29;

  OAI2BB1X1 U1 ( .A0N(n1), .A1N(A[15]), .B0(n2), .Y(SUM[16]) );
  OAI21X1 U2 ( .A0(A[15]), .A1(n1), .B0(B[15]), .Y(n2) );
  OAI2BB1X1 U3 ( .A0N(n3), .A1N(A[14]), .B0(n4), .Y(n1) );
  OAI21X1 U4 ( .A0(A[14]), .A1(n3), .B0(B[14]), .Y(n4) );
  OAI2BB1X1 U5 ( .A0N(n5), .A1N(A[13]), .B0(n6), .Y(n3) );
  OAI21X1 U6 ( .A0(A[13]), .A1(n5), .B0(B[13]), .Y(n6) );
  OAI2BB1X1 U7 ( .A0N(n7), .A1N(A[12]), .B0(n8), .Y(n5) );
  OAI21X1 U8 ( .A0(A[12]), .A1(n7), .B0(B[12]), .Y(n8) );
  OAI2BB1X1 U9 ( .A0N(n9), .A1N(A[11]), .B0(n10), .Y(n7) );
  OAI21X1 U10 ( .A0(A[11]), .A1(n9), .B0(B[11]), .Y(n10) );
  OAI2BB1X1 U11 ( .A0N(n11), .A1N(A[10]), .B0(n12), .Y(n9) );
  OAI21X1 U12 ( .A0(A[10]), .A1(n11), .B0(B[10]), .Y(n12) );
  OAI2BB1X1 U13 ( .A0N(n13), .A1N(A[9]), .B0(n14), .Y(n11) );
  OAI21X1 U14 ( .A0(A[9]), .A1(n13), .B0(B[9]), .Y(n14) );
  OAI2BB1X1 U15 ( .A0N(n15), .A1N(A[8]), .B0(n16), .Y(n13) );
  OAI21X1 U16 ( .A0(A[8]), .A1(n15), .B0(B[8]), .Y(n16) );
  OAI2BB1X1 U17 ( .A0N(n17), .A1N(A[7]), .B0(n18), .Y(n15) );
  OAI21X1 U18 ( .A0(A[7]), .A1(n17), .B0(B[7]), .Y(n18) );
  OAI2BB1X1 U19 ( .A0N(n19), .A1N(A[6]), .B0(n20), .Y(n17) );
  OAI21X1 U20 ( .A0(A[6]), .A1(n19), .B0(B[6]), .Y(n20) );
  OAI2BB1X1 U21 ( .A0N(n21), .A1N(A[5]), .B0(n22), .Y(n19) );
  OAI21X1 U22 ( .A0(A[5]), .A1(n21), .B0(B[5]), .Y(n22) );
  OAI2BB1X1 U23 ( .A0N(n23), .A1N(A[4]), .B0(n24), .Y(n21) );
  OAI21X1 U24 ( .A0(A[4]), .A1(n23), .B0(B[4]), .Y(n24) );
  OAI2BB1X1 U25 ( .A0N(n25), .A1N(A[3]), .B0(n26), .Y(n23) );
  OAI21X1 U26 ( .A0(A[3]), .A1(n25), .B0(B[3]), .Y(n26) );
  OAI2BB1X1 U27 ( .A0N(n27), .A1N(A[2]), .B0(n28), .Y(n25) );
  OAI21X1 U28 ( .A0(A[2]), .A1(n27), .B0(B[2]), .Y(n28) );
  OAI2BB1X1 U29 ( .A0N(A[1]), .A1N(B[1]), .B0(n29), .Y(n27) );
  OAI211XL U30 ( .A0(A[1]), .A1(B[1]), .B0(A[0]), .C0(B[0]), .Y(n29) );
endmodule


module Adder ( A, B, sum, CI, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] sum;
  input CI;
  output CO;


  Adder_DW01_add_0 add_28 ( .A({1'b0, A}), .B({1'b0, B}), .CI(1'b0), .SUM({CO, 
        sum}), .CO() );
endmodule


module MISR ( clk, rst, load, data_in, data_out );
  input [16:0] data_in;
  output [16:0] data_out;
  input clk, rst, load;
  wire   N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33,
         N34, N35, N36, n1, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13,
         n14, n15, n16, n17, n18, n19, n200, n2;

  DFFRQX2 data_out_reg_0_ ( .D(N20), .CK(clk), .RN(n1), .Q(data_out[0]) );
  DFFRQX2 data_out_reg_10_ ( .D(N30), .CK(clk), .RN(n1), .Q(data_out[10]) );
  DFFRQX2 data_out_reg_1_ ( .D(N21), .CK(clk), .RN(n1), .Q(data_out[1]) );
  DFFRQX2 data_out_reg_15_ ( .D(N35), .CK(clk), .RN(n1), .Q(data_out[15]) );
  DFFRQX2 data_out_reg_2_ ( .D(N22), .CK(clk), .RN(n1), .Q(data_out[2]) );
  DFFRQX2 data_out_reg_3_ ( .D(N23), .CK(clk), .RN(n1), .Q(data_out[3]) );
  DFFRQX2 data_out_reg_4_ ( .D(N24), .CK(clk), .RN(n1), .Q(data_out[4]) );
  DFFRQX2 data_out_reg_5_ ( .D(N25), .CK(clk), .RN(n1), .Q(data_out[5]) );
  DFFRQX2 data_out_reg_6_ ( .D(N26), .CK(clk), .RN(n1), .Q(data_out[6]) );
  DFFRQX2 data_out_reg_7_ ( .D(N27), .CK(clk), .RN(n1), .Q(data_out[7]) );
  DFFRQX2 data_out_reg_8_ ( .D(N28), .CK(clk), .RN(n1), .Q(data_out[8]) );
  DFFRQX2 data_out_reg_11_ ( .D(N31), .CK(clk), .RN(n1), .Q(data_out[11]) );
  DFFRQX2 data_out_reg_12_ ( .D(N32), .CK(clk), .RN(n1), .Q(data_out[12]) );
  DFFRQX2 data_out_reg_13_ ( .D(N33), .CK(clk), .RN(n1), .Q(data_out[13]) );
  DFFRQX2 data_out_reg_9_ ( .D(N29), .CK(clk), .RN(n1), .Q(data_out[9]) );
  DFFRQX2 data_out_reg_16_ ( .D(N36), .CK(clk), .RN(n1), .Q(data_out[16]) );
  DFFRQX2 data_out_reg_14_ ( .D(N34), .CK(clk), .RN(n1), .Q(data_out[14]) );
  INVX2 U3 ( .A(load), .Y(n2) );
  NOR2X2 U4 ( .A(n5), .B(n2), .Y(N34) );
  XNOR2X1 U5 ( .A(data_out[13]), .B(n6), .Y(n5) );
  XOR2X1 U6 ( .A(data_out[16]), .B(data_out[14]), .Y(n6) );
  NOR2X2 U7 ( .A(n9), .B(n2), .Y(N31) );
  XNOR2X1 U8 ( .A(data_out[10]), .B(data_out[11]), .Y(n9) );
  NOR2X2 U9 ( .A(n10), .B(n2), .Y(N30) );
  XNOR2X1 U10 ( .A(data_out[10]), .B(data_out[9]), .Y(n10) );
  NOR2X2 U11 ( .A(n200), .B(n2), .Y(N20) );
  XNOR2X1 U12 ( .A(data_out[0]), .B(data_out[16]), .Y(n200) );
  NOR2X2 U13 ( .A(n3), .B(n2), .Y(N36) );
  XNOR2X1 U14 ( .A(data_out[15]), .B(data_out[16]), .Y(n3) );
  NOR2X2 U15 ( .A(n7), .B(n2), .Y(N33) );
  XNOR2X1 U16 ( .A(data_out[12]), .B(data_out[13]), .Y(n7) );
  NOR2X2 U17 ( .A(n8), .B(n2), .Y(N32) );
  XNOR2X1 U18 ( .A(data_out[11]), .B(data_out[12]), .Y(n8) );
  NOR2X2 U19 ( .A(n11), .B(n2), .Y(N29) );
  XNOR2X1 U20 ( .A(data_out[8]), .B(data_out[9]), .Y(n11) );
  NOR2X2 U21 ( .A(n12), .B(n2), .Y(N28) );
  XNOR2X1 U22 ( .A(data_out[7]), .B(data_out[8]), .Y(n12) );
  NOR2X2 U23 ( .A(n13), .B(n2), .Y(N27) );
  XNOR2X1 U24 ( .A(data_out[6]), .B(data_out[7]), .Y(n13) );
  NOR2X2 U25 ( .A(n14), .B(n2), .Y(N26) );
  XNOR2X1 U26 ( .A(data_out[5]), .B(data_out[6]), .Y(n14) );
  NOR2X2 U27 ( .A(n15), .B(n2), .Y(N25) );
  XNOR2X1 U28 ( .A(data_out[4]), .B(data_out[5]), .Y(n15) );
  NOR2X2 U29 ( .A(n16), .B(n2), .Y(N24) );
  XNOR2X1 U30 ( .A(data_out[3]), .B(data_out[4]), .Y(n16) );
  NOR2X2 U31 ( .A(n17), .B(n2), .Y(N23) );
  XNOR2X1 U32 ( .A(data_out[2]), .B(data_out[3]), .Y(n17) );
  NOR2X2 U33 ( .A(n18), .B(n2), .Y(N22) );
  XNOR2X1 U34 ( .A(data_out[1]), .B(data_out[2]), .Y(n18) );
  NOR2X2 U35 ( .A(n4), .B(n2), .Y(N35) );
  XNOR2X1 U36 ( .A(data_out[14]), .B(data_out[15]), .Y(n4) );
  NAND2X2 U37 ( .A(n19), .B(load), .Y(N21) );
  XNOR2X1 U38 ( .A(data_out[0]), .B(data_out[1]), .Y(n19) );
  INVX2 U39 ( .A(rst), .Y(n1) );
endmodule


module all ( clk, rst, signature, finish );
  output [16:0] signature;
  input clk, rst;
  output finish;
  wire   LFSR_load, MISR_load;
  wire   [15:0] adder_in;
  wire   [16:0] adder_out;

  controller ctrl ( .clk(clk), .rst(rst), .LFSR_load(LFSR_load), .MISR_load(
        MISR_load), .finish(finish) );
  LFSR lfsr ( .clk(clk), .rst(rst), .load(LFSR_load), .data_in(1'b1), 
        .data_out(adder_in) );
  Adder adder ( .A(adder_in), .B({adder_in[0], adder_in[15:1]}), .sum(
        adder_out[15:0]), .CI(1'b0), .CO(adder_out[16]) );
  MISR misr ( .clk(clk), .rst(rst), .load(MISR_load), .data_in(adder_out), 
        .data_out(signature) );
endmodule

