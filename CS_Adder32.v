///////////////////////////////////////////////////////////////////////////////
//
//	Module Name:	32-bit Square Root Carry Select Adder
//
//	Date:			2012/12/15
//
//	Author:			Joe Wu
//
//	Description:	N-bit Carry Select adder, with P stages. The first stage
//					has M-bits, then one bit is added at each stage. In this
//					instance, N = 32, M = 3, P = 6.
//
///////////////////////////////////////////////////////////////////////////////

module 	CS_Adder32 (a, b, cin, sum, cout);

input 	[31 : 0]	a, b; 						// 32-bit inputs
input 				cin;						// carry input
output	[31 : 0]	sum;
output				cout;

//	internal connections between each stage's carry look ahead adders
wire	[2 : 0]		p1, g1, c1_s0, c1_s1, c1;
wire 	[3 : 0]		p2, g2, c2_s0, c2_s1, c2;
wire 	[4 : 0]		p3, g3, c3_s0, c3_s1, c3;
wire 	[5 : 0]		p4, g4, c4_s0, c4_s1, c4;
wire 	[6 : 0]		p5, g5, c5_s0, c5_s1, c5;
wire 	[6 : 0]		p6, g6, c6_s0, c6_s1, c6;

//========== STAGE: 1 	M = 3 =================================================
assign	g1 = a[2:0] & b[2:0];
assign	p1 = a[2:0]	| b[2:0];
assign	c1_s0[0] = g1[0];
assign 	c1_s0[1] = g1[1] | (p1[1] & c1_s0[0]);
assign 	c1_s0[2] = g1[2] | (p1[2] & c1_s0[1]);
assign	c1_s1[0] = g1[0] | p1[0];
assign	c1_s1[1] = g1[1] | (p1[1] & c1_s1[0]);
assign	c1_s1[2] = g1[2] | (p1[2] & c1_s1[1]);
assign	c1 = cin ? c1_s1 : c1_s0;
assign	sum[2 : 0] = a[2:0] ^ b[2:0] ^ {c1[1:0], cin};
//========== STAGE: 2 	M = 4 =================================================
assign	g2 = a[6 : 3] & b[6 : 3];
assign	p2 = a[6 : 3] | b[6 : 3];
assign	c2_s0[0] = g2[0];
assign 	c2_s0[1] = g2[1] | (p2[1] & c2_s0[0]);
assign 	c2_s0[2] = g2[2] | (p2[2] & c2_s0[1]);
assign	c2_s0[3] = g2[3] | (p2[3] & c2_s0[2]);
assign	c2_s1[0] = g2[0] | p2[0];
assign	c2_s1[1] = g2[1] | (p2[1] & c2_s1[0]);
assign	c2_s1[2] = g2[2] | (p2[2] & c2_s1[1]);
assign	c2_s1[3] = g2[3] | (p2[3] & c2_s1[2]);
assign	c2 = c1[2] ? c2_s1 : c2_s0;
assign	sum[6 : 3] = a[6 : 3] ^ b[6 : 3] ^ {c2[2:0], c1[2]};
//========== STAGE: 3 	M = 5 =================================================
assign	g3 = a[11 : 7] & b[11 : 7];
assign	p3 = a[11 : 7] | b[11 : 7];
assign	c3_s0[0] = g3[0];
assign 	c3_s0[1] = g3[1] | (p3[1] & c3_s0[0]);
assign 	c3_s0[2] = g3[2] | (p3[2] & c3_s0[1]);
assign	c3_s0[3] = g3[3] | (p3[3] & c3_s0[2]);
assign	c3_s0[4] = g3[4] | (p3[4] & c3_s0[3]);
assign	c3_s1[0] = g3[0] | p3[0];
assign	c3_s1[1] = g3[1] | (p3[1] & c3_s1[0]);
assign	c3_s1[2] = g3[2] | (p3[2] & c3_s1[1]);
assign	c3_s1[3] = g3[3] | (p3[3] & c3_s1[2]);
assign	c3_s1[4] = g3[4] | (p3[4] & c3_s1[3]);
assign	c3 = c2[3] ? c3_s1 : c3_s0;
assign	sum[11 : 7] = a[11 : 7] ^ b[11 : 7] ^ {c3[3:0], c2[3]};
//========== STAGE: 4 	M = 6 =================================================
assign	g4 = a[17 : 12] & b[17 : 12];
assign	p4 = a[17 : 12] | b[17 : 12];
assign	c4_s0[0] = g4[0];
assign 	c4_s0[1] = g4[1] | (p4[1] & c4_s0[0]);
assign 	c4_s0[2] = g4[2] | (p4[2] & c4_s0[1]);
assign	c4_s0[3] = g4[3] | (p4[3] & c4_s0[2]);
assign	c4_s0[4] = g4[4] | (p4[4] & c4_s0[3]);
assign	c4_s0[5] = g4[5] | (p4[5] & c4_s0[4]);
assign	c4_s1[0] = g4[0] | p4[0];
assign	c4_s1[1] = g4[1] | (p4[1] & c4_s1[0]);
assign	c4_s1[2] = g4[2] | (p4[2] & c4_s1[1]);
assign	c4_s1[3] = g4[3] | (p4[3] & c4_s1[2]);
assign	c4_s1[4] = g4[4] | (p4[4] & c4_s1[3]);
assign	c4_s1[5] = g4[5] | (p4[5] & c4_s1[4]);
assign	c4 = c3[4] ? c4_s1 : c4_s0;
assign	sum[17 : 12] = a[17 : 12] ^ b[17 : 12] ^ {c4[4:0], c3[4]};
//========== STAGE: 5 	M = 7 =================================================
assign	g5 = a[24 : 18] & b[24 : 18];
assign	p5 = a[24 : 18] | b[24 : 18];
assign	c5_s0[0] = g5[0];
assign 	c5_s0[1] = g5[1] | (p5[1] & c5_s0[0]);
assign 	c5_s0[2] = g5[2] | (p5[2] & c5_s0[1]);
assign	c5_s0[3] = g5[3] | (p5[3] & c5_s0[2]);
assign	c5_s0[4] = g5[4] | (p5[4] & c5_s0[3]);
assign	c5_s0[5] = g5[5] | (p5[5] & c5_s0[4]);
assign	c5_s0[6] = g5[6] | (p5[6] & c5_s0[5]);
assign	c5_s1[0] = g5[0] | p5[0];
assign	c5_s1[1] = g5[1] | (p5[1] & c5_s1[0]);
assign	c5_s1[2] = g5[2] | (p5[2] & c5_s1[1]);
assign	c5_s1[3] = g5[3] | (p5[3] & c5_s1[2]);
assign	c5_s1[4] = g5[4] | (p5[4] & c5_s1[3]);
assign	c5_s1[5] = g5[5] | (p5[5] & c5_s1[4]);
assign	c5_s1[6] = g5[6] | (p5[6] & c5_s1[5]);
assign	c5 = c4[5] ? c5_s1 : c5_s0;
assign	sum[24 : 18] = a[24 : 18] ^ b[24 : 18] ^ {c5[5:0], c4[5]};
//========== STAGE: 6 	M = 7 =================================================
assign	g6 = a[31 : 25] & b[31 : 25];
assign	p6 = a[31 : 25] | b[31 : 25];
assign	c6_s0[0] = g6[0];
assign 	c6_s0[1] = g6[1] | (p6[1] & c6_s0[0]);
assign 	c6_s0[2] = g6[2] | (p6[2] & c6_s0[1]);
assign	c6_s0[3] = g6[3] | (p6[3] & c6_s0[2]);
assign	c6_s0[4] = g6[4] | (p6[4] & c6_s0[3]);
assign	c6_s0[5] = g6[5] | (p6[5] & c6_s0[4]);
assign	c6_s0[6] = g6[6] | (p6[6] & c6_s0[5]);
assign	c6_s1[0] = g6[0] | p6[0];
assign	c6_s1[1] = g6[1] | (p6[1] & c6_s1[0]);
assign	c6_s1[2] = g6[2] | (p6[2] & c6_s1[1]);
assign	c6_s1[3] = g6[3] | (p6[3] & c6_s1[2]);
assign	c6_s1[4] = g6[4] | (p6[4] & c6_s1[3]);
assign	c6_s1[5] = g6[5] | (p6[5] & c6_s1[4]);
assign	c6_s1[6] = g6[6] | (p6[6] & c6_s1[5]);
assign	c6 = c5[6] ? c6_s1 : c6_s0;
assign	sum[31 : 25] = a[31 : 25] ^ b[31 : 25] ^ {c6[5:0], c5[6]};

assign	cout = c6[6];

endmodule
