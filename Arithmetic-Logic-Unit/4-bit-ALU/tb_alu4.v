`timescale 1ns/100ps            // Setting the Time Unit of Simulation
module tb_alu4;                 // 4-bit alu testbench
    reg [3:0] tb_a, tb_b;       // testbench 4-bit input tb_a, tb_b
    reg [2:0] tb_op;            // testbench 3-bit opcode tb_op
    wire [3:0] tb_result;       // testbench 4-bit output tb_result
    wire tb_c, tb_n, tb_z, tb_v; // flags (carry, negative, zero, overflow)

    // instance 4-bit Arithmetic Logic Unit (ALU)
    alu4 U0_alu4(
        .a(tb_a), 
        .b(tb_b), 
        .op(tb_op), 
        .result(tb_result),
        .c(tb_c), 
        .n(tb_n), 
        .z(tb_z), 
        .v(tb_v)
    );

    initial begin
        tb_a = 4'b0000; tb_b = 4'b0000; tb_op = 3'b000; #10;
        if (tb_result !== 4'b1111) $display("000 failed"); // NOT A
        
        tb_a = 4'b0000; tb_b = 4'b0000; tb_op = 3'b001; #10;
        if (tb_result !== 4'b1111) $display("001 failed"); // NOT B
        
        tb_a = 4'b0101; tb_b = 4'b1010; tb_op = 3'b010; #10;
        if (tb_result !== 4'b0000) $display("010 failed"); // AND
        
        tb_a = 4'b1101; tb_b = 4'b0011; tb_op = 3'b011; #10;
        if (tb_result !== 4'b1111) $display("011 failed"); // OR
        
        tb_a = 4'b0101; tb_b = 4'b0011; tb_op = 3'b100; #10;
        if (tb_result !== 4'b0110) $display("100 failed"); // XOR
        
        tb_a = 4'b0101; tb_b = 4'b0011; tb_op = 3'b101; #10;
        if (tb_result !== 4'b1001) $display("101 failed"); // XNOR
    
        tb_a = 4'b0101; tb_b = 4'b0011; tb_op = 3'b110; #10;
        if (tb_result !== 4'b1000) $display("110 failed"); // ADD
        
        tb_a = 4'b0101; tb_b = 4'b0010; tb_op = 3'b111; #10;
        if (tb_result !== 4'b0011) $display("111 failed"); // SUB
        
        $stop; // stop
    end
endmodule