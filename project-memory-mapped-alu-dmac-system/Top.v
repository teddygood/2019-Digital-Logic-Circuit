module Top(
    clk,
    reset_n,
    m0_req,
    m0_wr,
    m0_addr,
    m0_dout,
    m0_grant,
    a_interrupt,
    d_interrupt,
    m_din
);
    input clk, reset_n, m0_req, m0_wr;
    input [15:0] m0_addr;
    input [31:0] m0_dout;
    output m0_grant, a_interrupt, d_interrupt;
    output [31:0] m_din;

    wire s0_sel, s1_sel, s2_sel, s3_sel, s4_sel;
    wire [15:0] s_addr;
    wire s_wr;
    wire [31:0] s_din;

    wire [31:0] s0_dout, s1_dout, s2_dout, s3_dout, s4_dout;

    wire m1_req, m1_wr, m1_grant;
    wire [15:0] m1_addr;
    wire [31:0] m1_dout;

    // The top module exposes one external bus master (m0) and lets the DMAC act as a second master (m1).
    ALU_Top alu_0(
        .clk(clk),
        .reset_n(reset_n),
        .s_sel(s1_sel),
        .s_wr(s_wr),
        .s_addr(s_addr),
        .s_din(s_din),
        .s_dout(s1_dout),
        .s_interrupt(a_interrupt)
    );

    DMAC_Top dmac_0(
        .clk(clk),
        .reset_n(reset_n),
        .m_grant(m1_grant),
        .m_din(m_din),
        .s_sel(s0_sel),
        .s_wr(s_wr),
        .s_addr(s_addr),
        .s_din(s_din),
        .m_req(m1_req),
        .m_wr(m1_wr),
        .m_addr(m1_addr),
        .m_dout(m1_dout),
        .s_dout(s0_dout),
        .s_interrupt(d_interrupt)
    );

    ram operand_ram(
        .clk(clk),
        .cen(s2_sel),
        .wen(s_wr),
        .addr(s_addr),
        .din(s_din),
        .dout(s2_dout)
    );

    ram instruction_ram(
        .clk(clk),
        .cen(s3_sel),
        .wen(s_wr),
        .addr(s_addr),
        .din(s_din),
        .dout(s3_dout)
    );

    ram result_ram(
        .clk(clk),
        .cen(s4_sel),
        .wen(s_wr),
        .addr(s_addr),
        .din(s_din),
        .dout(s4_dout)
    );

    // BUS arbitrates between the host and DMAC, then decodes the shared address into slave selects.
    BUS bus_0(
        .clk(clk),
        .reset_n(reset_n),
        .m0_req(m0_req),
        .m0_wr(m0_wr),
        .m0_addr(m0_addr),
        .m0_dout(m0_dout),
        .m1_req(m1_req),
        .m1_wr(m1_wr),
        .m1_addr(m1_addr),
        .m1_dout(m1_dout),
        .s0_dout(s0_dout),
        .s1_dout(s1_dout),
        .s2_dout(s2_dout),
        .s3_dout(s3_dout),
        .s4_dout(s4_dout),
        .m0_grant(m0_grant),
        .m1_grant(m1_grant),
        .m_din(m_din),
        .s0_sel(s0_sel),
        .s1_sel(s1_sel),
        .s2_sel(s2_sel),
        .s3_sel(s3_sel),
        .s4_sel(s4_sel),
        .s_addr(s_addr),
        .s_wr(s_wr),
        .s_din(s_din)
    );
endmodule
