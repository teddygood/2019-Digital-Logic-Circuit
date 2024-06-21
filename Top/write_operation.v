module write_operation(Addr, we, to_reg); // write operation 
input	we;	// write enable
input [2:0] Addr; // select signal
output [7:0] to_reg; 
	
wire [7:0]	write_wire;
	
// instance 3 to 8 decoder
_3_to_8_decoder U0_3_to_8_decoder(.d(Addr), .q(write_wire));
	
_and2 U0_and2(.a(write_wire[0]), .b(we), .y(to_reg[0])); 
_and2 U1_and2(.a(write_wire[1]), .b(we), .y(to_reg[1])); 
_and2 U2_and2(.a(write_wire[2]), .b(we), .y(to_reg[2])); 
_and2 U3_and2(.a(write_wire[3]), .b(we), .y(to_reg[3])); 
_and2 U4_and2(.a(write_wire[4]), .b(we), .y(to_reg[4])); 
_and2 U5_and2(.a(write_wire[5]), .b(we), .y(to_reg[5])); 
_and2 U6_and2(.a(write_wire[6]), .b(we), .y(to_reg[6])); 
_and2 U7_and2(.a(write_wire[7]), .b(we), .y(to_reg[7])); 
	
endmodule
			
