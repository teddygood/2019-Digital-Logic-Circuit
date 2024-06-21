module _16_to_1_MUX(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, sel, d_out); // 8 to 1 Mux
input	[31:0] a, b, c, d, e, f, g, h, i, j, k, l, m, n, o; 
input [3:0] sel; // select signal
output reg [31:0] d_out; // 32-bit output d_out
	
always @ (sel, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)
	begin
		case(sel)
			4'b0000 : d_out = a;
			4'b0001 : d_out = b;
			4'b0010 : d_out = c;
			4'b0011 : d_out = d;
			4'b0100 : d_out = d;
			4'b0101 : d_out = e;
			4'b0110 : d_out = f;
			4'b0111 : d_out = g;
			4'b1000 : d_out = h;
			4'b1001 : d_out = i;
			4'b1010 : d_out = j;
			4'b1011 : d_out = k;
			4'b1100 : d_out = l;
			4'b1101 : d_out = m;
			4'b1110 : d_out = n;
			4'b1111 : d_out = o;
			default : d_out = 32'bx;
		endcase
	end
endmodule
