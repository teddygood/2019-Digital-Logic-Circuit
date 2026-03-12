`timescale 1ns/100ps	// Setting the Time Unit of Simulation

module tb_cla_clk;	// cla with clock testbench
reg clock;
reg [31:0] tb_a, tb_b;
reg tb_ci;
wire [31:0] tb_s_cla;
wire tb_co_cla;

parameter STEP = 10;		// Specify a constant of 10
cla_clk U0_cla_clk(.clock(clock), .a(tb_a), .b(tb_b), .ci(tb_ci), .s_cla(tb_s_cla), .co_cla(tb_co_cla));	// cla with clock module

always # (STEP/2) clock = ~clock;	// It continues to give as much delay as 5ns

initial
begin
clock = 1'b1;   tb_a = 32'h0;   			tb_b = 32'h0;   			tb_ci = 1'b0;	// start value
#(STEP);      	 tb_a = 32'hFFFF_FFFF;  tb_b = 32'h0;   			tb_ci = 1'b1;	// change value
#(STEP);        tb_a = 32'h0000_FFFF;  tb_b = 32'hFFFF_0000;   tb_ci = 1'b0;
#(STEP);        tb_a = 32'h135f_a562;  tb_b = 32'h3561_4642;   tb_ci = 1'b0;
#(STEP*2);      $stop;

end
endmodule
