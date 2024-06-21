module _dff_r(clk, reset_n, d, q); // Resettable D flip flop
input clk, reset_n, d; // input clk(clock), reset_n(reset signal), d
output q; // output q
	
wire w_d;
	
_and2 U0_and2(.a(d), .b(reset_n), .y(w_d)); // instance 2-input AND gate 
_dff U1_dff(.clk(clk), .d(w_d), .q(q)); // instance D flip flop
	
endmodule
	