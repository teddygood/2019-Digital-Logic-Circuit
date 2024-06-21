module mx8_32bits(a, b, c, d, e, f, g, h, s2, s1, s0, y); // 32-bit 8-to-1 Multiplexer
    input [31:0] a, b, c, d, e, f, g, h;
    input s2, s1, s0; // selection signal
    output [31:0] y;

    wire [31:0] w0, w1, w2, w3, w4, w5;
    
    // step 1
    mx2_32bits I0_mx2_32bits(.d0(a), .d1(b), .s(s0), .y(w0)); // instance 32-bit 2-to-1 Multiplexer
    mx2_32bits I1_mx2_32bits(.d0(c), .d1(d), .s(s0), .y(w1)); 
    mx2_32bits I2_mx2_32bits(.d0(e), .d1(f), .s(s0), .y(w2)); 
    mx2_32bits I3_mx2_32bits(.d0(g), .d1(h), .s(s0), .y(w3)); 
    
    // step 2
    mx2_32bits I4_mx2_32bits(.d0(w0), .d1(w1), .s(s1), .y(w4)); 
    mx2_32bits I5_mx2_32bits(.d0(w2), .d1(w3), .s(s1), .y(w5)); 
    
    // step 3
    mx2_32bits I6_mx2_32bits(.d0(w4), .d1(w5), .s(s2), .y(y)); 

endmodule