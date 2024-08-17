// FIFO Address Calculation Module
module fifo_cal(
    input [2:0] state, head, tail, // current state, head pointer, tail pointer
    input [3:0] data_count,        // the number of data in FIFO
    output reg we, re,             // write/read enable
    output reg [2:0] next_head, next_tail, // next head/tail pointer
    output reg [3:0] next_data_count // the next number of data in FIFO
);

    // State binary encoding
    parameter INIT = 3'b000;
    parameter WRITE = 3'b001;
    parameter WR_ERR = 3'b010;
    parameter NO_OP = 3'b011;
    parameter READ = 3'b100;
    parameter RD_ERR = 3'b101;

    // FIFO size parameter
    parameter FIFO_SIZE = 4'b1000;  // Max capacity of FIFO

    // Sequential logic based on current state
    always @(state, head, tail, data_count) begin
        case(state)
            INIT: // Initialization state
            begin
                we <= 1'b0;
                re <= 1'b0;
                next_head <= head;
                next_tail <= 3'b000;
                next_data_count <= 4'b0000;
            end

            WRITE: // Write state
            begin
                if (data_count < FIFO_SIZE) begin
                    we <= 1'b1; // Enable write
                    re <= 1'b0;
                    next_head <= head;
                    next_tail <= tail + 3'b001; // Increment tail
                    next_data_count <= data_count + 4'b0001; // Increment data count
                end else begin
                    we <= 1'b0;
                    re <= 1'b0;
                    next_head <= head;
                    next_tail <= tail;
                    next_data_count <= data_count;
                end
            end

            WR_ERR: // Write error state
            begin
                we <= 1'b0;
                re <= 1'b0;
                next_head <= head;
                next_tail <= tail;
                next_data_count <= data_count;
            end

            READ: // Read state
            begin
                if (data_count > 4'b0000) begin
                    we <= 1'b0;
                    re <= 1'b1; // Enable read
                    next_head <= head + 3'b001; // Increment head
                    next_tail <= tail;
                    next_data_count <= data_count - 4'b0001; // Decrement data count
                end else begin
                    we <= 1'b0;
                    re <= 1'b0;
                    next_head <= head;
                    next_tail <= tail;
                    next_data_count <= data_count;
                end
            end

            RD_ERR: // Read error state
            begin
                we <= 1'b0;
                re <= 1'b0;
                next_head <= head;
                next_tail <= tail;
                next_data_count <= data_count;
            end

            NO_OP: // No operation state
            begin
                we <= 1'b0;
                re <= 1'b0;
                next_head <= head;
                next_tail <= tail;
                next_data_count <= data_count;
            end

            default: // Default case for safety
            begin
                we <= 1'bx;
                re <= 1'bx;
                next_head <= 3'bx;
                next_tail <= 3'bx;
                next_data_count <= 4'bx;
            end
        endcase
    end
endmodule
