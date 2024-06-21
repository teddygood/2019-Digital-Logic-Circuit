module Result_fifo(clk, reset_n,rd_en,wr_en,d_in,d_out,data_count,full,empty,wr_ack,wr_err,rd_ack,rd_err); // Top module
// input value 
input clk, reset_n, rd_en, wr_en;
input [31:0] d_in;
// output value 
output [31:0] d_out;
output full, empty;
output wr_ack, wr_err, rd_ack, rd_err;
output [4:0] data_count;

// inner wire 
wire [3:0] head, next_head;
wire [3:0] tail, next_tail;
wire [2:0] state, next_state;
wire [4:0] next_data_count;
wire we, re;
wire [31:0] to_mux, to_ff;



// instance fifo_ns module
DMAC_fifo_ns U0_ns(wr_en, rd_en, state, data_count, next_state);
// instance fifo_cal_addr module
DMAC_fifo_cal U1_cal(next_state, head, tail, data_count, we, re, next_head, next_tail, next_data_count);
// instance fifo_out module
DMAC_fifo_out U2_out(state, data_count, full, empty, wr_ack, wr_err, rd_ack, rd_err);
// instance 4bit register module
register5_r_en U3_data_count(clk, reset_n, next_data_count, data_count, 1'b1);
// instance 3bit register module
register3_r_en U4_state(clk, reset_n, next_state, state, 1'b1);
register4_r_en U5_head(clk, reset_n, next_head, head, 1'b1);
register4_r_en U6_tail(clk, reset_n, next_tail, tail, 1'b1);
// instance Register_file module
DMAC_Register_file U7_DMAC_register(clk, reset_n, tail, d_in, we, head, to_mux); 
// instance 2_to_1 mux module(choose print 0 or output value )
mx2 U10_mux(to_mux, re, to_ff);
// instance 32bit register module(synchronizing at clock)
register32_r_en U13_dff(clk, reset_n, to_ff, d_out, 1'b1);	

endmodule

