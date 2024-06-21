`timescale 1ns/100ps

module tb_register32;
reg			tb_clk;	
reg [31:0] 	tb_d;
wire [31:0] tb_q;
	
_register32 I0_register32(.clk(tb_clk), .d(tb_d), .q(tb_q));
	
always
begin
	tb_clk=0; #5; tb_clk=1; #5; // clock period 10ns
end
	
initial
begin
		tb_d=32'h2019_0923;
#3		tb_d=32'h1234_5678;
#10	tb_d=32'h8765_4321;
#10	tb_d=32'h0;
#10	tb_d=32'hffff_0000;
#10	tb_d=32'h0000_ffff;
#10	tb_d=32'hffff_ffff;
#20	$stop;
end
endmodule
	