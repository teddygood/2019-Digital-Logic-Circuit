module alu4(a, b, op, result, c, n, z, v); // 4-bit Arithmetic Logic Unit (ALU)
    input [3:0] a, b; // input 4-bit a, b
    input [2:0] op; // input 3-bit opcode
    output [3:0] result; // output 4-bit result
    output c, n, z, v; // flags c, n, z, v (carry out, negative, zero, overflow)
    
    wire [3:0] w_not_a, w_not_b, w_and, w_or, w_xor, w_xnor, w_add, w_sub; // input 4-bit 8-to-1 mux
    wire c3_add, co_add, c3_sub, co_sub; // wire for calculating overflow or carry out                

    _inv_4bits U0_inv_4bits(.a(a), .y(w_not_a)); // instance 4-bit inverter 
    _inv_4bits U1_inv_4bits(.a(b), .y(w_not_b)); // instance 4-bit inverter
    _and2_4bits U2_and2_4bits(.a(a), .b(b), .y(w_and)); // instance 4-bit 2-to-1 and gate
    _or2_4bits U3_or2_4bits(.a(a), .b(b), .y(w_or)); // instance 4-bit 2-to-1 or gate
    _xor2_4bits U4_xor2_4bits(.a(a), .b(b), .y(w_xor)); // instance 4-bit 2-to-1 xor gate
    _xnor2_4bits U5_xnor2_4bits(.a(a), .b(b), .y(w_xnor)); // instance 4-bit 2-to-1 xnor gate
    cla4_ov U6_add(.a(a), .b(b), .ci(1'b0), .s(w_add), .c3(c3_add), .co(co_add)); // instance 4-bit adder using cla4_ov
    cla4_ov U7_sub(.a(a), .b(w_not_b), .ci(1'b1), .s(w_sub), .c3(c3_sub), .co(co_sub)); // instance 4-bit subtractor using cla4_ov 
    mx8_4bits U8_mx8_4bits(.a(w_not_a), .b(w_not_b), .c(w_and), .d(w_or), .e(w_xor), .f(w_xnor),
                           .g(w_add), .h(w_sub), .s2(op[2]), .s1(op[1]), .s0(op[0]), .y(result));
    // instance 32-bit 8-to-1 Multiplexer
    cal_flags4 U9_cal_flags4(.op(op), .result(result), .co_add(co_add), .c3_add(c3_add),
                             .co_sub(co_sub), .c3_sub(c3_sub), .c(c), .n(n), .z(z), .v(v));
    // instance module for calculating flags c, n, z, v
endmodule