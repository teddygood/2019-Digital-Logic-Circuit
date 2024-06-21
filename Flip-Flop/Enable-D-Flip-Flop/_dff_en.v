module _dff_en(clk, en, d, q); // Enabled D-flip flop
input	clk, en, d; // input clk(clock), en(enable), d
output q;	// output q
wire w_d;
	
mx2 U0_mx2(.d0(q), .d1(d), .s(en), .y(w_d)); // instance 2-to-1 MUX
_dff U1_dff(.clk(clk), .d(w_d), .q(q)); // instance D flip flop
	
endmodule
