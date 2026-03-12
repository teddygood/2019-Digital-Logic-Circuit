`timescale 1ns/100ps

module tb_ram;
    reg clk, cen, wen;
    reg [15:0] addr;
    reg [31:0] din;

    wire [31:0] dout;

    ram dut(
        .clk(clk),
        .cen(cen),
        .wen(wen),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        cen = 1'b0;
        wen = 1'b0;
        addr = 16'h0000;
        din = 32'h0000_0000;

        @(negedge clk);
        cen = 1'b1;
        wen = 1'b1;
        addr = 16'h0000;
        din = 32'd10000;
        @(negedge clk);
        addr = 16'h0001;
        din = 32'd20000;
        @(negedge clk);
        addr = 16'h0002;
        din = 32'd30000;
        @(negedge clk);
        addr = 16'h0004;
        din = 32'd40000;

        @(negedge clk);
        wen = 1'b0;
        addr = 16'h0000;
        @(posedge clk);
        $display("RAM[0] -> %h", dout);
        @(negedge clk);
        addr = 16'h0001;
        @(posedge clk);
        $display("RAM[1] -> %h", dout);
        @(negedge clk);
        addr = 16'h0002;
        @(posedge clk);
        $display("RAM[2] -> %h", dout);
        @(negedge clk);
        addr = 16'h0004;
        @(posedge clk);
        $display("RAM[4] -> %h", dout);

        @(negedge clk);
        cen = 1'b0;

        #20;
        $finish;
    end
endmodule
