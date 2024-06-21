module alu32(a, b, op, result, c, n, z, v); // 32-bit Arithmetic Logic Unit (ALU)
    input [31:0] a, b;
    input [2:0] op; // input 3-bit opcode 
    output [31:0] result; // output 32-bit result
    output c, n, z, v; // flags c, n, z, v (carry out, negative, zero, overflow)

    wire [31:0] w_not_a, w_not_b, w_and, w_or, w_xor, w_xnor, w_add, w_sub; // input 32-bit 8-to-1 mux
    wire co_prev_add, co_prev_sub, co_add, co_sub; // wire for calculating overflow or carry out

    _inv_32bits U0_inv_32bits(.a(a), .y(w_not_a)); // instance 32-bit inverter 
    _inv_32bits U1_inv_32bits(.a(b), .y(w_not_b)); // instance 32-bit inverter 
    _and2_32bits U2_and2_32bits(.a(a), .b(b), .y(w_and)); // instance 32-bit 2-to-1 and gate
    _or2_32bits U3_or2_32bits(.a(a), .b(b), .y(w_or)); // instance 32-bit 2-to-1 or gate
    _xor2_32bits U4_xor2_32bits(.a(a), .b(b), .y(w_xor)); // instance 32-bit 2-to-1 xor gate
    _xnor2_32bits U5_xnor2_32bits(.a(a), .b(b), .y(w_xnor)); // instance 32-bit 2-to-1 xnor gate
    cla32_ov U6_add(.a(a), .b(b), .ci(1'b0), .s(w_add), .co_prev(co_prev_add), .co(co_add)); // instance 32-bit adder using cla4_ov
    cla32_ov U7_sub(.a(a), .b(w_not_b), .ci(1'b1), .s(w_sub), .co_prev(co_prev_sub), .co(co_sub)); // instance 32-bit subtractor using cla4_ov 
    mx8_32bits U8_mx8_32bits(.a(w_not_a), .b(w_not_b), .c(w_and), .d(w_or), .e(w_xor), .f(w_xnor),
                             .g(w_add), .h(w_sub), .s2(op[2]), .s1(op[1]), .s0(op[0]), .y(result)); 
    // instance 32-bit 8-to-1 Multiplexer

    cal_flags32 U9_cal_flags32(.op(op), .result(result), .co_add(co_add), .co_prev_add(co_prev_add),
                               .co_sub(co_sub), .co_prev_sub(co_prev_sub), .c(c), .n(n), .z(z), .v(v)); 
    // instance module for calculating flags c, n, z, v

endmodule