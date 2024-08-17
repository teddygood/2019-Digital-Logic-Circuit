// Next State Module for FIFO
module fifo_ns(
    input wr_en,           // write enable
    input rd_en,           // read enable
    input [2:0] state,     // current state
    input [3:0] data_count,// number of data in FIFO
    output reg [2:0] next_state // next state
);

    // State binary encoding
    parameter INIT = 3'b000;
    parameter WRITE = 3'b001;
    parameter WR_ERR = 3'b010;
    parameter NO_OP = 3'b011;
    parameter READ = 3'b100;
    parameter RD_ERR = 3'b101;

    // FIFO size parameter
    parameter FIFO_FULL = 4'b1000;  // Maximum capacity of the FIFO
    parameter FIFO_EMPTY = 4'b0000; // Empty FIFO condition

    // Combinational logic for next state calculation
    always @(*) begin
        case(state)
            INIT: begin
                if (wr_en && data_count < FIFO_FULL) 
                    next_state <= WRITE;          // Write if not full
                else if (rd_en && data_count == FIFO_EMPTY)
                    next_state <= RD_ERR;         // Read error if empty
                else 
                    next_state <= NO_OP;          // No operation otherwise
            end
            
            WRITE: begin
                if (wr_en) begin
                    if (data_count < FIFO_FULL)
                        next_state <= WRITE;      // Continue writing if not full
                    else 
                        next_state <= WR_ERR;     // Write error if full
                end else if (rd_en && data_count > FIFO_EMPTY) 
                    next_state <= READ;           // Read if not empty
                else 
                    next_state <= NO_OP;          // No operation otherwise
            end
            
            WR_ERR: begin
                if (wr_en && data_count == FIFO_FULL) 
                    next_state <= WR_ERR;         // Stay in write error if full
                else if (rd_en && data_count > FIFO_EMPTY) 
                    next_state <= READ;           // Read if not empty
                else 
                    next_state <= NO_OP;          // No operation otherwise
            end
            
            NO_OP: begin
                if (wr_en) begin
                    if (data_count < FIFO_FULL)
                        next_state <= WRITE;      // Write if not full
                    else 
                        next_state <= WR_ERR;     // Write error if full
                end else if (rd_en) begin
                    if (data_count > FIFO_EMPTY)
                        next_state <= READ;       // Read if not empty
                    else 
                        next_state <= RD_ERR;     // Read error if empty
                end else 
                    next_state <= NO_OP;          // No operation otherwise
            end
            
            RD_ERR: begin
                if (rd_en && data_count == FIFO_EMPTY) 
                    next_state <= RD_ERR;         // Stay in read error if empty
                else if (wr_en && data_count < FIFO_FULL) 
                    next_state <= WRITE;          // Write if not full
                else 
                    next_state <= NO_OP;          // No operation otherwise
            end
            
            READ: begin
                if (rd_en) begin
                    if (data_count > FIFO_EMPTY)
                        next_state <= READ;       // Continue reading if not empty
                    else 
                        next_state <= RD_ERR;     // Read error if empty
                end else if (wr_en && data_count < FIFO_FULL) 
                    next_state <= WRITE;          // Write if not full
                else 
                    next_state <= NO_OP;          // No operation otherwise
            end
            
            default: 
                next_state <= 3'bxxx;             // Undefined state
        endcase
    end
endmodule
