`timescale 1ns/100ps // Setting the Time Unit of Simulation

module tb_alu32; // 32-bit alu testbench
    
    reg tb_clk, tb_reset; // clock, reset
    reg [100:0] vectornum, errors; 
    reg [103:0] testvectors[100:0]; // array of testvectors
    reg [31:0] exp_result; // expected result
    reg exp_c, exp_n, exp_z, exp_v; // expected flags
    
    reg [31:0] tb_a, tb_b; // testbench 32-bit input tb_a, tb_b
    reg [2:0] tb_op; // testbench 3-bit opcode tb_op
    reg dummy; // dummy-bit
    wire [31:0] tb_result; // output 32-bit tb_result
    wire tb_c, tb_n, tb_z, tb_v; // flags (carry, negative, zero, overflow)
    
    alu32 U0_alu32(.a(tb_a), .b(tb_b), .op(tb_op), .result(tb_result), .c(tb_c), .n(tb_n), .z(tb_z), .v(tb_v)); // instance 32-bit alu
    
    always begin
        tb_clk = 1; #5; tb_clk = 0; #5; // clock frequency 10
    end
    
    initial begin
        $readmemh("./../../example.tv", testvectors); // read testvectors file written in
        vectornum = 0; errors = 0; tb_reset = 1; #4; tb_reset = 0;
        // reset = 1 (0 ~ 4ns), reset = 0 (4ns ~ finish)
    end
    
    always @ (posedge tb_clk) begin // every positive edge
        #1; {tb_a, tb_b, dummy, tb_op, exp_result, exp_c, exp_n, exp_z, exp_v} = testvectors[vectornum]; // data is stored 
    end
    
    always @ (negedge tb_clk) begin // every negative edge
        if (~tb_reset) begin // skip during reset
            if (tb_result !== exp_result || tb_c !== exp_c || tb_n !== exp_n || tb_z !== exp_z || tb_v !== exp_v) begin // The original value is different from the expected value
                $display("Error: inputs = a: %h, b: %h, op: %b", tb_a, tb_b, tb_op);
                $display("outputs = result: %h, c: %b, n: %b, z: %b, v: %b (%h %b %b %b %b expected)", tb_result, tb_c, tb_n, tb_z, tb_v, exp_result, exp_c, exp_n, exp_z, exp_v);
                errors = errors + 1; // count error
            end
            vectornum = vectornum + 1; // count vectornum
            if (testvectors[vectornum] === 104'hx) begin // {opcode, tb_a, tb_b, tb_result, flags} === unknown
                $display("%d tests completed with %d errors", vectornum, errors); 
                $finish;
            end
        end
    end
endmodule