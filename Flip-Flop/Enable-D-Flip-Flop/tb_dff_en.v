`timescale 1ns/100ps

module tb_dff_en;
reg tb_clk, tb_en, tb_d; // input tb_clk(test bench clock), tb_en(test bench enable), tb_d
wire tb_q; // output tb_q
	
_dff_en U0_dff_en(.clk(tb_clk), .en(tb_en), .d(tb_d), .q(tb_q)); // instance Enabled D filp flop
	
always
begin
	tb_clk=0; #5; tb_clk=1; #5; // clock period 10
end
	
initial
begin
		tb_en=1'b1; tb_d=1'b0;	// first value
#3						tb_d=1'b1;	// change value
#10					tb_d=1'b0;
#10					tb_d=1'b1;
#10					tb_d=1'b0;
#10					tb_d=1'b1;
#10	tb_en=1'b0;	tb_d=1'b0;
#10					tb_d=1'b1;
#10					tb_d=1'b0;
#10					tb_d=1'b1;
#10					tb_d=1'b0;
#10	$stop;

end
endmodule
