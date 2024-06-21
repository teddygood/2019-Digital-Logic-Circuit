
module ns_logic(q, d, Ta, Tb); // next logic 

input Ta, Tb;
input [1:0] q;		// q0, q1
output [1:0] d;	// d0, d1
wire Ta_bar, Tb_bar;
wire w_q_0, w_q_1;	// q0_bar, q1_bar
wire w0, w1;			// and gate output

_inv U0_inv(.a(Ta), .y(Ta_bar));	// instance inverter
_inv U1_inv(.a(Tb), .y(Tb_bar));
_inv U2_inv(.a(q[0]), .y(w_q_0));
_inv U3_inv(.a(q[1]), .y(w_q_1));

_xor2 U4_xor2(.a(q[1]), .b(q[0]), .y(d[1]));	// instance xor
_and3 U5_and3(.a(w_q_0), .b(w_q_1), .c(Ta_bar), .y(w0)); // instance and
_and3 U6_and3(.a(q[1]), .b(w_q_0), .c(Tb_bar), .y(w1)); 
_or2	U7_or2(.a(w0), .b(w1), .y(d[0]));	// instance or

endmodule

/*
module ns_logic(q, d, Ta, Tb);
input Ta, Tb;
input [1:0] q;
output [1:0] d;
reg [1:0] d;
always@*
case (q)
   2'b00 : 
	begin
   if(Ta==0) d<=2'b01;
   else if(Ta==1) d<=2'b00;
   end
   2'b01 : d<=2'b10;
   2'b10 : 
	begin
   if(Tb==0) d<=2'b11;
   else if(Tb==1) d<=2'b10;
   end
   2'b11 : d<=2'b00;
   default : d<=2'bx;
endcase
endmodule
*/
