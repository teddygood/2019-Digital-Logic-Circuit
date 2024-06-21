module fifo(clk, reset_n,rd_en,wr_en,d_in,d_out,data_count,full,empty,wr_ack,wr_err,rd_ack,rd_err); //  fifo
input clk, reset_n, rd_en, wr_en; // clock, reset, read enable, write enable
input [31:0] d_in;	//o; data in
output [31:0] d_out;	//	data out
output full,empty;	// data full, empty signal
output wr_ack, wr_err, rd_ack, rd_err;
// write acknowledge, error, read acknowledge, error
output [3:0] data_count;

wire [2:0] head, next_head;
wire [2:0] tail, next_tail;
wire [2:0] state, next_state;
wire [3:0] next_data_count;
wire we,re;
wire [31:0] to_mux, to_ff;

// instance Register file 
Register_file U0_Register_file(.clk(clk), .reset_n(reset_n), .wAddr(tail), .wData(d_in), .we(we), .rAddr(head), .rData(to_mux));

// instance fifo next logic	
fifo_ns U1_fifo_ns(.wr_en(wr_en), .rd_en(rd_en), .data_count(data_count), .state(state), .next_state(next_state));

// instance fifo calculator	
fifo_cal U2_fifo_cal(.state(next_state), .head(head), .tail(tail), .data_count(data_count), .we(we), .re(re), .next_head(next_head), .next_tail(next_tail), .next_data_count(next_data_count));

// instance fifo result out	
fifo_out U3_fifo_out(.state(state), .data_count(data_count), .full(full), .empty(empty), .wr_ack(wr_ack), .wr_err(wr_err), .rd_ack(rd_ack), .rd_err(rd_err));

// instance state register	
register3_r_en U4_state(.clk(clk), .reset_n(reset_n), .d_in(next_state), .d_out(state), .en(1'b1));
	
// instance head pointer register
register3_r_en U5_head(.clk(clk), .reset_n(reset_n), .d_in(next_head), .d_out(head), .en(1'b1));

// instance tail pointer register	
register3_r_en U6_tail(.clk(clk), .reset_n(reset_n), .d_in(next_tail), .d_out(tail), .en(1'b1));

Register_file U7_register(clk, reset_n, tail, din, we, head, to_mux);

// instance 2-to-1 mux	
mx2 U8_mux2(.a(32'b0), .b(to_mux), .sel(re), .d_out(to_ff));

// instance data_out register	
register32_r_en U9_data_out(.clk(clk), .reset_n(reset_n), .d_in(to_ff), .d_out(d_out), .en(1'b1));


endmodule
