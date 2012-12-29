`timescale 1ns/1ps

module multiplier_tb;

parameter	TCLK = 10;
reg		clk;

reg		[15: 0]	x, y;
wire	[31: 0] res;
wire   	[31: 0] res_check;

initial	clk = 1'b0;
always #(TCLK/2)	clk = ~clk;

reg[31: 0] res_check1, res_check2, res_check3;
reg[5 : 0] counter;
initial counter = 0;
always @(posedge clk)
begin
    res_check1 <= res_check;
    res_check2 <= res_check1;
    res_check3 <= res_check2;
    if (res != res_check)
        counter <= counter+1;
end

initial
begin
    repeat(200)
    begin
        x = {$random}%17'h10000;
        y = {$random}%17'h10000;
        #TCLK ;
    end
    $stop;
end

TopMultiplier	multiplier_test	(
									.x_in (x),
									.y_in (y),
									.result_out (res)
								);

multiplier_check	multiplier_check0 (
										.a(x),
										.b(y),
										.p(res_check)
									);

endmodule