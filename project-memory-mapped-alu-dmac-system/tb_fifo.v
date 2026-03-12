`timescale 1ns/100ps

module tb_fifo;
    reg clk, reset_n, rd_en, wr_en;
    reg [31:0] d_in;

    wire [31:0] d_out;
    wire full, empty, wr_ack, wr_err, rd_ack, rd_err;
    wire [4:0] data_count;

    fifo_16 dut(
        .clk(clk),
        .reset_n(reset_n),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .d_in(d_in),
        .d_out(d_out),
        .full(full),
        .empty(empty),
        .wr_ack(wr_ack),
        .wr_err(wr_err),
        .rd_ack(rd_ack),
        .rd_err(rd_err),
        .data_count(data_count)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        rd_en = 1'b0;
        wr_en = 1'b0;
        d_in = 32'h0000_0000;

        #2 reset_n = 1'b0;
        #12 reset_n = 1'b1;

        @(negedge clk);
        rd_en = 1'b1;
        @(posedge clk);
        $display("FIFO empty read err=%b count=%d", rd_err, data_count);

        @(negedge clk);
        rd_en = 1'b0;
        wr_en = 1'b1;
        d_in = 32'd10;
        @(negedge clk);
        d_in = 32'd20;
        @(negedge clk);
        d_in = 32'd30;
        @(negedge clk);
        d_in = 32'd40;
        wr_en = 1'b0;

        @(negedge clk);
        rd_en = 1'b1;
        repeat (4) begin
            @(posedge clk);
            $display("FIFO read ack=%b data=%h count=%d", rd_ack, d_out, data_count);
            @(negedge clk);
        end
        rd_en = 1'b0;

        #40;
        $finish;
    end
endmodule
