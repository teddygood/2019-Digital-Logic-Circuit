`timescale 1ns/100ps

module tb_ALU_registerfile;
    reg clk, reset_n, we;
    reg [3:0] wAddr, rAddr;
    reg [31:0] wData;
    wire [31:0] rData;

    ALU_registerfile dut(
        .clk(clk),
        .reset_n(reset_n),
        .wAddr(wAddr),
        .wData(wData),
        .we(we),
        .rAddr(rAddr),
        .rData(rData)
    );

    always #5 clk = ~clk;

    task write_entry;
        input [3:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            we = 1'b1;
            wAddr = addr;
            wData = data;
            @(negedge clk);
            we = 1'b0;
        end
    endtask

    task read_entry;
        input [3:0] addr;
        begin
            rAddr = addr;
            #1;
            $display("RF[%0d] -> %h", addr, rData);
        end
    endtask

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        we = 1'b0;
        wAddr = 4'h0;
        rAddr = 4'h0;
        wData = 32'h0000_0000;

        #2 reset_n = 1'b0;
        #12 reset_n = 1'b1;

        write_entry(4'h0, 32'h5BBD_F7EF);
        write_entry(4'h7, 32'hB77B_EFDF);
        write_entry(4'h9, 32'h1111_2222);
        write_entry(4'hF, 32'h3333_4444);

        read_entry(4'h0);
        read_entry(4'h7);
        read_entry(4'h9);
        read_entry(4'hF);

        #20;
        $finish;
    end
endmodule
