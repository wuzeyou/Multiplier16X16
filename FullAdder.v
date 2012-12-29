///////////////////////////////////////////////////////////////////////////////
//
//	Module Name:	Full-Adder
//
//	Date:	2012/12/15
//
//	Author:	Joe Wu
//
//	Description:	3-input & 2-output Adder
//
///////////////////////////////////////////////////////////////////////////////

module 	FullAdder(a, b, cin, sum, cout);

input 	a, b, cin;
output 	sum, cout;

assign	sum = a ^ b ^ cin;
assign 	cout = (a & b) | (a & cin) | (b & cin);

endmodule
