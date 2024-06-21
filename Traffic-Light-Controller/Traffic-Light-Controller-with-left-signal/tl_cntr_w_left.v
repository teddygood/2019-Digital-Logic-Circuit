module tl_cntr_w_left(clk,reset_n,Ta,Tb,Tal,Tbl,La,Lb);	// traffic light controller with left turn
input Ta,Tb,Tal,Tbl,clk,reset_n;	// input Ta, Tb, Tal(Ta left), Tbl(left), clock, reset
output [1:0] La,Lb; // output La, Lb	
	
wire [2:0] w0, w1;
	
ns_logic U0_ns_logic (.d(w0), .q(w1), .Ta(Ta), .Tal(Tal), .Tb(Tb), .Tbl(Tbl)); 	// instance ns_logic
_register3_r U1_register3_r (.clk(clk), .d(w0), .q(w1), .reset_n(reset_n)); 		// instance register
o_logic U2_o_logic (.q(w1), .La(La), .Lb(Lb));  	// instance o_logic


endmodule
