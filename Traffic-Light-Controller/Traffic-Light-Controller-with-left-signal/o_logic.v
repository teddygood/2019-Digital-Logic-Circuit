module o_logic(q,La,Lb);		// output logic

input [2:0] q;	// input q0, q1, q2
output [1:0] La, Lb;	// La0, La1, Lb0, Lb1

wire not_q0, not_q2;	// q0_bar, q2_bar
wire w0,w1;

_inv U0_inv(.a(q[0]), .y(not_q0));	// q0_bar
_inv U1_inv(.a(q[2]), .y(not_q2));	// q2_bar

// La[1]
_and2 U2_and2(.a(q[1]), .b(not_q0), .y(w0));
_or2	U3_or2(.a(w0), .b(q[2]), .y(La[1]));

// La[0]
_or2 	U4_or2(.a(q[0]), .b(q[2]), .y(La[0]));

// Lb[1]
_and2 U5_and2(.a(q[1]), .b(not_q0), .y(w1));
_or2	U6_or2(.a(not_q2), .b(w1), .y(Lb[1]));

// Lb[0]
_or2	U7_or2(.a(not_q2), .b(q[0]), .y(Lb[0]));

endmodule
