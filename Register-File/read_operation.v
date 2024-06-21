module _8_to_1_MUX(a, b, c, d, e, f, g, h, sel, d_out); // 8 to 1 Mux
input	[31:0] a, b, c, d, e, f, g, h; 
input [2:0] sel; // select signal
output reg [31:0] d_out; // 32-bit output d_out
	
always @ (sel, a, b, c, d, e, f, g, h)
	begin
		case(sel)
			3'b000 : d_out = a;
			3'b001 : d_out = b;
			3'b010 : d_out = c;
			3'b011 : d_out = d;
			3'b100 : d_out = e;
			3'b101 : d_out = f;
			3'b110 : d_out = g;
			3'b111 : d_out = h;
			default : d_out = 32'bx;
		endcase
	end
endmodule

module read_operation(Addr, Data, from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6, from_reg7); // read operation 
input [31:0] from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6, from_reg7;
input [2:0] Addr; // select signal
output [31:0] Data; 

// instance 8 to 1 Mux
_8_to_1_MUX U0_8_to_1_MUX(.a(from_reg0), .b(from_reg1), .c(from_reg2), .d(from_reg3), .e(from_reg4), .f(from_reg5), .g(from_reg6), .h(from_reg7), .sel(Addr), .d_out(Data));
	
	
endmodule
	

	