module NOP(a, b, y1, y2); // No Operation
	input [63:0] a, b;
	output [63:0] y1, y2;
	
	assign y1 = 64'h0;
	
	assign y2 = 64'h0;
endmodule 

module NOT_A(a, b, y); // NOT a
	input  [63:0] a, b;
	output  [63:0] y;
	
	assign y = ~a;
	
endmodule 

module NOT_B(a, b, y); // NOT b
	input  [63:0] a, b;
	output  [63:0] y;
	
	assign y = ~b;
	
endmodule 

module AND_(a, b, y); // AND
	input [63:0] a, b;
	output [63:0] y2, y1;
	
	assign y = a & b;
	
endmodule 

module OR_(a, b, y); // OR
	input [63:0] a, b;
	output [63:0] y2, y1;
	
	assign y = a | b;
	
endmodule

module XOR_(a, b, y); // XOR
	input [63:0] a, b;
	output [63:0] y;
	
	assign y = a ^ b;
	
endmodule 

module XNOR_(a, b, y); // XNOR
	input [63:0] a, b;
	output [63:0] y;
	
	assign y = ~(a ^ b);
	
endmodule 

module shift_mux(d_in, shamt, d_out);
	input [7:0] d_in;
	input [1:0] shamt;
	output [3:0] d_out; 
	
	mx4 U4_mx4(.y(d_out[0]), .d0(d_in[4]), .d1(d_in[3]), .d2(d_in[2]), .d3(d_in[1]), .s(shamt));	
	mx4 U5_mx4(.y(d_out[1]), .d0(d_in[5]), .d1(d_in[4]), .d2(d_in[3]), .d3(d_in[2]), .s(shamt));	
	mx4 U6_mx4(.y(d_out[2]), .d0(d_in[6]), .d1(d_in[5]), .d2(d_in[4]), .d3(d_in[3]), .s(shamt));  
	mx4 U7_mx4(.y(d_out[3]), .d0(d_in[7]), .d1(d_in[6]), .d2(d_in[5]), .d3(d_in[4]), .s(shamt));  
	
endmodule

module LSL(a, shamt, y); // LSL A
	input [63:0] a;
	input [1:0] shamt;
	output reg [63:0] y;
	
	mx4 U0_mx4(.y(y[0]), .d0(a[0]), .d1(1'b0), .d2(1'b0), .d3(1'b0), .s(shamt)); 			// output D0 
	mx4 U1_mx4(.y(y[1]), .d0(a[1]), .d1(a[0]), .d2(1'b0), .d3(1'b0), .s(shamt));			// output D1 
	mx4 U2_mx4(.y(y[2]), .d0(a[2]), .d1(a[1]), .d2(a[0]), .d3(1'b0), .s(shamt));		// output D2
	mx4 U3_mx4(.y(y[3]), .d0(a[3]), .d1(a[2]), .d2(a[1]), .d3(a[0]), .s(shamt));	// output D3
	shift_mux U4_shift_mux(.d_in(a[7:4]), .shamt(shamt), .y(y[7:4]));
	shift_mux U5_shift_mux(.d_in(a[11:8]), .shamt(shamt), .y(y[11:8]));
	shift_mux U6_shift_mux(.d_in(a[15:12]), .shamt(shamt), .y(y[15:12]));
	shift_mux U7_shift_mux(.d_in(a[19:16]), .shamt(shamt), .y(y[19:16]));
	shift_mux U8_shift_mux(.d_in(a[23:20]), .shamt(shamt), .y(y[23:20]));
	shift_mux U9_shift_mux(.d_in(a[27:24]), .shamt(shamt), .y(y[27:24]));
	shift_mux U10_shift_mux(.d_in(a[31:28]), .shamt(shamt), .y(y[31:28]));
	shift_mux U11_shift_mux(.d_in(a[35:32]), .shamt(shamt), .y(y[35:32]));
	shift_mux U12_shift_mux(.d_in(a[39:36]), .shamt(shamt), .y(y[39:36]));
	shift_mux U13_shift_mux(.d_in(a[43:40]), .shamt(shamt), .y(y[43:40]));
	shift_mux U14_shift_mux(.d_in(a[47:44]), .shamt(shamt), .y(y[47:44]));
	shift_mux U15_shift_mux(.d_in(a[51:48]), .shamt(shamt), .y(y[51:48]));
	shift_mux U16_shift_mux(.d_in(a[55:52]), .shamt(shamt), .y(y[55:52]));
	shift_mux U17_shift_mux(.d_in(a[59:56]), .shamt(shamt), .y(y[59:56]));
	shift_mux U18_shift_mux(.d_in(a[63:60]), .shamt(shamt), .y(y[63:60]));
endmodule

module LSR(a, shamt, y); // LSR A
	input [63:0] a;
	input [1:0] shamt;
	output reg [63:0] y;
	
	shift_mux U0_shift_mux(.d_in(a[0:3]), .shamt(shamt), .y(y[0:3]));
	shift_mux U1_shift_mux(.d_in(a[7:4]), .shamt(shamt), .y(y[7:4]));
	shift_mux U2_shift_mux(.d_in(a[11:8]), .shamt(shamt), .y(y[11:8]));
	shift_mux U3_shift_mux(.d_in(a[15:12]), .shamt(shamt), .y(y[15:12]));
	shift_mux U4_shift_mux(.d_in(a[19:16]), .shamt(shamt), .y(y[19:16]));
	shift_mux U5_shift_mux(.d_in(a[23:20]), .shamt(shamt), .y(y[23:20]));
	shift_mux U6_shift_mux(.d_in(a[27:24]), .shamt(shamt), .y(y[27:24]));
	shift_mux U7_shift_mux(.d_in(a[31:28]), .shamt(shamt), .y(y[31:28]));
	shift_mux U8_shift_mux(.d_in(a[35:32]), .shamt(shamt), .y(y[35:32]));
	shift_mux U9_shift_mux(.d_in(a[39:36]), .shamt(shamt), .y(y[39:36]));
	shift_mux U10_shift_mux(.d_in(a[43:40]), .shamt(shamt), .y(y[43:40]));
	shift_mux U11_shift_mux(.d_in(a[47:44]), .shamt(shamt), .y(y[47:44]));
	shift_mux U12_shift_mux(.d_in(a[51:48]), .shamt(shamt), .y(y[51:48]));
	shift_mux U13_shift_mux(.d_in(a[55:52]), .shamt(shamt), .y(y[55:52]));
	shift_mux U14_shift_mux(.d_in(a[59:56]), .shamt(shamt), .y(y[59:56]));
	mx4 U4_mx4(.y(y[60]), .d0(a[60]), .d1(a[61]), .d2(a[62]), .d3(a[63]), .s(shamt)); 
	mx4 U5_mx4(.y(y[61]), .d0(a[61]), .d1(a[62]), .d2(a[63]), .d3(1'b0), .s(shamt));		
	mx4 U6_mx4(.y(y[62]), .d0(a[62]), .d1(a[63]), .d2(1'b0), .d3(1'b0), .s(shamt));			
	mx4 U7_mx4(.y(y[63]), .d0(a[63]), .d1(1'b0), .d2(1'b0), .d3(1'b0), .s(shamt));				
endmodule

module ASR(a, shamt, y); // ASR
	input [63:0] a;
	input [1:0] shamt;
	output reg [63:0] y;
	
	shift_mux U0_shift_mux(.d_in(a[0:3]), .shamt(shamt), .y(y[0:3]));
	shift_mux U1_shift_mux(.d_in(a[7:4]), .shamt(shamt), .y(y[7:4]));
	shift_mux U2_shift_mux(.d_in(a[11:8]), .shamt(shamt), .y(y[11:8]));
	shift_mux U3_shift_mux(.d_in(a[15:12]), .shamt(shamt), .y(y[15:12]));
	shift_mux U4_shift_mux(.d_in(a[19:16]), .shamt(shamt), .y(y[19:16]));
	shift_mux U5_shift_mux(.d_in(a[23:20]), .shamt(shamt), .y(y[23:20]));
	shift_mux U6_shift_mux(.d_in(a[27:24]), .shamt(shamt), .y(y[27:24]));
	shift_mux U7_shift_mux(.d_in(a[31:28]), .shamt(shamt), .y(y[31:28]));
	shift_mux U8_shift_mux(.d_in(a[35:32]), .shamt(shamt), .y(y[35:32]));
	shift_mux U9_shift_mux(.d_in(a[39:36]), .shamt(shamt), .y(y[39:36]));
	shift_mux U10_shift_mux(.d_in(a[43:40]), .shamt(shamt), .y(y[43:40]));
	shift_mux U11_shift_mux(.d_in(a[47:44]), .shamt(shamt), .y(y[47:44]));
	shift_mux U12_shift_mux(.d_in(a[51:48]), .shamt(shamt), .y(y[51:48]));
	shift_mux U13_shift_mux(.d_in(a[55:52]), .shamt(shamt), .y(y[55:52]));
	shift_mux U14_shift_mux(.d_in(a[59:56]), .shamt(shamt), .y(y[59:56]));
	mx4 U4_mx4(.y(y[60]), .d0(a[60]), .d1(a[61]), .d2(a[62]), .d3(a[63]), .s(shamt)); 
	mx4 U5_mx4(.y(y[61]), .d0(a[61]), .d1(a[62]), .d2(a[63]), .d3(a[63]), .s(shamt));		
	mx4 U6_mx4(.y(y[62]), .d0(a[62]), .d1(a[63]), .d2(a[63]), .d3(a[63]), .s(shamt));			
	mx4 U7_mx4(.y(y[63]), .d0(a[63]), .d1(a[63]), .d2(a[63]), .d3(a[63]), .s(shamt));		
endmodule 


module ADD(a, b, y); //aDD
	input [63:0] a, b;
	output [63:0] y;
	input ci;
	output co;
	wire c1;
	
	cla32 U0_cla32(.a(a[31:0]), .b(b[31:0]), .ci(ci), .y(y[31:0]), .co(c1)); 
	cla32 U1_cla32(.a(a[63:32]), .b(b[63:32]), .ci(c1), .y(y[63:32]), .co(co));
endmodule
	
module SUB(a, b, y); //SUb
	input [63:0] a, b;
	output [63:0] y;

	cla32 U0_cla32(.a(a[31:0]), .b(b[31:0]), .ci(ci), .y(y[31:0]), .co(c1)); 
	cla32 U1_cla32(.a(a[63:32]), .b(b[63:32]), .ci(c1), .y(y[63:32]), .co(co));
endmodule 
	
module MUL(clk,reset_n, op_start, op_done, op_clear, multiplier, multiplicand, result);	// multiplier module

input clk, reset_n, op_start, op_clear;	// start, clear signal, clock, reset signal
input [31:0] multiplier, multiplicand;	
output reg op_done;		// operation done signal
output [63:0] result;	// output 128 bit t_result

// Encoding states
parameter INIT = 2'b00;
parameter START = 2'b01;
parameter CALCULATE = 2'b10;
parameter DONE = 2'b11;

reg [1:0] state, next_state;
reg [5:0] cnt;		// 6 bit counter
reg [65:0] t_result;		// temporary result
reg [32:0] partial_product;
reg [32:0] multiplicand_1, multiplicand_2;	// 1A, 2A

always @(posedge clk or negedge reset_n)
begin
	if(!reset_n)	// reset_n == 0
		state <= INIT;
		
	else if(op_clear)	// op_clear == 1
		state <= INIT;
	
	else	// reset_n == 1 && op_clear == 0
		state <= next_state;
end

// state
always @(op_start, state, cnt)
begin
	case(state)
		INIT:
		begin
			if(op_start)
				next_state = START;
			else
				next_state = INIT;
		end
		
		START:
			next_state = CALCULATE;
		
		CALCULATE:
		begin
			if(cnt == 1'b1)
				next_state = DONE;
			else
				next_state = CALCULATE;
		end
		
		DONE:
			next_state = DONE;
			
		default:
			next_state = INIT;
	endcase
end

always @(t_result, multiplicand)
	begin
		multiplicand_1 = {multiplicand[31], multiplicand}; // 1*A multiplicand_1
		multiplicand_2 = multiplicand_1 << 1;				 // 2*A multiplicand_2
		
	case (t_result[2:0]) // check lower 3 bit
		3'b000:
			partial_product = t_result[65:33]; // shift
		3'b001:
			partial_product = t_result[65:33] + multiplicand_1; // +A
		3'b010:
			partial_product = t_result[65:33] + multiplicand_1; // +A
		3'b011:
			partial_product = t_result[65:33] + multiplicand_2; // +2A
		3'b100:
			partial_product = t_result[65:33] - multiplicand_2; // -2A
		3'b101: 
			partial_product = t_result[65:33] - multiplicand_1; // -A
		3'b110:
			partial_product = t_result[65:33] - multiplicand_1; // -A
		3'b111:
			partial_product = t_result[65:33]; // shift
		default:
			partial_product = 33'bx;
				
	endcase
end

always @(posedge clk)
begin 
	case (state)
		INIT : // INIT state
		begin
			t_result <= 65'b0;			 
			op_done <= 1'b0; // All output is 0
		end
			
		START: // START state
		begin
			t_result[65:33] <= 32'b0;
			t_result[32:1] <= multiplier;
			t_result[0] <= 1'b0;	// For x code
			cnt <= 6'b100000;
			op_done <= 1'b0; // initialization
		end
			
		CALCULATE:	// CALCULATE state
		begin
			t_result[65:31] <= {partial_product[63],partial_product[63],partial_product}; // signed extended
			t_result[30:0] <= t_result[32:2]; // shift >> 2
			cnt <= cnt - 6'b000001; 
			if(cnt == 6'b000001)		
				op_done <=1'b1; 		
			else 						
				op_done <= 1'b0;		
			end
			
		DONE : // DONE state
		begin
			op_done <= 1'b1; 
		end
	endcase
end
	
assign result = t_result[64:1]; // assign result
	
endmodule	