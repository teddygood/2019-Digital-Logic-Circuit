`timescale 1ns/100ps

module tb_dff_rs;
    reg tb_clk, tb_set_n, tb_reset_n, tb_d; // 1-bit test bench input tb_clk(clock), tb_reset_n (reset signal), tb_set_n(set signal), tb_d
    wire tb_q; // 1-bit output tb_q

    // Instance of the Set/Resettable D-flip flop
    _dff_rs I0_dff_rs(.clk(tb_clk), .set_n(tb_set_n), .reset_n(tb_reset_n), .d(tb_d), .q(tb_q));

    // Clock generation
    always begin
        tb_clk = 0; #5; tb_clk = 1; #5; // clock period 10
    end

    // Initial block to apply test vectors
    initial begin
        // Initial values
        tb_d = 1'b0; tb_set_n = 1'b0; tb_reset_n = 1'b0;

        // Apply test vectors
        #3 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #10 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #10 tb_d = 1'b1; tb_reset_n = 1'b1;
        #10 tb_d = 1'b0;
        #10 tb_d = 1'b1;
        #10 tb_d = 1'b0; tb_set_n = 1'b1;
        #10 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #10 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #10 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #10 $stop;
    end
endmodule