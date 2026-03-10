module DMAC_Top(
    clk,
    reset_n,
    m_grant,
    m_din,
    s_sel,
    s_wr,
    s_addr,
    s_din,
    m_req,
    m_wr,
    m_addr,
    m_dout,
    s_dout,
    s_interrupt
);
    input clk, reset_n, m_grant;
    input [31:0] m_din;
    input s_sel, s_wr;
    input [15:0] s_addr;
    input [31:0] s_din;
    output m_req, m_wr;
    output [15:0] m_addr;
    output [31:0] m_dout, s_dout;
    output s_interrupt;

    wire m_end, m_begin;
    wire empty, full;
    wire wr_ack, wr_err, rd_ack, rd_err;
    wire [4:0] data_count;
    wire push_1, push_2, push_3;
    wire [31:0] d_in1, d_in2, d_in3;
    wire [31:0] d_out1, d_out2, d_out3;
    wire pop_1, pop_2, pop_3;
    wire [3:0] state;

    // The slave front-end queues one descriptor as three FIFO streams: source, destination, and transfer size.
    DMAC_slave slave_if(
        .clk(clk),
        .reset_n(reset_n),
        .s_sel(s_sel),
        .s_wr(s_wr),
        .s_address(s_addr),
        .s_din(s_din),
        .m_end(m_end),
        .empty(empty),
        .full(full),
        .wr_ack(wr_ack),
        .wr_err(wr_err),
        .s_dout(s_dout),
        .s_interrupt(s_interrupt),
        .m_begin(m_begin),
        .push_1(push_1),
        .push_2(push_2),
        .push_3(push_3),
        .data_1(d_in1),
        .data_2(d_in2),
        .data_3(d_in3)
    );

    DMAC_fifo source_fifo(
        .clk(clk),
        .reset_n(reset_n),
        .rd_en(pop_1),
        .wr_en(push_1),
        .d_in(d_in1),
        .d_out(d_out1),
        .full(full),
        .empty(empty),
        .wr_ack(wr_ack),
        .wr_err(wr_err),
        .rd_ack(rd_ack),
        .rd_err(rd_err),
        .data_count(data_count)
    );

    DMAC_fifo destination_fifo(
        .clk(clk),
        .reset_n(reset_n),
        .rd_en(pop_2),
        .wr_en(push_2),
        .d_in(d_in2),
        .d_out(d_out2),
        .full(),
        .empty(),
        .wr_ack(),
        .wr_err(),
        .rd_ack(),
        .rd_err(),
        .data_count()
    );

    DMAC_fifo size_fifo(
        .clk(clk),
        .reset_n(reset_n),
        .rd_en(pop_3),
        .wr_en(push_3),
        .d_in(d_in3),
        .d_out(d_out3),
        .full(),
        .empty(),
        .wr_ack(),
        .wr_err(),
        .rd_ack(),
        .rd_err(),
        .data_count()
    );

    DMAC_master master_if(
        .clk(clk),
        .reset_n(reset_n),
        .m_grant(m_grant),
        .m_din(m_din),
        .m_begin(m_begin),
        .data1(d_out1),
        .data2(d_out2),
        .data3(d_out3),
        .empty(empty),
        .rd_ack(rd_ack),
        .rd_err(rd_err),
        .full(full),
        .m_req(m_req),
        .m_wr(m_wr),
        .m_address(m_addr),
        .m_dout(m_dout),
        .m_end(m_end),
        .pop_1(pop_1),
        .pop_2(pop_2),
        .pop_3(pop_3),
        .state(state),
        .m_din2()
    );
endmodule
