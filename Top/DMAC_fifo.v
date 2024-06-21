module DMAC_fifo(clk, reset_n,rd_en,wr_en,in_sourceaddr, in_datasize, in_desaddr, data_count,out_sourceaddr, out_datasize, out_desaddr, full,empty,wr_ack,wr_err,rd_ack,rd_err); // Top module
// input value 
input clk, reset_n, rd_en, wr_en;
input [15:0] in_sourceaddr, in_datasize, in_desaddr;
// output value 
output [15:0] out_sourceaddr, out_datasize, out_desaddr;
output full, empty;
output wr_ack, wr_err, rd_ack, rd_err;
output [4:0] data_count;

// inner wire 
wire [3:0] head, next_head;
wire [3:0] tail, next_tail;
wire [2:0] state, next_state;
wire [4:0] next_data_count;
wire we, re;
wire [31:0] to_mux1, to_mux2, to_mux3, to_ff1, to_ff2, to_ff3;



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
DMAC_Register_file U7_DMAC_register(clk, reset_n, tail, in_sourceaddr, we, head, to_mux1); // sourceaddr
DMAC_Register_file U8_DMAC_register(clk, reset_n, tail, in_desaddr, we, head, to_mux2);	//	desaddr
DMAC_Register_file U9_DMAC_register(clk, reset_n, tail, in_datasize, we, head, to_mux3);	//	datasize
// instance 2_to_1 mux module(choose print 0 or output value )
mx2 U10_mux(to_mux1, re, to_ff1);
mx2 U11_mux(to_mux2, re, to_ff2);
mx2 U12_mux(to_mux3, re, to_ff3);
// instance 32bit register module(synchronizing at clock)
register16_r_en U13_dff(clk, reset_n, to_ff1, out_sourceaddr, 1'b1);	// sourceaddr
register16_r_en U14_dff(clk, reset_n, to_ff2, out_desaddr, 1'b1);	// desaddr
register16_r_en U15_dff(clk, reset_n, to_ff3, out_datasize, 1'b1);	// datasize
endmodule

