module mx2(a, b, sel, d_out); // 2-to-1 Mux
input	[31:0] a, b;
input sel; // sel(select signal)
output reg [31:0] d_out; 
	
always@(sel, a, b)
	begin
		case(sel)
			1'b0 : d_out = a;
			1'b1 : d_out = b;
			default : d_out = 32'bx;
		endcase
	end
endmodule
	