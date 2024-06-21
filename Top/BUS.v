module BUS(clk, reset_n, m0_req, m0_wr, m0_addr, m0_dout, m1_req, m1_wr, m1_addr, m1_dout, s0_dout, s1_dout, s2_dout, s3_dout, s4_dout, m0_grant, m1_grant, m_din, s0_sel, s1_sel, s2_sel, s3_sel, s4_sel, s_addr, s_wr, s_din);
	input clk, reset_n, m0_req, m0_wr, m1_req, m1_wr;
	input[15:0] m0_addr, m1_addr;
	input[31:0] m0_dout, m1_dout, s0_dout, s1_dout, s2_dout, s3_dout, s4_dout;
	output m0_grant, m1_grant;
	output[31:0] m_din, s_din;
	output s0_sel, s1_sel, s2_sel, s3_sel, s4_sel;
	output[15:0] s_addr;
	output s_wr;
	wire [4:0] dec_out;
	wire [4:0] to_Q;
	wire [2:0] d, q;
	
	bus_arbit bus_arbit(clk, reset_n, m0_req, m1_req, m0_grant, m1_grant);
	
	mux2_1bit mux2_1bit(m0_wr, m1_wr, m1_grant, s_wr); //wr = granted master's wr
	mux2_16bit mux2_16bit(m0_addr, m1_addr, m1_grant, s_addr); //address = granted master's address
	mux2_32bit mux2_32bit(m0_dout, m1_dout, m1_grant, s_din); //din = granted master's dout
	bus_addr bus_addr_dec(s_addr, {s0_sel, s1_sel, s2_sel, s3_sel, s4_sel});
	
	// assign dec_out = {s0_sel, s1_sel, s2_sel, s3_sel, s4_sel};
	
	bus_enc bus_enc({s0_sel, s1_sel, s2_sel, s3_sel, s4_sel}, d);
	// dff_r	dff_r(.clk(clk), .reset_n(reset_n), .d(dec_out), .q(to_Q));
	dff_r	dff_r(.clk(clk), .reset_n(reset_n), .d(d), .q(q));

	// maybe_mux maybe_mux(.d0(s0_dout), .d1(s1_dout), .d2(s2_dout), .d3(s3_dout), .d4(s4_dout), .s(to_Q), .y(m_din));
	mux6_32bit mux6_32bit(.d0(s0_dout), .d1(s1_dout), .d2(s2_dout), .d3(s3_dout), .d4(s4_dout), .s(q), .y(m_din));

endmodule 
