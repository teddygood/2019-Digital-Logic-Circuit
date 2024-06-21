module bus_enc(d, q);
	input[4:0] d;
	output reg[2:0] q;

	always @ (d)
		begin
			if (d == 5'b00000) 
				q <= 3'b000;
			else if(d == 5'b10000)
				q <= 3'b001;
			else if(d == 5'b01000)
				q <= 3'b010;
			else if(d == 5'b00100)
				q <= 3'b011;
			else if(d == 5'b00010)
				q <= 3'b100;
			else if(d == 5'b00001)
				q <= 3'b101;
			else
				q <= 32'hx;
		end
endmodule 