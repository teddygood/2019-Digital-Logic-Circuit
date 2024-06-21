module DMAC_write_operation(Addr, we, to_reg); // write operation 
input	we;	// write enable
input [3:0] Addr; // select signal
output [15:0] to_reg; 
	
wire [15:0] write_wire;
	
// instance 3 to 8 decoder
_4_to_16_decoder U0_4_to_16_decoder(.d(Addr), .q(write_wire));
	
_and2 U0_and2(.a(write_wire[0]), .b(we), .y(to_reg[0])); 
_and2 U1_and2(.a(write_wire[1]), .b(we), .y(to_reg[1])); 
_and2 U2_and2(.a(write_wire[2]), .b(we), .y(to_reg[2])); 
_and2 U3_and2(.a(write_wire[3]), .b(we), .y(to_reg[3])); 
_and2 U4_and2(.a(write_wire[4]), .b(we), .y(to_reg[4])); 
_and2 U5_and2(.a(write_wire[5]), .b(we), .y(to_reg[5])); 
_and2 U6_and2(.a(write_wire[6]), .b(we), .y(to_reg[6])); 
_and2 U7_and2(.a(write_wire[7]), .b(we), .y(to_reg[7])); 
_and2 U8_and2(.a(write_wire[8]), .b(we), .y(to_reg[8])); 
_and2 U9_and2(.a(write_wire[9]), .b(we), .y(to_reg[9])); 
_and2 U10_and2(.a(write_wire[10]), .b(we), .y(to_reg[10])); 
_and2 U11_and2(.a(write_wire[11]), .b(we), .y(to_reg[11])); 
_and2 U12_and2(.a(write_wire[12]), .b(we), .y(to_reg[12])); 
_and2 U13_and2(.a(write_wire[13]), .b(we), .y(to_reg[13])); 
_and2 U14_and2(.a(write_wire[14]), .b(we), .y(to_reg[14])); 
_and2 U15_and2(.a(write_wire[15]), .b(we), .y(to_reg[15])); 


	
endmodule
