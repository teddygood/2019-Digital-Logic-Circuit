`timescale 1ns/100ps

module tb_ALU_alu;
    reg clk, reset_n;
    reg [3:0] op_code;
    reg [1:0] shift;
    reg [31:0] operand_1, operand_2;
    reg op_start, op_clear;

    wire [31:0] result_2, result_1;
    wire op_done;

    ALU_alu dut(
        .clk(clk),
        .reset_n(reset_n),
        .op_code(op_code),
        .shift(shift),
        .operand_1(operand_1),
        .operand_2(operand_2),
        .op_start(op_start),
        .op_clear(op_clear),
        .result_2(result_2),
        .result_1(result_1),
        .op_done(op_done)
    );

    always #5 clk = ~clk;

    task start_operation;
        input [3:0] code;
        input [1:0] shift_value;
        input [31:0] op_a;
        input [31:0] op_b;
        begin
            @(negedge clk);
            op_code = code;
            shift = shift_value;
            operand_1 = op_a;
            operand_2 = op_b;
            op_start = 1'b1;
            @(negedge clk);
            op_start = 1'b0;
            shift = 2'b00;
            repeat (4) @(posedge clk);
            $display("ALU code=%h done=%b high=%h low=%h", code, op_done, result_2, result_1);
        end
    endtask

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        op_code = 4'h0;
        shift = 2'b00;
        operand_1 = 32'hFFFF_FFFF;
        operand_2 = 32'h0000_0002;
        op_start = 1'b0;
        op_clear = 1'b0;

        #2 reset_n = 1'b0;
        #12 reset_n = 1'b1;

        start_operation(4'h0, 2'b00, 32'd10, -32'd10);
        start_operation(4'h1, 2'b00, 32'h0F0F_0000, 32'd0);
        start_operation(4'h7, 2'b10, 32'h8000_0001, 32'd0);
        start_operation(4'hD, 2'b00, 32'd1234, -32'd10);
        start_operation(4'hE, 2'b00, 32'd1234, 32'd234);

        @(negedge clk);
        operand_1 = 32'd1234;
        operand_2 = 32'd5678;
        op_clear = 1'b1;
        @(negedge clk);
        op_clear = 1'b0;
        start_operation(4'hF, 2'b00, 32'd1234, 32'd5678);

        #80;
        $finish;
    end
endmodule
