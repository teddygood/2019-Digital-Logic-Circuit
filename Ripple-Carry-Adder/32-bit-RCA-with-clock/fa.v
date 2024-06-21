module fa(a,b,ci,s,co); 		// full adder
input a,b,ci;
output s,co;
wire [2:0] w;
  ha U0_ha(.a(b), .b(ci), .s(w[0]), .co(w[1]));		// half adder
  ha U1_ha(.a(a), .b(w[0]), .s(s), .co(w[2]));		// half adder
  _or2 U2_or2(.a(w[1]), .b(w[2]), .y(co)); 			// or gate
endmodule
