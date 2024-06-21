`timescale 1ns/100ps

module tb_dff_r;
reg 	tb_reset_n, tb_d, tb_clk; // input reset, d, clock
wire 	tb_q; // output q
	
_dff_r U0_dff_r(.clk(tb_clk), .reset_n(tb_reset_n), .d(tb_d), .q(tb_q)); // instance Resettable D flip flop 
	
always
begin
	tb_clk=0; #5; tb_clk=1; #5; // clock period 10
end
	
initial
begin
		tb_d=1'b0;	tb_reset_n=1'b0;	// first value
#3		tb_d=1'b1;							// change value
#10	tb_d=1'b0; 	tb_reset_n=1'b1;
#10	tb_d=1'b1;
#10	tb_d=1'b0;
#10	tb_d=1'b1;
#10	tb_d=1'b0;
#10	tb_d=1'b1;
#10	tb_d=1'b0;
#10	tb_d=1'b1;
#10	$stop;
end
endmodule
