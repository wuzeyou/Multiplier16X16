///////////////////////////////////////////////////////////////////////////////
//
//	Module Name:	Classic_Booth PP Generator
//
//	Date:			2012/12/15
//
//	Author:			Joe Wu
//
//	Description:	The partial products (PP) generator based on the Classic Booth
//					algorithm. This module can generate N PPs, each one with (N+1)
//					bits width. In this instance, N = 16. Both inputs are signed
//					2's complement.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module 	Booth_Classic (	
	input	[15 : 0]	M,						// Multiplicand
	input	[15 : 0]	R,						// Multiplier

	output	[15 : 0]	pp0, pp1, pp2, pp3,		// PP results
						pp4, pp5, pp6, pp7, 
						pp8, pp9, pp10, pp11, 
						pp12, pp13, pp14, pp15,

	output  [15 : 0]	S						// Sign extend bit of each PP
);

wire [16 : 0]	tmp;
assign tmp = {R, 1'b0};

assign pp0 = (tmp[1:0] == 2'b01 ) ? M :
				(tmp[1:0] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[0] = pp0[15];

assign pp1 = (tmp[2:1] == 2'b01 ) ? M :
				(tmp[2:1] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[1] = pp1[15];

assign pp2 = (tmp[3:2] == 2'b01 ) ? M :
				(tmp[3:2] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[2] = pp2[15];

assign pp3 = (tmp[4:3] == 2'b01 ) ? M :
				(tmp[4:3] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[3] = pp3[15];

assign pp4 = (tmp[5:4] == 2'b01 ) ? M :
				(tmp[5:4] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[4] = pp4[15];

assign pp5 = (tmp[6:5] == 2'b01 ) ? M :
				(tmp[6:5] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[5] = pp5[15];

assign pp6 = (tmp[7:6] == 2'b01 ) ? M :
				(tmp[7:6] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[6] = pp6[15];

assign pp7 = (tmp[8:7] == 2'b01 ) ? M :
				(tmp[8:7] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[7] = pp7[15];

assign pp8 = (tmp[9:8] == 2'b01 ) ? M :
				(tmp[9:8] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[8] = pp8[15];

assign pp9 = (tmp[10:9] == 2'b01 ) ? M :
				(tmp[10:9] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[9] = pp9[15];

assign pp10 = (tmp[11:10] == 2'b01 ) ? M :
				(tmp[11:10] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[10] = pp10[15];

assign pp11 = (tmp[12:11] == 2'b01 ) ? M :
				(tmp[12:11] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[11] = pp11[15];

assign pp12 = (tmp[13:12] == 2'b01 ) ? M :
				(tmp[13:12] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[12] = pp12[15];

assign pp13 = (tmp[14:13] == 2'b01 ) ? M :
				(tmp[14:13] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[13] = pp13[15];

assign pp14 = (tmp[15:14] == 2'b01 ) ? M :
				(tmp[15:14] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[14] = pp14[15];

assign pp15 = (tmp[16:15] == 2'b01 ) ? M :
				(tmp[16:15] == 2'b10) ? ( ~M + 1'b1 ) : 16'b0;
assign S[15] = pp15[15];

endmodule
	

