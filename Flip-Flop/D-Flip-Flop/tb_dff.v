`timescale 1ns/100ps

module tb_dff; // testbench D Flip Flop
    reg tb_clk, tb_d; // input tb_clk, tb_d
    wire tb_q, tb_q_bar; // output tb_q, tb_q_bar

    _dff U0_dff(.clk(tb_clk), .d(tb_d), .q(tb_q), .q_bar(tb_q_bar));
    // instance D Flip Flop

    always begin
        tb_clk = 0; #12.5; tb_clk = 1; #12.5; // clock period 50
    end

    initial begin
        tb_d = 1'b0; // start value
        #8 tb_d = 1'b1; // change value
        #7 tb_d = 1'b0;
        #15 tb_d = 1'b1;
        #5 tb_d = 1'b0;
        #10 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #20 $stop;
    end
endmodule