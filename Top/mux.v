module mx2(d1, s, y); // Selectively choose two values by 1bit sel

input [31:0] d1;
input s;
output reg [31:0] y;

always@(s, d1)
begin
	if (s == 0)
		y <= 32'h00000000;
	else
		y<= d1;
end
endmodule

module mx4(y,d0,d1,d2,d3,s);	// 1 bit 4-to-1 Multiplexer
input d0,d1,d2,d3;
input [1:0] s;			// selection signal
output y;
wire w0,w1;

mx2 U0_mx2(.d0(d0),.d1(d1),.s(s[0]),.y(w0));	// instance mx2
mx2 U1_mx2(.d0(d2),.d1(d3),.s(s[0]),.y(w1));
mx2 U2_mx2(.d0(w0),.d1(w1),.s(s[1]),.y(y));

endmodule


module mux2_1bit(d0, d1, s, y);
	input d0, d1;
	input s;
	output reg y;
	
	always @ (s, d0, d1)
		begin
			if (s == 0)
				y <= d0;
			else if(s == 1)
				y <= d1;
			else
				y <= 1'bx;
		end
endmodule 

module mux2_16bit(d0, d1, s, y);
	input [15:0] d0, d1;
	input s;
	output reg [15:0] y;
	
	always @ (s, d0, d1)
		begin
			if (s == 0)
				y <= d0;
			else if(s == 1)
				y <= d1;
			else
				y <= 16'hxxxx;
		end
endmodule 

module mux2_32bit(d0, d1, s, y);
	input [31:0] d0, d1;
	input s;
	output reg [31:0] y;
	
	always @ (s, d0, d1)
		begin
			if (s == 0)
				y <= d0;
			else if(s == 1)
				y <= d1;
			else
				y <= 32'hx;
		end
endmodule 

module mux6_32bit(d0, d1, d2, d3, d4, s, y);
	input[31:0] d0, d1, d2, d3, d4;
	input[2:0] s;
	output reg[31:0] y;
	
	always @ (s, d0, d1, d2, d3, d4)
		begin
			if (s == 3'b000) 
				y <= 32'h0;
			else if(s == 3'b001)
				y <= d0;
			else if (s == 3'b010)
				y <= d1;
			else if (s == 3'b011)
				y <= d2;
			else if (s == 3'b100)
				y <= d3;
			else if (s == 3'b101)
				y <= d4;
			else 
				y = 32'hx;
		end
	
endmodule 

/*
module maybe_mux(d0, d1, d2, d3, d4, s, y); // Selectively choose 8 values by sel
	input [31:0] d0, d1, d2, d3, d4;
	input [4:0] s;
	output reg [31:0] y;

	always @ (s, d0, d1, d2, d3, d4)
	begin
		if (s == 5'b00000) 
			y <= 32'h0;
		else if(s == 5'b10000)
			y <= d0;
		else if(s == 5'b01000)
			y <= d1;
		else if(s == 5'b00100)
			y <= d2;
		else if(s == 5'b00010)
			y <= d3;
		else if(s == 5'b00001)
			y <= d4;
		else
			y <= 32'hx;
	end
endmodule
*/