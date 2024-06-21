`timescale 1ns/100ps

module tb_dlatch;  // testbench for dlatch
    reg tb_clk, tb_d;  // input tb_clk, tb_d
    wire tb_q, tb_q_bar;  // output tb_q, tb_q_bar

    _dlatch U0_dlatch(.clk(tb_clk), .d(tb_d), .q(tb_q), .q_bar(tb_q_bar));  // instance of D latch

    always begin
        tb_clk = 0; #12.5; 
        tb_clk = 1; #12.5;  // clock period 25
    end

    initial begin
        tb_d = 1'b0;  // start value
        #8  tb_d = 1'b1;  // change value
        #7  tb_d = 1'b0;
        #15 tb_d = 1'b1;
        #5  tb_d = 1'b0;
        #10 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #20 $stop;
    end
endmodule