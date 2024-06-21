module bus(
    clk, reset_n, m0_req, m0_wr, m0_address, m0_dout,
    m1_req, m1_wr, m1_address, m1_dout, s0_dout, s1_dout,
    m0_grant, m1_grant, m_din, s0_sel, s1_sel, s_address, s_wr, s_din
);
// bus top module

    input clk, reset_n, m0_req, m0_wr, m1_req, m1_wr;
    input [7:0] m0_address, m1_address;
    input [31:0] m0_dout, m1_dout, s0_dout, s1_dout;
    output m0_grant, m1_grant, s0_sel, s1_sel, s_wr;
    output [7:0] s_address;
    output [31:0] m_din, s_din;

    wire [1:0] arbit_out, addr_dec_out;
    wire [7:0] address_wire;

    reg [1:0] to_mux3; // to synchronize the clock

    // instance arbiter module
    bus_arbit U0_arbiter(
        .m0_req(m0_req), .m1_req(m1_req), .reset_n(reset_n), .clk(clk), .state(arbit_out)
    );
    assign m0_grant = arbit_out[0];
    assign m1_grant = arbit_out[1];

    // instance multiplexer module
    mux2 U1_mux2_1bit(
        .d0(m0_wr), .d1(m1_wr), .s(arbit_out[1]), .y(s_wr)
    );
    mux2_8bit U2_mux2_8bit(
        .d0(m0_address), .d1(m1_address), .s(arbit_out[1]), .y(address_wire)
    );
    assign s_address = address_wire;
    mux2_32bit U3_mux2_32bit(
        .d0(m0_dout), .d1(m1_dout), .s(arbit_out[1]), .y(s_din)
    );

    // instance address decoder module
    bus_addr U4_address_dec(
        .s_address(address_wire), .s0_sel(s0_sel), .s1_sel(s1_sel)
    );
    assign addr_dec_out = {s0_sel, s1_sel};
    
    always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0)
            to_mux3 <= 2'b00;
        else    
            to_mux3 <= addr_dec_out;
    end

    mux3_32bit U5_mux3_32bit(
        .d0(s0_dout), .d1(s1_dout), .s(to_mux3), .y(m_din)
    );

endmodule