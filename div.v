/****************************************
*            recursive div              *
****************************************/
module div (
	input  clk,
	input  rst_n,
	input  i_in_valid,
	input  [7:0] i_a,
	input  [4:0] i_b,
	output [7:0] o_q,
	output [4:0] o_r,
	output       o_out_valid,
	output [50:0] number
);

wire [50:0] numbers [0:17];

wire out_valid;
wire r1;
wire [1:0] r2;
wire [2:0] r3;
wire [3:0] r4;
wire [4:0] r5;
wire [4:0] r6;
wire [4:0] r7;
wire [4:0] r8;
wire [7:0] q;
wire n1, n2, n3, n4, n5, n6, n7;

STAGE1 stage1(i_a[7], i_b, q[7], r1, numbers[0]);
STAGE2 stage2({r1, i_a[6]}, i_b, q[6], r2, numbers[1]);
STAGE3 stage3({r2, i_a[5]}, i_b, q[5], r3, numbers[2]);
STAGE4 stage4({r3, i_a[4]}, i_b, q[4], r4, numbers[3]);
STAGE5 stage5({r4, i_a[3]}, i_b, q[3], r5, numbers[4]);
STAGE678 stage6({r5, i_a[2]}, i_b, q[2], r6, numbers[5]);
STAGE678 stage7({r6, i_a[1]}, i_b, q[1], r7, numbers[6]);
STAGE678 stage8({r7, i_a[0]}, i_b, q[0], r8, numbers[7]);

IV iv1(n1, q[0], numbers[8]);
IV iv2(n2, r8[4], numbers[9]);
IV iv3(n3, r8[3], numbers[10]);
IV iv4(n4, r8[2], numbers[11]);
NR2 nr1(n5, n1, q[0], numbers[12]);
NR2 nr2(n6, n2, r8[4], numbers[13]);
NR2 nr3(n7, n3, r8[3], numbers[14]);
NR2 nr4(n8, n4, r8[2], numbers[15]);
NR4 nr5(out_valid, n5, n6, n7, n8, numbers[16]);

REGP#(14) result(clk, rst_n, {o_q, o_r, o_out_valid}, {q, r8, out_valid}, numbers[17]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<18; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*            pipelined div              *
****************************************/
// module div (
// 	input  clk,
// 	input  rst_n,
// 	input  i_in_valid,
// 	input  [7:0] i_a,
// 	input  [4:0] i_b,
// 	output [7:0] o_q,
// 	output [4:0] o_r,
// 	output       o_out_valid,
// 	output [50:0] number
// );

// wire [50:0] numbers [0:14];

// wire [7:0] q;
// wire [1:0] q7_6;
// wire [2:0] q7_5;
// wire [3:0] q7_4;
// wire [4:0] q7_3;
// wire [5:0] q7_2;
// wire [6:0] q7_1;
// wire r1;
// wire [1:0] r2_2, r2_3;
// wire [2:0] r3_3, r3_4;
// wire [3:0] r4_4, r4_5;
// wire [4:0] r5_5, r5_6, r6_6, r6_7, r7_7, r7_8, r8_8;
// wire [5:0] a3;
// wire [4:0] a4;
// wire [3:0] a5;
// wire [2:0] a6;
// wire [1:0] a7;
// wire a8;
// wire [4:0] b [3:8];
// wire out_valid [3:8];

// STAGE1 stage1(i_a[7], i_b, q[7], r1, numbers[0]);
// STAGE2 stage2({r1, i_a[6]}, i_b, q[6], r2_2, numbers[1]);
// REGP#(16) reg2_3(clk, rst_n, {out_valid[3], a3, b[3], q7_6, r2_3}, {i_in_valid, i_a[5:0], i_b, q[7], q[6], r2_2}, numbers[2]);

// STAGE3 stage3({r2_3, a3[5]}, b[3], q[5], r3_3, numbers[3]);
// REGP#(17) reg3_4(clk, rst_n, {out_valid[4], a4, b[4], q7_5, r3_4}, {out_valid[3], a3[4:0], b[3], q7_6, q[5], r3_3}, numbers[4]);

// STAGE4 stage4({r3_4, a4[4]}, b[4], q[4], r4_4, numbers[5]);
// REGP#(18) reg4_5(clk, rst_n, {out_valid[5], a5, b[5], q7_4, r4_5}, {out_valid[4], a4[3:0], b[4], q7_5, q[4], r4_4}, numbers[6]);

// STAGE5 stage5({r4_5, a5[3]}, b[5], q[3], r5_5, numbers[7]);
// REGP#(19) reg5_6(clk, rst_n, {out_valid[6], a6, b[6], q7_3, r5_6}, {out_valid[5], a5[2:0], b[5], q7_4, q[3], r5_5}, numbers[8]);

// STAGE678 stage6({r5_6, a6[2]}, b[6], q[2], r6_6, numbers[9]);
// REGP#(19) reg6_7(clk, rst_n, {out_valid[7], a7, b[7], q7_2, r6_7}, {out_valid[6], a6[1:0], b[6], q7_3, q[2], r6_6}, numbers[10]);

// STAGE678 stage7({r6_7, a7[1]}, b[7], q[1], r7_7, numbers[11]);
// REGP#(19) reg7_8(clk, rst_n, {out_valid[8], a8, b[8], q7_1, r7_8}, {out_valid[7], a7[0], b[7], q7_2, q[1], r7_7}, numbers[12]);

// STAGE678 stage8({r7_8, a8}, b[8], q[0], r8_8, numbers[13]);
// REGP#(14) reg8_o(clk, rst_n, {o_out_valid, o_q, o_r}, {out_valid[8], q7_1, q[0], r8_8}, numbers[14]);

// reg [50:0] sum;
// integer j;
// always @(*) begin
// 	sum = 0;
// 	for (j=0; j<15; j=j+1) begin 
// 		sum = sum + numbers[j];
// 	end
// end

// assign number = sum;

// endmodule

/****************************************
*                Stage 1                *
****************************************/
module STAGE1 (
	input i_a,
	input [4:0] i_b,
	output o_q,
	output o_r,
	output [50:0] number
);

wire [50:0] numbers [0:4];

wire inv_o_nor, o_nor, diff, borrow;

HS1 hs1(i_a, i_b[0], diff, borrow, numbers[0]);
NR4 nr1(o_nor, i_b[4], i_b[3], i_b[2], i_b[1], numbers[1]);
IV iv1(inv_o_nor, o_nor, numbers[2]);
NR2 nr2(o_q, inv_o_nor, borrow, numbers[3]);
MUX21H mux1(o_r, i_a, diff, o_q, numbers[4]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<5; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*                Stage 2                *
****************************************/
module STAGE2 (
	input [1:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [1:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [1:0] diff;

FSP#(2) fs1(i_a, i_b[1:0], diff, borrow, numbers[0]);
NR4 nr1(o_q, borrow, i_b[4], i_b[3], i_b[2], numbers[1]);
MUXP#(2) mux1(o_r, i_a, diff, o_q, numbers[2]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<3; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*                Stage 3                *
****************************************/
module STAGE3 (
	input [2:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [2:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [2:0] diff;

FSP#(3) fs1(i_a, i_b[2:0], diff, borrow, numbers[0]);
NR3 nr1(o_q, borrow, i_b[4], i_b[3], numbers[1]);
MUXP#(3) mux1(o_r, i_a, diff, o_q, numbers[2]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<3; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*                Stage 4                *
****************************************/
module STAGE4 (
	input [3:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [3:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [3:0] diff;

FSP#(4) fs1(i_a, i_b[3:0], diff, borrow, numbers[0]);
NR2 nr1(o_q, borrow, i_b[4], numbers[1]);
MUXP#(4) mux1(o_r, i_a, diff, o_q, numbers[2]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<3; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*                Stage 5                *
****************************************/
module STAGE5 (
	input [4:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [4:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:2];

wire borrow;
wire [4:0] diff;

FSP#(5) fs1(i_a, i_b, diff, borrow, numbers[0]);
MUXP#(5) mux1(o_r, diff, i_a, borrow, numbers[1]);
IV iv1(o_q, borrow, numbers[2]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<3; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*               Stage 6-8               *
****************************************/
module STAGE678 (
	input [5:0] i_a,
	input [4:0] i_b,
	output o_q,
	output [4:0] o_r,
	output [50:0] number
);

wire [50:0] numbers [0:3];

wire borrow, inv_i_a_5;
wire [4:0] diff;

FSP#(5) fs1(i_a[4:0], i_b, diff, borrow, numbers[0]);
IV iv1(inv_i_a_5, i_a[5], numbers[1]);
ND2 nd1(o_q, inv_i_a_5, borrow, numbers[2]);
MUXP#(5) mux1(o_r, i_a[4:0], diff, o_q, numbers[3]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<4; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*              BW-bit FD2               *
****************************************/
module REGP#(
	parameter BW = 2
)(
	input clk,
	input rst_n,
	output [BW-1:0] Q,
	input [BW-1:0] D,
	output [50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

// sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*                  HS1                  *
****************************************/
module HS1(
	input i_a,
	input i_b,
	output o_diff,
	output o_borrow,
	output [50:0] number
);

wire inv_b;
wire [50:0] numbers [0:2];

IV iv1(inv_b, i_b, numbers[0]);
NR2 nr1(o_borrow, inv_b, i_a, numbers[1]);
EO eo1(o_diff, i_a, i_b, numbers[2]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<3; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*             recursive FS1             *
****************************************/
module FS1(
	input i_a,
	input i_b,
	input i_borrow,
	output o_diff,
	output o_borrow,
	output [50:0] number
);

wire [50:0] numbers [0:5];
wire [3:0] tmp;

ND2 nd1(tmp[0], i_b, i_borrow, numbers[0]);
EO eo1(tmp[1], i_b, i_borrow, numbers[1]);
EO eo2(o_diff, tmp[1], i_a, numbers[2]);
IV iv1(tmp[2], i_a, numbers[3]);
ND2 nd2(tmp[3], tmp[1], tmp[2], numbers[4]);
ND2 nd3(o_borrow, tmp[0], tmp[3], numbers[5]);

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<6; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*             pipelined FS1             *
****************************************/
// module FS1(
// 	input i_a,
// 	input i_b,
// 	input i_borrow,
// 	output o_diff,
// 	output o_borrow,
// 	output [50:0] number
// );

// wire inv_a;
// wire [2:0] prod;
// wire [50:0] numbers [0:5];

// IV iv1(inv_a, i_a, numbers[0]);
// ND2 nd1(prod[0], inv_a, i_b, numbers[1]);
// ND2 nd2(prod[1], i_b, i_borrow, numbers[2]);
// ND2 nd3(prod[2], inv_a, i_borrow, numbers[3]);
// ND3 nd4(o_borrow, prod[0], prod[1], prod[2], numbers[4]);
// EO3 eo1(o_diff, i_a, i_b, i_borrow, numbers[5]);

// reg [50:0] sum;
// integer j;
// always @(*) begin
// 	sum = 0;
// 	for (j=0; j<6; j=j+1) begin 
// 		sum = sum + numbers[j];
// 	end
// end

// assign number = sum;

// endmodule

/****************************************
*              BW-bit FS1               *
****************************************/
module FSP#(
	parameter BW = 2
)(
	input [BW-1:0] i_a,
	input [BW-1:0] i_b,
	output [BW-1:0] o_diff,
	output o_borrow,
	output [50:0] number
);

wire [BW-1:0] intmdt_borrow;
wire [50:0] numbers [0:BW-1];

HS1 hs1(i_a[0], i_b[0], o_diff[0], intmdt_borrow[0], numbers[0]);

genvar i;
generate
	for (i=1; i<BW; i=i+1) begin
		FS1 fs(i_a[i], i_b[i], intmdt_borrow[i-1], o_diff[i], intmdt_borrow[i], numbers[i]);
	end
endgenerate

assign o_borrow = intmdt_borrow[BW-1];

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

/****************************************
*             BW-bit MUX21H             *
****************************************/
module MUXP#(
	parameter BW = 2
)(
	output [BW-1:0] o_z,
	input [BW-1:0] i_a,
	input [BW-1:0] i_b,
	input i_ctrl,
	output [50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		MUX21H mux(o_z[i], i_a[i], i_b[i], i_ctrl, numbers[i]);
	end
endgenerate

reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule