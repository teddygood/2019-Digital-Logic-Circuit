module fifo_out(state, data_count, full, empty, wr_ack, wr_err, rd_ack, rd_err); // fifo out
input [2:0] state;
input [3:0] data_count;
output reg full, empty, wr_ack, wr_err, rd_ack, rd_err;
// write acknowledge, error, read acknowledge, error

// parameter setting
parameter INIT = 3'b000;
parameter WRITE = 3'b001;
parameter READ = 3'b010;
parameter WR_ERROR = 3'b011;
parameter RD_ERROR = 3'b100;

// full, empty setting
always @(data_count)
	begin
		if(data_count == 4'h0) // when data is zero 
		begin
			full <= 1'b0;			// full =0. empty =1
			empty <= 1'b1;
		end
		
		else if(data_count == 4'h8)// when data is full
		begin
			full <= 1'b1;				// full = 1, empty =0 
			empty <= 1'b0;
		end
		else								
		begin
			full <= 1'b0;				// full, empty = 0
			empty <= 1'b0;
		end
	end

// handshake setting	
always@(state)
	begin
	
		case(state)
		INIT:		// INIT
		begin
			wr_ack <= 0;
			wr_err <= 0;
			rd_ack <= 0;
			rd_err <= 0;
		end
		WRITE:	 	// WRITE
		begin
			wr_ack <= 1;
			wr_err <= 0;
			rd_ack <= 0;
			rd_err <= 0;
		end
		READ:		// READ
		begin
			wr_ack <= 0;
			wr_err <= 0;
			rd_ack <= 1;
			rd_err <= 0;
		end
		WR_ERROR:		// WR_ERROR
		begin
			wr_ack <= 0;
			wr_err <= 1;
			rd_ack <= 0;
			rd_err <= 0;
		end
		RD_ERROR:					// RD_ERROR
		begin
			wr_ack <= 0;
			wr_err <= 0;
			rd_ack <= 0;
			rd_err <= 1;
		end
		default // state isn't IDLE, WRITE, WR_ERROR, READ, RD_ERROR
			begin
				wr_ack=1'bx; wr_err=1'bx; rd_ack=1'bx; rd_err=1'bx; // all inputs are unknown
			end
			
		endcase
	end
endmodule
