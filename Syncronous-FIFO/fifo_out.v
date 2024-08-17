// FIFO Output Logic Module
module fifo_out(
    input [2:0] state,       // current state
    input [3:0] data_count,  // number of data in FIFO
    output reg full, empty,  // full/empty status flags
    output reg wr_ack, wr_err, rd_ack, rd_err // 4 handshake signals
);

    // State binary encoding
    parameter INIT = 3'b000;
    parameter WRITE = 3'b001;
    parameter WR_ERR = 3'b010;
    parameter NO_OP = 3'b011;
    parameter READ = 3'b100;
    parameter RD_ERR = 3'b101;

    // FIFO size parameter
    parameter FIFO_SIZE = 4'b1000;  // Maximum capacity of FIFO
    parameter FIFO_EMPTY = 4'b0000; // Empty state of FIFO

    // Combinational logic for output signals
    always @(state, data_count) begin
        // Default values for outputs
        wr_ack <= 1'b0;
        rd_ack <= 1'b0;
        wr_err <= 1'b0;
        rd_err <= 1'b0;

        // Set full and empty flags based on data_count
        if (data_count == FIFO_SIZE) begin
            full <= 1'b1;
            empty <= 1'b0;
        end else if (data_count == FIFO_EMPTY) begin
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            full <= 1'b0;
            empty <= 1'b0;
        end

        // Handle state-specific logic
        case (state)
            INIT: begin
                // Initialization state
                wr_ack <= 1'b0;
                rd_ack <= 1'b0;
                wr_err <= 1'b0;
                rd_err <= 1'b0;
                empty <= 1'b1; // Initial data count is 0, so FIFO is empty
            end

            WRITE: begin
                wr_ack <= 1'b1;  // Write acknowledge
            end

            WR_ERR: begin
                wr_err <= 1'b1;  // Write error
            end

            READ: begin
                rd_ack <= 1'b1;  // Read acknowledge
            end

            RD_ERR: begin
                rd_err <= 1'b1;  // Read error
            end

            NO_OP: begin
                // No operation, default outputs are already set to 0
            end

            default: begin
                wr_ack <= 1'bx;
                rd_ack <= 1'bx;
                wr_err <= 1'bx;
                rd_err <= 1'bx;
                full <= 1'bx;
                empty <= 1'bx;
            end
        endcase
    end
endmodule
