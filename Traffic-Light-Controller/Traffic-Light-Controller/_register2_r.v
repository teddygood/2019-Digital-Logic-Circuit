module _register2_r(clk,d,q,reset_n); // Asynchronous D flip flop register

input clk,reset_n;	// input clock, reset
input [1:0] d;			// input d0, d1
output [1:0] q;		// output q0, q1
   
_dff_r U0_dff_r(.clk(clk),.reset_n(reset_n),.d(d[0]),.q(q[0])); // instance Asynchronous Resettable D flip flop
_dff_r U1_dff_r(.clk(clk),.reset_n(reset_n),.d(d[1]),.q(q[1])); 
   
endmodule 