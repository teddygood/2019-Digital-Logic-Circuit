module shifter8(clk,reset_n,op,shamt,d_in,d_out);	// 8-bit shifter
input clk, reset_n;	// clock, reset
input [2:0] op;	// operation code
input [1:0] shamt;	// shift amount
input [7:0] d_in;
output [7:0] d_out;

wire [7:0] d_next; // connect 8-bit register to cc_logic
	
_register8_r U0_register8_r(.clk(clk), .reset_n(reset_n), .d(d_next), .q(d_out)); // instance 8-bit register
	
cc_logic U1_cc_logic(.op(op), .shamt(shamt), .d_in(d_in), .d_out(d_out), .d_next(d_next)); // instance Combinational Circuit Logic

endmodule
