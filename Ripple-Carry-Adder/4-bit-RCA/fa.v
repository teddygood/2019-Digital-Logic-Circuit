module fa(a,b,ci,s,co); 		// full adder
input a,b,ci;
output s,co;
wire c1,c2,sm;
  ha U0_ha(.a(b), .b(ci), .s(sm), .co(c1));		// half adder
  ha U1_ha(.a(a), .b(sm), .s(s), .co(c2));		// half adder
  _or2 U2_or2(.a(c1), .b(c2), .y(co)); 			// or gate
endmodule
