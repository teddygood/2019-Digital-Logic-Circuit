module _register8(clk, d, q); // 8-bit register
input				clk; // 1-bit input clk(clock)
input [7:0] 	d;   // 8-bit input d
output [7:0] 	q;   // 8-bit output q
	
	// 8-bit register
_dff U0_dff(.clk(clk), .d(d[0]), .q(q[0])); // 1-bit d flip-flop 'I0_dff' instance
_dff U1_dff(.clk(clk), .d(d[1]), .q(q[1])); // 1-bit d flip-flop 'I1_dff' instance
_dff U2_dff(.clk(clk), .d(d[2]), .q(q[2])); // 1-bit d flip-flop 'I2_dff' instance
_dff U3_dff(.clk(clk), .d(d[3]), .q(q[3])); // 1-bit d flip-flop 'I3_dff' instance
_dff U4_dff(.clk(clk), .d(d[4]), .q(q[4])); // 1-bit d flip-flop 'I4_dff' instance
_dff U5_dff(.clk(clk), .d(d[5]), .q(q[5])); // 1-bit d flip-flop 'I5_dff' instance
_dff U6_dff(.clk(clk), .d(d[6]), .q(q[6])); // 1-bit d flip-flop 'I6_dff' instance
_dff U7_dff(.clk(clk), .d(d[7]), .q(q[7])); // 1-bit d flip-flop 'I7_dff' instance
	
endmodule