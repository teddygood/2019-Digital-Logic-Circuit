module BUS(
    clk,
    reset_n,
    m0_req,
    m0_wr,
    m0_addr,
    m0_dout,
    m1_req,
    m1_wr,
    m1_addr,
    m1_dout,
    s0_dout,
    s1_dout,
    s2_dout,
    s3_dout,
    s4_dout,
    m0_grant,
    m1_grant,
    m_din,
    s0_sel,
    s1_sel,
    s2_sel,
    s3_sel,
    s4_sel,
    s_addr,
    s_wr,
    s_din
);
    input clk, reset_n, m0_req, m0_wr, m1_req, m1_wr;
    input [15:0] m0_addr, m1_addr;
    input [31:0] m0_dout, m1_dout, s0_dout, s1_dout, s2_dout, s3_dout, s4_dout;
    output m0_grant, m1_grant;
    output reg [31:0] m_din;
    output reg s0_sel, s1_sel, s2_sel, s3_sel, s4_sel;
    output reg [15:0] s_addr;
    output reg s_wr;
    output reg [31:0] s_din;

    wire [4:0] decoded_sel;
    reg active_m0, active_m1;

    bus_arbiter arbiter_0(
        .clk(clk),
        .reset_n(reset_n),
        .m0_req(m0_req),
        .m1_req(m1_req),
        .m0_grant(m0_grant),
        .m1_grant(m1_grant)
    );

    bus_addressdecoder decoder_0(
        .address(s_addr),
        .sel(decoded_sel)
    );

    always @(*) begin
        active_m0 = m0_req & m0_grant;
        active_m1 = m1_req & m1_grant;

        // When the DMAC wins arbitration it drives the shared slave bus; otherwise the host master does.
        if (active_m1) begin
            s_addr = m1_addr;
            s_wr = m1_wr;
            s_din = m1_dout;
        end else if (active_m0) begin
            s_addr = m0_addr;
            s_wr = m0_wr;
            s_din = m0_dout;
        end else begin
            s_addr = 16'h0000;
            s_wr = 1'b0;
            s_din = 32'h0000_0000;
        end
    end

    always @(*) begin
        if (active_m0 | active_m1) begin
            // Only one decoded slave is visible at a time because the upper address byte selects the target block.
            {s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} = decoded_sel;
        end else begin
            {s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} = 5'b00000;
        end
    end

    always @(*) begin
        // Read data is simply multiplexed back from the selected slave.
        case ({s0_sel, s1_sel, s2_sel, s3_sel, s4_sel})
            5'b10000: m_din = s0_dout;
            5'b01000: m_din = s1_dout;
            5'b00100: m_din = s2_dout;
            5'b00010: m_din = s3_dout;
            5'b00001: m_din = s4_dout;
            default: m_din = 32'h0000_0000;
        endcase
    end
endmodule
