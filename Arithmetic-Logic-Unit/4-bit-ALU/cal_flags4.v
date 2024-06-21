module cal_flags4(op, result, co_add, c3_add, co_sub, c3_sub, c, n, z, v);
// module for calculating flags c, n, z, v
    input [2:0] op; // input 3 bit opcode
    input [3:0] result; // input 4 bit result
    input co_add, c3_add, co_sub, c3_sub; // input 1 bit co_add, co_sub (MSB carry out), c3_add, c3_sub (previous MSB carry out)
    output c, n, z, v; // c (carry out), n (negative), z (zero), v (over flow)

    assign c = (op[2:1] != 2'b11) ? 1'b0 : ((op[0] == 1'b0) ? co_add : co_sub);
    // op == 110 -> add, op == 111 -> sub
    assign n = result[3]; // (result[3] == 1'b1) ? 1 : 0 ;
    // MSB = 1 negative, MSB == 0 positive
    assign z = (result == 4'b0) ? 1'b1 : 1'b0; // result == 0 -> z = 1, result != 0 -> z = 0;
    assign v = (op[2:1] != 2'b11) ? 1'b0 : ((op[0] == 1'b0) ? (co_add ^ c3_add) : (co_sub ^ c3_sub));
    // op == 111 -> sub MSB co ^ previous MSB co
    // op == 110 -> add MSB co ^ previous MSB co

endmodule