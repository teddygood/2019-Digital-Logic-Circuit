module fifo_cal(state, head, tail, data_count, we,re,next_head, next_tail, next_data_count); // fifo calculator
input [2:0] state, head, tail;	// current state, pointer
input [3:0] data_count;
output reg we, re;	// write enable, read enable
output reg [2:0] next_head, next_tail;
output reg [3:0] next_data_count;

// parameter setting
parameter INIT = 3'b000;
parameter WRITE = 3'b001;
parameter READ = 3'b010;
parameter WR_ERROR = 3'b011;
parameter RD_ERROR = 3'b100;

always @(state, data_count, head, tail)
begin
	case(state)
		INIT : // INIT state
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
		default	// state isn't IDLE, WRITE, WR_ERROR, READ, RD_ERROR
		begin
			next_data_count <=4'bx;
			next_head <= 3'bx;
			next_tail <= 3'bx;
			we <= 1'bx;
			re <= 1'bx; 	// all outputs are unknown
		end
	endcase
end
endmodule
