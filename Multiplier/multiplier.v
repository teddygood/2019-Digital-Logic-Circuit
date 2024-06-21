module multiplier(clk,reset_n, op_start, op_done, op_clear, multiplier, multiplicand, result);	// multiplier module

input clk, reset_n, op_start, op_clear;	// start, clear signal, clock, reset signal
input [63:0] multiplier, multiplicand;	
output reg op_done;		// operation done signal
output [127:0] result;	// output 128 bit t_result

// Encoding states
parameter INIT = 2'b00;
parameter START = 2'b01;
parameter CALCULATE = 2'b10;
parameter DONE = 2'b11;

reg [1:0] state, next_state;
reg [5:0] cnt;		// 6 bit counter
reg [129:0] t_result;		// temporary result
reg [64:0] partial_product;
reg [64:0] multiplicand_1, multiplicand_2;	// 1A, 2A

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
		multiplicand_1 = {multiplicand[63], multiplicand}; // 1*A multiplicand_1
		multiplicand_2 = multiplicand_1 << 1;				 // 2*A multiplicand_2
		
	case (t_result[2:0]) // check lower 3 bit
		3'b000:
			partial_product = t_result[129:65]; // shift
		3'b001:
			partial_product = t_result[129:65] + multiplicand_1; // +A
		3'b010:
			partial_product = t_result[129:65] + multiplicand_1; // +A
		3'b011:
			partial_product = t_result[129:65] + multiplicand_2; // +2A
		3'b100:
			partial_product = t_result[129:65] - multiplicand_2; // -2A
		3'b101: 
			partial_product = t_result[129:65] - multiplicand_1; // -A
		3'b110:
			partial_product = t_result[129:65] - multiplicand_1; // -A
		3'b111:
			partial_product = t_result[129:65]; // shift
		default:
			partial_product = 65'bx;
				
	endcase
end

always @(posedge clk)
begin 
	case (state)
		INIT : // INIT state
		begin
			t_result <= 129'b0;			 
			op_done <= 1'b0; // All output is 0
		end
			
		START: // START state
		begin
			t_result[129:65] <= 64'b0;
			t_result[64:1] <= multiplier;
			t_result[0] <= 1'b0;	// For x code
			cnt <= 6'b100000;
			op_done <= 1'b0; // initialization
		end
			
		CALCULATE:	// CALCULATE state
		begin
			t_result[129:63] <= {partial_product[63],partial_product[63],partial_product}; // signed extended
			t_result[62:0] <= t_result[64:2]; // shift >> 2
			cnt <= cnt - 6'b000001; 
			if(cnt==6'b000001)		
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
	
assign result = t_result[128:1]; // assign result
	
endmodule