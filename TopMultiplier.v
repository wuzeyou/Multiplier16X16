///////////////////////////////////////////////////////////////////////////////
//
//	Module Name:	TopMultiplier
//
//	Date:			2012/12/18
//
//	Author:			Joe Wu
//
//	Description:	The Top module of this 16X16 Multipiler.
//
///////////////////////////////////////////////////////////////////////////////

module	TopMultiplier ( x_in, y_in, result_out );

input	[15: 0]	x_in, y_in;
output	[31: 0]	result_out;

// internal connections
wire	[15:0]	pp0, pp1, pp2, pp3, pp4, pp5, 
				pp6, pp7, pp8, pp9, pp10, pp11, 
				pp12, pp13, pp14, pp15; 
wire	[31: 0]	opa, opb;
wire	[15: 0]	sign;
//wire	[15: 0]	sign_compensate;
wire	[31: 0]	sign_compensate;
wire	[31: 0]	res_tmp;

// generate PP
Booth_Classic	booth (	.M( x_in ),
						.R( y_in ),
						.pp0( pp0 ),
						.pp1( pp1 ),
						.pp2( pp2 ),
						.pp3( pp3 ),
						.pp4( pp4 ),
						.pp5( pp5 ),
						.pp6( pp6 ),
						.pp7( pp7 ),
						.pp8( pp8 ),
						.pp9( pp9 ),
						.pp10( pp10 ),
						.pp11( pp11 ),
						.pp12( pp12 ),
						.pp13( pp13 ),
						.pp14( pp14 ),
						.pp15( pp15 ),
						.S( sign )
						);

// wallace tree
WallaceTree16X16 wallace (	
							.pp0( pp0 ),
							.pp1( pp1 ),
							.pp2( pp2 ),
							.pp3( pp3 ),
							.pp4( pp4 ),
							.pp5( pp5 ),
							.pp6( pp6 ),
							.pp7( pp7 ),
							.pp8( pp8 ),
							.pp9( pp9 ),
							.pp10( pp10 ),
							.pp11( pp11 ),
							.pp12( pp12 ),
							.pp13( pp13 ),
							.pp14( pp14 ),
							.pp15( pp15 ),
							.opa( opa),
							.opb( opb)
						);

// calculate the sign bit compensate
CS_Adder32	signcomp (
						.a( {~sign, 16'b0} ),
						.b( {15'b0, 1'b1, 16'b0} ),
						.cin( 1'b0 ),
						.sum( sign_compensate ),
						.cout()
					);

// temporary result
CS_Adder32	resulttemp (
							.a( opa ),
							.b( opb ),
							.cin( 1'b0 ),
							.sum( res_tmp ),
							.cout()
						);

// final result
CS_Adder32	result (
						.a( res_tmp ),
						.b( sign_compensate ),
						.cin( 1'b0 ),
						.sum( result_out),
						.cout()
					);

endmodule









