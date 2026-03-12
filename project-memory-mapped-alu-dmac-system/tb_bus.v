`timescale 1ns/100ps

module tb_bus;
    reg clk, reset_n, m0_req, m0_wr, m1_req, m1_wr;
    reg [15:0] m0_addr, m1_addr;
    reg [31:0] m0_dout, m1_dout, s0_dout, s1_dout, s2_dout, s3_dout, s4_dout;

    wire m0_grant, m1_grant;
    wire [31:0] m_din;
    wire s0_sel, s1_sel, s2_sel, s3_sel, s4_sel;
    wire [15:0] s_addr;
    wire s_wr;
    wire [31:0] s_din;

    BUS dut(
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

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        m0_req = 1'b0;
        m0_wr = 1'b0;
        m1_req = 1'b0;
        m1_wr = 1'b0;
        m0_addr = 16'h0000;
        m1_addr = 16'h0000;
        m0_dout = 32'h0000_0000;
        m1_dout = 32'h0000_0000;
        s0_dout = 32'h0000_0001;
        s1_dout = 32'h0000_0300;
        s2_dout = 32'h0005_0000;
        s3_dout = 32'h0700_0000;
        s4_dout = 32'h0000_0011;

        #2 reset_n = 1'b0;
        #12 reset_n = 1'b1;

        @(negedge clk);
        m0_req = 1'b1;
        m0_wr = 1'b0;
        m0_addr = 16'h0000;
        @(posedge clk);
        $display("BUS m0 read s0 -> %h", m_din);

        @(negedge clk);
        m0_wr = 1'b1;
        m0_dout = 32'h0000_0020;
        @(posedge clk);
        $display("BUS m0 write addr=%h sel=%b%b%b%b%b din=%h", s_addr, s0_sel, s1_sel, s2_sel, s3_sel, s4_sel, s_din);

        @(negedge clk);
        m0_req = 1'b0;
        m0_wr = 1'b0;
        m1_req = 1'b1;
        m1_wr = 1'b0;
        m1_addr = 16'h0100;
        @(posedge clk);
        $display("BUS m1 read s1 -> %h", m_din);

        @(negedge clk);
        m1_wr = 1'b1;
        m1_dout = 32'h0000_4000;
        @(posedge clk);
        $display("BUS m1 write addr=%h sel=%b%b%b%b%b din=%h", s_addr, s0_sel, s1_sel, s2_sel, s3_sel, s4_sel, s_din);

        @(negedge clk);
        m1_req = 1'b0;
        m1_wr = 1'b0;

        #40;
        $finish;
    end
endmodule
