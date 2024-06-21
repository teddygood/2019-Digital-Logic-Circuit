module tl_cntr(clk,reset_n,Ta,Tb,La,Lb);	// traffic light controller
input Ta,Tb,clk,reset_n; // input Ta, Tb, clock, reset
output [1:0] La,Lb; // output La0, La1, Lb0, Lb1
	
wire [1:0] w0, w1;
	
ns_logic U0_ns_logic(.d(w0), .q(w1), .Ta(Ta), .Tb(Tb)); // instance ns_logic
_register2_r U1_register2_r(.clk(clk), .d(w0), .q(w1), .reset_n(reset_n));	// instance register 
o_logic U2_o_logic(.q(w1), .La(La), .Lb(Lb)); // instance o_logic

endmodule
