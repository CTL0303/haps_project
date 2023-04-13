/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : R-2020.09-SP5
// Date      : Thu Jan  6 17:10:42 2022
/////////////////////////////////////////////////////////////


module controller ( clk, rst, LFSR_load, MISR_load, finish );
  input clk, rst;
  output LFSR_load, MISR_load, finish;
  wire   N8, N9, N10, N11, n1, n2, n5, n6, n7, n80, n90, n100, n110, n3, n4;
  wire   [2:0] current_state;
  wire   [4:0] count;
  wire   [1:0] next_state;
  wire   [4:2] add_119_carry;

  DFFRQX2 count_reg_2_ ( .D(N9), .CK(clk), .RN(n1), .Q(count[2]) );
  DFFRQX2 current_state_reg_2_ ( .D(n3), .CK(clk), .RN(n1), .Q(
        current_state[2]) );
  DFFRQX2 current_state_reg_1_ ( .D(next_state[1]), .CK(clk), .RN(n1), .Q(
        current_state[1]) );
  DFFRQX2 count_reg_1_ ( .D(N8), .CK(clk), .RN(n1), .Q(count[1]) );
  DFFRQX2 current_state_reg_0_ ( .D(next_state[0]), .CK(clk), .RN(n1), .Q(
        current_state[0]) );
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
  wire   N4, N5, n1, n2, n3;

  DFFRHQX4 data_out_reg_3_ ( .D(data_out[2]), .CK(clk), .RN(n3), .Q(
        data_out[3]) );
  DFFRQX2 data_out_reg_15_ ( .D(data_out[6]), .CK(clk), .RN(n3), .Q(
        data_out[15]) );
  DFFRQX2 data_out_reg_14_ ( .D(data_out[4]), .CK(clk), .RN(n3), .Q(
        data_out[14]) );
  DFFRHQX4 data_out_reg_0_ ( .D(N4), .CK(clk), .RN(n3), .Q(data_out[0]) );
  DFFRHQX2 data_out_reg_10_ ( .D(data_out[0]), .CK(clk), .RN(n3), .Q(
        data_out[10]) );
  DFFRHQX4 data_out_reg_4_ ( .D(data_out[3]), .CK(clk), .RN(n3), .Q(
        data_out[4]) );
  DFFRHQX2 data_out_reg_9_ ( .D(data_out[1]), .CK(clk), .RN(n3), .Q(
        data_out[9]) );
  DFFRHQX2 data_out_reg_8_ ( .D(data_out[4]), .CK(clk), .RN(n3), .Q(
        data_out[8]) );
  DFFRHQX8 data_out_reg_1_ ( .D(N5), .CK(clk), .RN(n3), .Q(data_out[1]) );
  DFFRHQX2 data_out_reg_13_ ( .D(data_out[3]), .CK(clk), .RN(n3), .Q(
        data_out[13]) );
  DFFRHQX2 data_out_reg_11_ ( .D(data_out[5]), .CK(clk), .RN(n3), .Q(
        data_out[11]) );
  DFFRHQX2 data_out_reg_12_ ( .D(data_out[2]), .CK(clk), .RN(n3), .Q(
        data_out[12]) );
  DFFRHQX2 data_out_reg_5_ ( .D(data_out[4]), .CK(clk), .RN(n3), .Q(
        data_out[5]) );
  DFFRHQX2 data_out_reg_7_ ( .D(data_out[3]), .CK(clk), .RN(n3), .Q(
        data_out[7]) );
  DFFRHQX4 data_out_reg_2_ ( .D(data_out[1]), .CK(clk), .RN(n3), .Q(
        data_out[2]) );
  DFFRHQX2 data_out_reg_6_ ( .D(data_out[5]), .CK(clk), .RN(n3), .Q(
        data_out[6]) );
  XNOR2XL U3 ( .A(data_out[5]), .B(n1), .Y(n2) );
  XOR2XL U4 ( .A(data_out[4]), .B(data_out[0]), .Y(N5) );
  MX2X1 U5 ( .A(n2), .B(data_in), .S0(load), .Y(N4) );
  INVX2 U6 ( .A(rst), .Y(n3) );
  INVX2 U7 ( .A(data_out[1]), .Y(n1) );
endmodule


module Adder_DW01_add_2 ( A, B, CI, SUM, CO );
  input [16:0] A;
  input [16:0] B;
  output [16:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n21, n22, n23, n24, n25, n26, n27, n28, n29, n31, n32, n33,
         n34, n36, n37, n38, n39, n40, n41, n43, n44, n45, n46, n47, n48, n49,
         n50, n53, n54, n55, n59, n60, n61, n62, n63, n64, n65, n66, n69, n70,
         n71, n72, n74, n77, n78, n79, n80, n82, n83, n85, n86, n87, n88, n89,
         n90, n91, n92, n93, n94, n97, n98, n99, n100, n102, n105, n106, n107,
         n110, n111, n112, n113, n115, n116, n117, n118, n119, n120, n122,
         n124, n126, n128, n130, n131, n132, n133, n134, n137, n140, n141,
         n202, n204, n206, n207, n208, n209, n210, n211, n212, n213, n214,
         n215, n216, n217, n218, n219, n220, n221;

  OAI21X1 U9 ( .A0(n2), .A1(n23), .B0(n24), .Y(n22) );
  OAI21X1 U13 ( .A0(n27), .A1(n37), .B0(n28), .Y(n26) );
  OAI21X1 U45 ( .A0(n2), .A1(n50), .B0(n53), .Y(n49) );
  OAI21X1 U67 ( .A0(n74), .A1(n66), .B0(n69), .Y(n65) );
  OAI21X1 U144 ( .A0(n206), .A1(n119), .B0(n120), .Y(n118) );
  OAI21X2 U164 ( .A0(n105), .A1(n111), .B0(n106), .Y(n100) );
  INVX3 U165 ( .A(n1), .Y(n211) );
  AOI21BX1 U166 ( .A0(n1), .A1(n55), .B0N(n2), .Y(n54) );
  AOI21X4 U167 ( .A0(n59), .A1(n72), .B0(n60), .Y(n2) );
  AOI21X2 U168 ( .A0(n87), .A1(n100), .B0(n88), .Y(n86) );
  OAI21X1 U169 ( .A0(n89), .A1(n97), .B0(n90), .Y(n88) );
  OAI21X1 U170 ( .A0(n61), .A1(n69), .B0(n62), .Y(n60) );
  OAI21X1 U171 ( .A0(n116), .A1(n120), .B0(n117), .Y(n115) );
  NOR2X4 U172 ( .A(n204), .B(n217), .Y(n218) );
  OAI21X1 U173 ( .A0(n77), .A1(n83), .B0(n78), .Y(n72) );
  NOR2X2 U174 ( .A(n94), .B(n89), .Y(n87) );
  INVX2 U175 ( .A(n122), .Y(n217) );
  OAI21X1 U176 ( .A0(n207), .A1(n126), .B0(n124), .Y(n122) );
  NOR2X2 U177 ( .A(B[3]), .B(A[3]), .Y(n116) );
  NOR2X2 U178 ( .A(A[11]), .B(B[11]), .Y(n61) );
  NOR2X2 U179 ( .A(A[6]), .B(B[6]), .Y(n94) );
  NOR2X2 U180 ( .A(B[2]), .B(A[2]), .Y(n119) );
  NOR2X2 U181 ( .A(A[1]), .B(B[1]), .Y(n207) );
  OAI21BX1 U182 ( .A0(n2), .A1(n41), .B0N(n44), .Y(n40) );
  XNOR2X2 U183 ( .A(n29), .B(n219), .Y(SUM[15]) );
  AOI21BX2 U184 ( .A0(n1), .A1(n80), .B0N(n83), .Y(n79) );
  XOR2X1 U185 ( .A(n107), .B(n14), .Y(SUM[5]) );
  NAND2X4 U186 ( .A(B[0]), .B(A[0]), .Y(n126) );
  OR2X2 U187 ( .A(n3), .B(n32), .Y(n202) );
  AO21X2 U188 ( .A0(n210), .A1(n21), .B0(n22), .Y(SUM[16]) );
  OR2X2 U189 ( .A(n116), .B(n119), .Y(n204) );
  OAI21X4 U190 ( .A0(n85), .A1(n113), .B0(n86), .Y(n1) );
  AND2X2 U191 ( .A(n221), .B(n126), .Y(SUM[0]) );
  NOR2X2 U192 ( .A(A[8]), .B(B[8]), .Y(n82) );
  NAND2X2 U193 ( .A(A[8]), .B(B[8]), .Y(n83) );
  NOR2X2 U194 ( .A(A[7]), .B(B[7]), .Y(n89) );
  OA21XL U195 ( .A0(n207), .A1(n126), .B0(n124), .Y(n206) );
  NAND2X2 U196 ( .A(A[1]), .B(B[1]), .Y(n124) );
  NAND2XL U197 ( .A(A[11]), .B(B[11]), .Y(n62) );
  NOR2X2 U198 ( .A(A[10]), .B(B[10]), .Y(n66) );
  OR2X1 U199 ( .A(n2), .B(n32), .Y(n208) );
  NAND2X2 U200 ( .A(n208), .B(n33), .Y(n31) );
  NAND2XL U201 ( .A(n43), .B(n34), .Y(n32) );
  NAND2X1 U202 ( .A(A[12]), .B(B[12]), .Y(n53) );
  AOI21BX2 U203 ( .A0(n112), .A1(n214), .B0N(n111), .Y(n107) );
  CLKINVX2 U204 ( .A(n43), .Y(n41) );
  NOR2X2 U205 ( .A(A[9]), .B(B[9]), .Y(n77) );
  INVXL U206 ( .A(n211), .Y(n210) );
  OR2XL U207 ( .A(A[7]), .B(B[7]), .Y(n209) );
  NOR2X1 U208 ( .A(n211), .B(n212), .Y(n213) );
  NOR2X1 U209 ( .A(n213), .B(n72), .Y(n70) );
  INVXL U210 ( .A(n71), .Y(n212) );
  NOR2X2 U211 ( .A(A[5]), .B(B[5]), .Y(n105) );
  NOR2X1 U212 ( .A(A[14]), .B(B[14]), .Y(n36) );
  NAND2XL U213 ( .A(A[9]), .B(B[9]), .Y(n78) );
  OR2XL U214 ( .A(A[4]), .B(B[4]), .Y(n214) );
  NOR2X4 U215 ( .A(n218), .B(n115), .Y(n113) );
  NOR2X1 U216 ( .A(B[15]), .B(A[15]), .Y(n27) );
  OAI21XL U217 ( .A0(n102), .A1(n94), .B0(n97), .Y(n93) );
  AND2X2 U218 ( .A(n128), .B(n28), .Y(n219) );
  OR2XL U219 ( .A(A[5]), .B(B[5]), .Y(n215) );
  NOR2XL U220 ( .A(n3), .B(n41), .Y(n39) );
  AOI21XL U221 ( .A0(n1), .A1(n64), .B0(n65), .Y(n63) );
  AOI21X1 U222 ( .A0(n1), .A1(n39), .B0(n40), .Y(n38) );
  NOR2XL U223 ( .A(A[4]), .B(B[4]), .Y(n110) );
  NOR2X2 U224 ( .A(n211), .B(n202), .Y(n216) );
  NOR2X2 U225 ( .A(n216), .B(n31), .Y(n29) );
  INVX2 U226 ( .A(n113), .Y(n112) );
  NOR2BXL U227 ( .AN(n71), .B(n66), .Y(n64) );
  NAND2XL U228 ( .A(n130), .B(n46), .Y(n6) );
  NAND2XL U229 ( .A(n133), .B(n69), .Y(n9) );
  AOI21XL U230 ( .A0(n112), .A1(n92), .B0(n93), .Y(n91) );
  AOI21BX2 U231 ( .A0(n44), .A1(n34), .B0N(n37), .Y(n33) );
  NOR2X2 U232 ( .A(n50), .B(n45), .Y(n43) );
  NOR2X2 U233 ( .A(n66), .B(n61), .Y(n59) );
  NOR2X2 U234 ( .A(n82), .B(n77), .Y(n71) );
  NAND2XL U235 ( .A(n132), .B(n62), .Y(n8) );
  XOR2XL U236 ( .A(n206), .B(n17), .Y(SUM[2]) );
  OR2XL U237 ( .A(A[1]), .B(B[1]), .Y(n220) );
  NOR2XL U238 ( .A(n3), .B(n23), .Y(n21) );
  CLKNAND2X2 U239 ( .A(n99), .B(n87), .Y(n85) );
  INVXL U240 ( .A(n72), .Y(n74) );
  NOR2XL U241 ( .A(n3), .B(n50), .Y(n48) );
  AOI21XL U242 ( .A0(n1), .A1(n48), .B0(n49), .Y(n47) );
  OAI21X2 U243 ( .A0(n45), .A1(n53), .B0(n46), .Y(n44) );
  NOR2BXL U244 ( .AN(n99), .B(n94), .Y(n92) );
  AOI21XL U245 ( .A0(n25), .A1(n44), .B0(n26), .Y(n24) );
  INVXL U246 ( .A(n82), .Y(n80) );
  INVXL U247 ( .A(n116), .Y(n140) );
  INVXL U248 ( .A(n66), .Y(n133) );
  INVXL U249 ( .A(n94), .Y(n137) );
  INVXL U250 ( .A(n119), .Y(n141) );
  INVXL U251 ( .A(n61), .Y(n132) );
  INVXL U252 ( .A(n45), .Y(n130) );
  NAND2XL U253 ( .A(A[5]), .B(B[5]), .Y(n106) );
  NAND2XL U254 ( .A(A[6]), .B(B[6]), .Y(n97) );
  NAND2XL U255 ( .A(n80), .B(n83), .Y(n11) );
  NAND2XL U256 ( .A(n215), .B(n106), .Y(n14) );
  NOR2X1 U257 ( .A(A[12]), .B(B[12]), .Y(n50) );
  NAND2XL U258 ( .A(n137), .B(n97), .Y(n13) );
  NAND2XL U259 ( .A(A[13]), .B(B[13]), .Y(n46) );
  NAND2XL U260 ( .A(n209), .B(n90), .Y(n12) );
  XNOR2XL U261 ( .A(n112), .B(n15), .Y(SUM[4]) );
  NAND2XL U262 ( .A(n214), .B(n111), .Y(n15) );
  NAND2XL U263 ( .A(A[14]), .B(B[14]), .Y(n37) );
  NAND2XL U264 ( .A(B[15]), .B(A[15]), .Y(n28) );
  NAND2XL U265 ( .A(n140), .B(n117), .Y(n16) );
  NAND2XL U266 ( .A(n141), .B(n120), .Y(n17) );
  OR2XL U267 ( .A(B[0]), .B(A[0]), .Y(n221) );
  NAND2X2 U268 ( .A(n71), .B(n59), .Y(n3) );
  INVX2 U269 ( .A(n3), .Y(n55) );
  NAND2X2 U270 ( .A(n43), .B(n25), .Y(n23) );
  XOR2X1 U271 ( .A(n38), .B(n5), .Y(SUM[14]) );
  NAND2X2 U272 ( .A(n34), .B(n37), .Y(n5) );
  NOR2X2 U273 ( .A(n110), .B(n105), .Y(n99) );
  INVX2 U274 ( .A(n36), .Y(n34) );
  NOR2X2 U275 ( .A(n36), .B(n27), .Y(n25) );
  INVX2 U276 ( .A(n50), .Y(n131) );
  INVX2 U277 ( .A(n27), .Y(n128) );
  INVX2 U278 ( .A(n77), .Y(n134) );
  XOR2X1 U279 ( .A(n47), .B(n6), .Y(SUM[13]) );
  XOR2X1 U280 ( .A(n98), .B(n13), .Y(SUM[6]) );
  XOR2X1 U281 ( .A(n79), .B(n10), .Y(SUM[9]) );
  NAND2X2 U282 ( .A(n134), .B(n78), .Y(n10) );
  XOR2X1 U283 ( .A(n70), .B(n9), .Y(SUM[10]) );
  XOR2X1 U284 ( .A(n54), .B(n7), .Y(SUM[12]) );
  NAND2X2 U285 ( .A(n131), .B(n53), .Y(n7) );
  XOR2X1 U286 ( .A(n63), .B(n8), .Y(SUM[11]) );
  NOR2X4 U287 ( .A(A[13]), .B(B[13]), .Y(n45) );
  XOR2X1 U288 ( .A(n91), .B(n12), .Y(SUM[7]) );
  XNOR2X1 U289 ( .A(n118), .B(n16), .Y(SUM[3]) );
  XOR2X1 U290 ( .A(n18), .B(n126), .Y(SUM[1]) );
  NAND2X2 U291 ( .A(n220), .B(n124), .Y(n18) );
  NAND2X2 U292 ( .A(B[2]), .B(A[2]), .Y(n120) );
  NAND2X2 U293 ( .A(B[3]), .B(A[3]), .Y(n117) );
  XNOR2XL U294 ( .A(n210), .B(n11), .Y(SUM[8]) );
  NAND2XL U295 ( .A(A[7]), .B(B[7]), .Y(n90) );
  NAND2X2 U296 ( .A(A[4]), .B(B[4]), .Y(n111) );
  INVX2 U297 ( .A(n100), .Y(n102) );
  AOI21XL U298 ( .A0(n112), .A1(n99), .B0(n100), .Y(n98) );
  NAND2X1 U299 ( .A(A[10]), .B(B[10]), .Y(n69) );
endmodule


module Adder ( A, B, sum, CI, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] sum;
  input CI;
  output CO;


  Adder_DW01_add_2 add_28 ( .A({1'b0, A}), .B({1'b0, B}), .CI(1'b0), .SUM({CO, 
        sum}), .CO() );
endmodule


module MISR ( clk, rst, load, data_in, data_out );
  input [16:0] data_in;
  output [16:0] data_out;
  input clk, rst, load;
  wire   N20, N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33,
         N34, N35, N36, n16, n17, n18, n19, n200, n1, n2, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n210, n220, n230, n240, n250,
         n260, n270, n280;

  DFFRQX2 data_out_reg_0_ ( .D(N20), .CK(clk), .RN(n270), .Q(data_out[0]) );
  DFFRQX2 data_out_reg_1_ ( .D(N21), .CK(clk), .RN(n270), .Q(data_out[1]) );
  DFFRQX2 data_out_reg_2_ ( .D(N22), .CK(clk), .RN(n270), .Q(data_out[2]) );
  DFFRQX1 data_out_reg_10_ ( .D(N30), .CK(clk), .RN(n270), .Q(data_out[10]) );
  DFFRQX2 data_out_reg_4_ ( .D(N24), .CK(clk), .RN(n270), .Q(data_out[4]) );
  DFFRQX2 data_out_reg_5_ ( .D(N25), .CK(clk), .RN(n270), .Q(data_out[5]) );
  DFFRQX1 data_out_reg_6_ ( .D(N26), .CK(clk), .RN(n270), .Q(data_out[6]) );
  DFFRQX1 data_out_reg_8_ ( .D(N28), .CK(clk), .RN(n270), .Q(data_out[8]) );
  DFFRQX1 data_out_reg_9_ ( .D(N29), .CK(clk), .RN(n270), .Q(data_out[9]) );
  DFFRQX2 data_out_reg_7_ ( .D(N27), .CK(clk), .RN(n270), .Q(data_out[7]) );
  DFFRQX1 data_out_reg_11_ ( .D(N31), .CK(clk), .RN(n270), .Q(data_out[11]) );
  DFFRQX1 data_out_reg_16_ ( .D(N36), .CK(clk), .RN(n270), .Q(data_out[16]) );
  DFFRQX1 data_out_reg_13_ ( .D(N33), .CK(clk), .RN(n270), .Q(data_out[13]) );
  DFFRQX1 data_out_reg_3_ ( .D(N23), .CK(clk), .RN(n270), .Q(data_out[3]) );
  DFFRHQX2 data_out_reg_14_ ( .D(N34), .CK(clk), .RN(n270), .Q(data_out[14])
         );
  DFFRHQX2 data_out_reg_12_ ( .D(N32), .CK(clk), .RN(n270), .Q(data_out[12])
         );
  DFFRHQX2 data_out_reg_15_ ( .D(N35), .CK(clk), .RN(n270), .Q(data_out[15])
         );
  INVX2 U3 ( .A(data_in[15]), .Y(n6) );
  NAND2X1 U4 ( .A(data_out[4]), .B(data_in[5]), .Y(n3) );
  CLKNAND2X2 U5 ( .A(n1), .B(n2), .Y(n4) );
  NAND2X2 U6 ( .A(n3), .B(n4), .Y(n10) );
  CLKINVX2 U7 ( .A(data_out[4]), .Y(n1) );
  INVX2 U8 ( .A(data_in[5]), .Y(n2) );
  NAND2X1 U9 ( .A(data_out[14]), .B(data_in[15]), .Y(n7) );
  NOR2X1 U10 ( .A(n280), .B(n14), .Y(N29) );
  NOR2X1 U11 ( .A(n280), .B(n220), .Y(N32) );
  NOR2X1 U12 ( .A(n280), .B(n230), .Y(N33) );
  NOR2X1 U13 ( .A(n280), .B(n15), .Y(N30) );
  NOR2X1 U14 ( .A(n280), .B(n210), .Y(N31) );
  CLKNAND2X2 U15 ( .A(n5), .B(n6), .Y(n8) );
  NAND2X2 U16 ( .A(n7), .B(n8), .Y(n240) );
  CLKINVX2 U17 ( .A(data_out[14]), .Y(n5) );
  NOR2X1 U18 ( .A(n280), .B(n240), .Y(N35) );
  NOR2X1 U19 ( .A(n280), .B(n250), .Y(N36) );
  NOR2X1 U20 ( .A(n280), .B(n13), .Y(N28) );
  NOR2X1 U21 ( .A(n280), .B(n10), .Y(N25) );
  NOR2X1 U22 ( .A(n280), .B(n11), .Y(N26) );
  NOR2X1 U23 ( .A(n280), .B(n12), .Y(N27) );
  NOR2X1 U24 ( .A(n260), .B(n280), .Y(N34) );
  INVX2 U25 ( .A(load), .Y(n280) );
  XNOR2X1 U26 ( .A(n9), .B(data_out[16]), .Y(n260) );
  XOR2X1 U27 ( .A(data_in[14]), .B(data_out[13]), .Y(n9) );
  XNOR2X1 U28 ( .A(data_out[12]), .B(data_in[13]), .Y(n230) );
  XNOR2X1 U29 ( .A(data_out[7]), .B(data_in[8]), .Y(n13) );
  XNOR2X1 U30 ( .A(data_out[5]), .B(data_in[6]), .Y(n11) );
  XNOR2X1 U31 ( .A(data_out[8]), .B(data_in[9]), .Y(n14) );
  XNOR2X1 U32 ( .A(data_out[9]), .B(data_in[10]), .Y(n15) );
  XNOR2X1 U33 ( .A(data_out[11]), .B(data_in[12]), .Y(n220) );
  XNOR2X1 U34 ( .A(data_out[10]), .B(data_in[11]), .Y(n210) );
  XNOR2X1 U35 ( .A(data_out[6]), .B(data_in[7]), .Y(n12) );
  NOR2X2 U36 ( .A(n16), .B(n280), .Y(N24) );
  XNOR2X1 U37 ( .A(data_out[3]), .B(data_in[4]), .Y(n16) );
  NOR2X2 U38 ( .A(n200), .B(n280), .Y(N20) );
  XNOR2X1 U39 ( .A(data_in[0]), .B(data_out[16]), .Y(n200) );
  NOR2X2 U40 ( .A(n17), .B(n280), .Y(N23) );
  XNOR2X1 U41 ( .A(data_out[2]), .B(data_in[3]), .Y(n17) );
  NAND2X2 U42 ( .A(n19), .B(load), .Y(N21) );
  XNOR2X1 U43 ( .A(data_out[0]), .B(data_in[1]), .Y(n19) );
  NOR2X2 U44 ( .A(n18), .B(n280), .Y(N22) );
  XNOR2X1 U45 ( .A(data_out[1]), .B(data_in[2]), .Y(n18) );
  INVX2 U46 ( .A(rst), .Y(n270) );
  XNOR2X1 U47 ( .A(data_out[15]), .B(data_in[16]), .Y(n250) );
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

