module ns_logic(q, d, Ta, Tal, Tb, Tbl); // next logic

input Ta, Tb, Tal, Tbl;		// input Ta, Tb, Tal(Ta left), Tbl(left)
input [2:0] q;		// q0, q1, q2
output [2:0] d;	// d0, d1, d2
// inverter output
wire Ta_bar, Tb_bar, Tal_bar, Tbl_bar;
wire w_q_0, w_q_1, w_q_2;
// and gate output
wire w0,w1,w2, w3,w4,w5, w6,w7,w8,w9;
// instance inverter
_inv U0_inv(.a(Ta), .y(Ta_bar));
_inv U1_inv(.a(Tb), .y(Tb_bar));
_inv U2_inv(.a(q[2]), .y(w_q_2));
_inv U3_inv(.a(q[1]), .y(w_q_1));
_inv U4_inv(.a(q[0]), .y(w_q_0));
_inv U5_inv(.a(Tal), .y(Tal_bar));
_inv U6_inv(.a(Tbl), .y(Tbl_bar));

// d2 = ~q2*q1*q0 + q2*q1 + q2*q1*~q0
_and3 U7_and3(.a(w_q_2), .b(q[1]), .c(q[0]), .y(w0));
_and2	U8_and2(.a(q[2]), .b(w_q_1), .y(w1));
_and3 U9_and3(.a(q[2]), .b(q[1]), .c(w_q_0), .y(w2));
_or3 U10_or3(.a(w0), .b(w1), .c(w2), .y(d[2]));

// d1 = ~q2*~q1*q0+q1*~q0+q2*~q1*q0
_and3 U11_and3(.a(w_q_2), .b(w_q_1), .c(q[0]), .y(w3));
_and2 U12_and2(.a(q[1]), .b(w_q_0), .y(w4));
_and3 U13_and3(.a(q[2]), .b(w_q_1), .c(q[0]), .y(w5));
_or3 U14_or3(.a(w3), .b(w4), .c(w5), .y(d[1]));

// d0 = ~q2*~q1*~q0*~Ta+~q2*q1*~q0*~Tal+q2*~q1*~q0*~Tb+q2*q1*~q0*~Tbl
_and4 U15_and4(.a(w_q_2), .b(w_q_1), .c(w_q_0), .d(Ta_bar), .y(w6));
_and4 U16_and4(.a(w_q_2), .b(q[1]), .c(w_q_0), .d(Tal_bar), .y(w7));
_and4 U17_and4(.a(q[2]), .b(w_q_1), .c(w_q_0), .d(Tb_bar), .y(w8));
_and4 U18_and4(.a(q[2]), .b(q[1]), .c(w_q_0), .d(Tbl_bar), .y(w9));
_or4 U19_or4(.a(w6), .b(w7), .c(w8), .d(w9), .y(d[0]));
endmodule
