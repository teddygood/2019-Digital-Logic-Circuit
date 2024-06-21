module cla4_ov(a, b, ci, s, c3, co); // 4-bit CLA to detect overflow
    input [3:0] a, b; // 4-bit input a, b
    input ci; // 1-bit input carry in
    output [3:0] s; // 4-bit output sum
    output c3, co; // 1-bit output c3 (previous MSB carry out), co (MSB carry out) 

    wire c1, c2;

    fa_v2 U0_fa(.a(a[0]), .b(b[0]), .ci(ci), .s(s[0])); // instance half adder without carry out
    fa_v2 U1_fa(.a(a[1]), .b(b[1]), .ci(c1), .s(s[1]));
    fa_v2 U2_fa(.a(a[2]), .b(b[2]), .ci(c2), .s(s[2]));
    fa_v2 U3_fa(.a(a[3]), .b(b[3]), .ci(c3), .s(s[3]));
    clb4 U4_clb4(.a(a), .b(b), .ci(ci), .c1(c1), .c2(c2), .c3(c3), .co(co)); // instance 4-bit Carry Look-ahead Block

endmodule