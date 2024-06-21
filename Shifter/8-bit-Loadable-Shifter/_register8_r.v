module _register8_r(clk,reset_n,d,q);	// Asynchronous Resettable D flip flop 8-bit register
input clk, reset_n;		// clock, reset
input [7:0] d;
output [7:0] q;

// 8-bit register
_dff_r U0_dff_r(.clk(clk), .reset_n(reset_n), .d(d[0]), .q(q[0])); // instance 1-bit D flip-flop 
_dff_r U1_dff_r(.clk(clk), .reset_n(reset_n), .d(d[1]), .q(q[1]));  
_dff_r U2_dff_r(.clk(clk), .reset_n(reset_n), .d(d[2]), .q(q[2]));  
_dff_r U3_dff_r(.clk(clk), .reset_n(reset_n), .d(d[3]), .q(q[3]));  
_dff_r U4_dff_r(.clk(clk), .reset_n(reset_n), .d(d[4]), .q(q[4])); 
_dff_r U5_dff_r(.clk(clk), .reset_n(reset_n), .d(d[5]), .q(q[5]));
_dff_r U6_dff_r(.clk(clk), .reset_n(reset_n), .d(d[6]), .q(q[6])); 
_dff_r U7_dff_r(.clk(clk), .reset_n(reset_n), .d(d[7]), .q(q[7])); 
	
endmodule
