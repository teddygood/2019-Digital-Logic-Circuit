`timescale 1ns/100ps

module tb_ALU_Top;
    reg clk, reset_n, s_sel, s_wr;
    reg [15:0] s_addr;
    reg [31:0] s_din;

    wire [31:0] s_dout;
    wire s_interrupt;

    ALU_Top dut(
        .clk(clk),
        .reset_n(reset_n),
        .s_sel(s_sel),
        .s_wr(s_wr),
        .s_addr(s_addr),
        .s_din(s_din),
        .s_dout(s_dout),
        .s_interrupt(s_interrupt)
    );

    always #5 clk = ~clk;

    task write_reg;
        input [15:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            s_sel = 1'b1;
            s_wr = 1'b1;
            s_addr = addr;
            s_din = data;
            @(negedge clk);
            s_sel = 1'b0;
            s_wr = 1'b0;
            s_addr = 16'h0000;
            s_din = 32'h0000_0000;
        end
    endtask

    task read_reg;
        input [15:0] addr;
        begin
            @(negedge clk);
            s_sel = 1'b1;
            s_wr = 1'b0;
            s_addr = addr;
            @(posedge clk);
            $display("ALU read %h -> %h (interrupt=%b)", addr, s_dout, s_interrupt);
            @(negedge clk);
            s_sel = 1'b0;
            s_addr = 16'h0000;
        end
    endtask

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        s_sel = 1'b0;
        s_wr = 1'b0;
        s_addr = 16'h0000;
        s_din = 32'h0000_0000;

        #2 reset_n = 1'b0;
        #12 reset_n = 1'b1;

        write_reg(16'h0010, 32'd1234);
        write_reg(16'h0011, 32'd5678);
        write_reg(16'h0003, 32'h0000_3404); // ADD operand0, operand1
        write_reg(16'h0002, 32'h0000_0001);
        write_reg(16'h0000, 32'h0000_0001);

        repeat (100) @(posedge clk);

        read_reg(16'h0005);
        read_reg(16'h0004);
        read_reg(16'h0004);

        write_reg(16'h0001, 32'h0000_0000);
        write_reg(16'h0002, 32'h0000_0000);

        #40;
        $finish;
    end
endmodule
