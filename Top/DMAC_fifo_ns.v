module DMAC_fifo_ns(wr_en, rd_en, state, data_count, next_state); // fifo next state
	input wr_en, rd_en;	// write enable, read enable
	input [2:0] state;
	input [4:0] data_count;
	output [2:0] next_state;
	reg [2:0] next_state;

// parameter setting
	parameter INIT = 3'b000;
	parameter NO_OP = 3'b001;
	parameter WRITE = 3'b010;
	parameter WR_ERROR = 3'b011;
	parameter READ = 3'b100;
	parameter RD_ERROR = 3'b101;

always @(data_count, state, wr_en, rd_en)
begin
	case(state)
			INIT: // INIT state
			begin
				if(wr_en) // wr_en == 1
				begin
					if(data_count == 5'b10000)	// data_count == 8
						next_state = WR_ERROR;
					else								// 0 <= data count < 8
						next_state = WRITE;
				end
				
				else if(rd_en) // rd_en == 1
				begin
					if(data_count == 5'b00000)	// data_count == 0
						next_state = RD_ERROR;
					else								// 0 < data count <= 8
						next_state = READ;
				end
				
				else	// rd_en == 0 && wr_en == 0
					next_state = NO_OP;
			end
			NO_OP:	// NO_OP state
			begin
				if(wr_en) // wr_en == 1
				begin
					if(data_count == 5'b10000)	// data_count == 8
						next_state = WR_ERROR;
					else								// 0 <= data count < 8
						next_state = WRITE;
				end
				
				else if(rd_en)	// rd_en == 1
				begin
					if(data_count == 5'b00000)	// data_count == 0
						next_state = RD_ERROR;
					else								// 0 < data count <= 8
						next_state = READ;
				end
				
				else	// rd_en == 0 && wr_en == 0
					next_state = NO_OP;
			end
			 
			WRITE: // WRITE state
			begin
				if(wr_en) // wr_en == 1
				begin
					if(data_count == 5'b10000)	// data_count == 8
						next_state = WR_ERROR;
					else								// 0 <= data count < 8
						next_state = WRITE;
				end
				
				else if(rd_en) // rd_en == 1
				begin
					if(data_count == 5'b00000)	// data_count == 0
						next_state = RD_ERROR;
					else								// 0 < data count <= 8
						next_state = READ;
				end
				
				else	// rd_en == 0 && wr_en == 0
					next_state = NO_OP;
			end
			
			READ:	// READ state
			begin
				if(wr_en) // wr_en == 1
				begin
					if(data_count == 5'b10000)	// data_count == 8
						next_state = WR_ERROR;
					else								// 0 <= data count < 8
						next_state = WRITE;
				end
				
				else if(rd_en)	// rd_en == 1
				begin
					if(data_count == 5'b00000)	// data_count == 0
						next_state = RD_ERROR;
					else								// 0 < data count <= 8
						next_state = READ;
				end
				
				else	// rd_en == 0 && wr_en == 0
					next_state = NO_OP;
			end
			
			WR_ERROR: // WR_ERROR state
			begin
				if(wr_en) 					 // wr_en == 1
					next_state = WR_ERROR;
				else if(rd_en)				// rd_en == 1
					next_state = READ;
				else							// rd_en == 0 && wr_en == 0
					next_state = NO_OP;
			end
			
			RD_ERROR: // RD_ERROR state
			begin
				if(wr_en)				// wr_en == 1
					next_state = WRITE;
				else if(rd_en)			// rd_en == 1
					next_state = RD_ERROR;
				else						// rd_en == 0 && wr_en == 0
					next_state = NO_OP;
			end
			
			default
				next_state = 3'bx; // state isn't INIT, WRITE, WR_ERROR, READ, RD_ERROR -> next_state 3'bx
		endcase
end
endmodule