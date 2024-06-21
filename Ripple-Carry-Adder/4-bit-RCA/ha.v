module ha(a, b, s, co);		// half adder
input a, b;
output s, co;
_and2 U0_and2(.a(a), .b(b), .y(co));		// and gate
_xor2 U1_xor2(.a(a), .b(b), .y(s));			// xor gate
endmodule
