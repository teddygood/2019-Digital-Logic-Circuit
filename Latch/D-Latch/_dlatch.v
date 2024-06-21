module _dlatch(clk, d, q, q_bar);		// D latch
    input clk, d;
    output q, q_bar;
    wire d_bar, r, s;

    _inv U0_inv(.a(d), .y(d_bar)); // instance inverter
    _and2 U1_and2(.a(clk), .b(d_bar), .y(r)); // instance AND gate
    _and2 U2_and2(.a(clk), .b(d), .y(s));		// instance AND gate
    _srlatch U3_srlatch(.r(r), .s(s), .q(q), .q_bar(q_bar)); // instance SR latch
endmodule
