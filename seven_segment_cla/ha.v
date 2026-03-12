module ha(a, b, s, co);		// half adder
input a, b;
output s, co;
assign s=a^b;		// xor gate
assign co=a&b;		// and gate
endmodule
