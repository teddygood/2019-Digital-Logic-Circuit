`timescale 1ns/100ps

module tb_multiplier;	// testbench multiplier
reg clk,reset_n,op_start, op_clear;
reg [63:0]	multiplier,multiplicand; // input 64-bit multiplier, multiplicand
wire	op_done;	// operation done 	
wire [127:0] result;	// output 128-bit result
	
// Instance Radix-4 multiplier 
multiplier U0_multiplier(.clk(clk), .reset_n(reset_n), .op_start(op_start), .op_clear(op_clear), .multiplicand(multiplicand), .multiplier(multiplier), .op_done(op_done), .result(result));
	 	
always
begin
	clk=1; #5; clk = ~clk; #5; // clock period 10ns
end
	 
initial
begin
			reset_n=1'b0; op_start=1'b0; op_clear=1'b0;
			multiplier=-20; multiplicand=5; // -100
	#5		reset_n=1'b1;
	#7		op_start=1'b1;
	#360	reset_n=1'b0;
	#10	reset_n=1'b1;
	#10	multiplier=5; multiplicand=4; // 20
	#100	op_clear=1'b1; 
	#10	op_clear=1'b0;
	#360	op_clear=1'b1;
	#20	$stop;
end
endmodule
