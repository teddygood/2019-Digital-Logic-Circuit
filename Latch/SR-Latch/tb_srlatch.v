`timescale 1ns/100ps

module tb_srlatch;	// testbench sr latch
reg tb_r, tb_s; // input tb_r, tb_s
wire tb_q, tb_q_bar; // output tb_q, tb_q_bar
	
_srlatch U0_srlatch(.r(tb_r), .s(tb_s), .q(tb_q), .q_bar(tb_q_bar));
// instance SR latch
	
initial
begin
		tb_r=1'b0; tb_s=1'b0;	// start value
#10	tb_r=1'b1;					// change value
#10	tb_r=1'b0; tb_s=1'b1;
#10	tb_r=1'b1;
#10				  tb_s=1'b0;
#10	tb_r=1'b0;
#10	$stop;

end
endmodule
