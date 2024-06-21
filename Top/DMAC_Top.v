module DMAC_Top(clk, reset_n, m_grant, m_din, s_sel, s_wr, s_addr, s_din, m_req, m_wr, m_addr, m_dout, s_dout, s_interrupt); // DMAC TOP
// input value
input clk, reset_n, m_grant, s_sel, s_wr;
input [31:0] m_din, s_din;
input [15:0] s_addr;

// output value
output  m_req, m_wr, s_interrupt;
output [15:0] m_addr;
output [31:0] m_dout, s_dout;

// inner wire
wire wr_en_to_ff, rd_en_to_ff;
wire op_done_from_master;
wire op_start_to_master, op_done_clear_to_master;
wire [15:0] source_addr_to_ff, dest_addr_to_ff, data_size_to_ff;
wire [15:0] source_addr_to_master, dest_addr_to_master, data_size_to_master;
wire [1:0] opmode_to_master;
wire [3:0] datacount_to_master;
wire empty, full;


// instance sub modules
DMAC_slave U0_dmac_slave(.clk(clk), .reset_n(reset_n), .s_sel(s_sel), .s_wr(s_wr), .op_done(op_done_from_master),
 .s_addr(s_addr), .s_din(s_din), .source_addr(source_addr_to_ff), .dest_addr(dest_addr_to_ff), .data_size(data_size_to_ff),
 .s_interrupt(s_interrupt), .op_start(op_start_to_master), .op_clear(op_done_clear_to_master), .wr_en(wr_en_to_ff), .s_dout(s_dout), 
 .op_mode(opmode_to_master), .empty(empty), .full(full));

 
DMAC_fifo U1_dmac_fifo(.clk(clk), .reset_n(reset_n), .rd_en(rd_en_to_ff), .wr_en(wr_en_to_ff), .in_sourceaddr(source_addr_to_ff), 
  .in_datasize(data_size_to_ff), .in_desaddr(dest_addr_to_ff), .data_count(datacount_to_master), .out_sourceaddr(source_addr_to_master), 
  .out_datasize(data_size_to_master), .out_desaddr(dest_addr_to_master), .empty(empty), .full(full));
  
  
DMAC_master U2_dmac_master(.clk(clk), .reset_n(reset_n), .op_start(op_start_to_master), .op_done(op_done_from_master), .op_clear(op_done_clear_to_master), 
 .source_addr(source_addr_to_master), .dest_addr(dest_addr_to_master), .data_size(data_size_to_master), .data_count(datacount_to_master), 
 .rd_en(rd_en_to_ff), .m_req(m_req), .m_grant(m_grant), .m_wr(m_wr), .m_addr(m_addr), .m_dout(m_dout), .m_din(m_din), .op_mode(opmode_to_master));

 endmodule
