module fifo(
    input clk, reset_n, rd_en, wr_en,      // Clock, reset, read enable, write enable
    input [31:0] d_in,                     // Data input
    output [31:0] d_out,                   // Data output
    output full, empty,                    // Full, empty signals
    output wr_ack, wr_err, rd_ack, rd_err, // Write/read acknowledge and error signals
    output [3:0] data_count                // Data count
);

    // Internal signals
    wire [2:0] head, next_head;
    wire [2:0] tail, next_tail;
    wire [2:0] state, next_state;
    wire [3:0] next_data_count;
    wire we, re;
    wire [31:0] to_mux, to_ff;

    // Instance: Register File (Stores FIFO data)
    Register_file U0_Register_file(
        .clk(clk), 
        .reset_n(reset_n), 
        .wAddr(tail), 
        .wData(d_in), 
        .we(we), 
        .rAddr(head), 
        .rData(to_mux)
    );

    // Instance: Next State Logic
    fifo_ns U1_fifo_ns(
        .wr_en(wr_en), 
        .rd_en(rd_en), 
        .data_count(data_count), 
        .state(state), 
        .next_state(next_state)
    );

    // Instance: Address Calculation Logic
    fifo_cal U2_fifo_cal(
        .state(next_state), 
        .head(head), 
        .tail(tail), 
        .data_count(data_count), 
        .we(we), 
        .re(re), 
        .next_head(next_head), 
        .next_tail(next_tail), 
        .next_data_count(next_data_count)
    );

    // Instance: Output Logic
    fifo_out U3_fifo_out(
        .state(state), 
        .data_count(data_count), 
        .full(full), 
        .empty(empty), 
        .wr_ack(wr_ack), 
        .wr_err(wr_err), 
        .rd_ack(rd_ack), 
        .rd_err(rd_err)
    );

    // Instance: State Register (Stores current state)
    register3_r_en U4_state(
        .clk(clk), 
        .reset_n(reset_n), 
        .d_in(next_state), 
        .d_out(state), 
        .en(1'b1)
    );

    // Instance: Head Pointer Register
    register3_r_en U5_head(
        .clk(clk), 
        .reset_n(reset_n), 
        .d_in(next_head), 
        .d_out(head), 
        .en(1'b1)
    );

    // Instance: Tail Pointer Register
    register3_r_en U6_tail(
        .clk(clk), 
        .reset_n(reset_n), 
        .d_in(next_tail), 
        .d_out(tail), 
        .en(1'b1)
    );

    // Instance: Data Count Register
    register4_r_en U7_data_count(
        .clk(clk), 
        .reset_n(reset_n), 
        .d_in(next_data_count), 
        .d_out(data_count), 
        .en(1'b1)
    );

    // Instance: Data Out Register
    register32_r_en U8_data_out(
        .clk(clk), 
        .reset_n(reset_n), 
        .d_in(to_ff), 
        .d_out(d_out), 
        .en(1'b1)
    );

    // Instance: 2-to-1 Multiplexer for Data Output
    mx2 U9_mux2(
        .a(32'b0), 
        .b(to_mux), 
        .sel(re), 
        .d_out(to_ff)
    );

endmodule
