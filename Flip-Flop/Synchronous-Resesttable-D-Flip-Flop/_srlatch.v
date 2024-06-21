module _srlatch(r,s,q,q_bar);		// SR latch
input r,s;
output q,q_bar;

_nor2 U0_nor2(.a(r), .b(q_bar), .y(q)); // instance nor gate
	
_nor2 U1_nor2(.a(s), .b(q), .y(q_bar)); // instance nor gate

endmodule
