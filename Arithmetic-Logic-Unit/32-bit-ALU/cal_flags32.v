module cal_flags32(op, result, co_add, co_prev_add, co_sub, co_prev_sub, c, n, z, v);
// module for calculating flags c, n, z, v
    input [2:0] op; // input 3 bit opcode
    input [31:0] result; // input 32 bit result
    input co_add, co_prev_add, co_sub, co_prev_sub; 
    // input 1 bit co_add, co_sub (MSB carry out), co_prev_add, co_prev_sub (previous MSB carry out)
    output c, n, z, v; // c (carry out), n (negative), z (zero), v (over flow)
    
    assign c = (op[2:1] != 2'b11) ? 1'b0 : ((op[0] == 1'b0) ? co_add : co_sub); 
    // op == 110 -> add, op == 111 -> sub
    assign n = result[31]; // (result[31] == 1'b1) ? 1 : 0 ;
    // MSB == 1 negative, MSB == 0 positive
    assign z = (result == 32'h00000000) ? 1'b1 : 1'b0; // result == 0 -> z = 1, result != 0 -> z = 0;
    assign v = (op[2:1] != 2'b11) ? 1'b0 : ((op[0] == 1'b0) ? (co_add ^ co_prev_add) : (co_sub ^ co_prev_sub)); 
    // op == 111 -> sub MSB co ^ previous MSB co
    // op == 110 -> add MSB co ^ previous MSB co

endmodule