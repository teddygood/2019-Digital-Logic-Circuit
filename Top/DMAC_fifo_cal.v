// recieve current register's status and then calculate next status
module DMAC_fifo_cal(state, head, tail, data_count, we, re, next_head, next_tail, next_data_count);
	input[2:0] state, head, tail;
	input[4:0] data_count;
	output reg we, re;
	output reg[2:0] next_head, next_tail;
	output reg[4:0] next_data_count;
	
	parameter INIT = 3'b000;
	parameter NO_OP = 3'b001;
	parameter WRITE = 3'b010;
	parameter WR_ERROR = 3'b011;
	parameter READ = 3'b100;
	parameter RD_ERROR = 3'b101;
	//states encoding
	//110 and 111 are not used
	
	always @ (state, head, tail, data_count)
		begin
			next_data_count = 0;
			next_head =0;
			next_tail =0;
			we =0;
			re =0;
			case(state)
			INIT : // INIT state
			begin 
				next_data_count <= data_count;
				next_head <= head;
				next_tail <= tail;
				we <= 0;					// no operation
				re <= 0;
			end
			NO_OP:
			begin
				next_data_count <= data_count;
				next_head <= head;
				next_tail <= tail;
				we <= 0;					// no operation
				re <= 0;
			end
			WRITE: // WRITE state 
			begin
				next_data_count <= data_count + 1'b1; // data count++
				next_head <= head;
				next_tail <= tail + 3'b001;	// tail pointer++
				we <= 1;							// write enable = 1
				re <= 0;
			end
			READ:	// READ state
			begin
				next_data_count <= data_count - 1'b1;	// data count-- 
				next_head <= head + 3'b001;					// head pointer++
				we <= 0;
				re <= 1;											// read enable = 1
			end
			WR_ERROR: // WR_ERROR state
			begin 
				next_data_count <= data_count;
				next_head <= head;
				next_tail <= tail;
				we <= 0;								// no operation
				re <= 0;
			end
			RD_ERROR:	// RD_ERROR state
			begin 
				next_data_count <= data_count;
				next_head <= head;
				next_tail <= tail;
				we <= 0;								// no operation
				re <= 0;
			end
			default	// state isn't IDLE, NO_OP, WRITE, WR_ERROR, READ, RD_ERROR
			begin
				next_data_count <= 5'bx;
				next_head <= 3'bx;
				next_tail <= 3'bx;
				we <= 1'bx;
				re <= 1'bx; 	// all outputs are unknown
			end
		endcase
	end
endmodule
	