`timescale 1ns/100ps

module tb_dff_rs_sync_async;
    reg tb_clk, tb_set_n, tb_reset_n, tb_d; // 1-bit test bench input tb_clk(clock), tb_set_n(set signal), tb_reset_n(reset signal), tb_d
    wire tb_q_sync, tb_q_async; // 1-bit test bench output q_sync(synchronous D-ff output), q_async(asynchronous D-ff output)
    
    _dff_rs_sync_async I0_dff_rs_sync_async(.clk(tb_clk), .set_n(tb_set_n), .reset_n(tb_reset_n), .d(tb_d), .q_sync(tb_q_sync), .q_async(tb_q_async));
    // Asynchronous set/resettable D-filp flop & synchronous set/resettable D-filp flop 'I0_dff_rs_sync_async' instance
    
    always begin
        tb_clk = 1; #5; tb_clk = 0; #5; // clock period 10
    end
    
    initial begin
        tb_d = 1'b0; tb_set_n = 1'b0; tb_reset_n = 1'b0;
        #10 tb_set_n = 1'b1; tb_reset_n = 1'b1;
        #3 tb_d = 1'b1;
        #10 tb_d = 1'b0; tb_reset_n = 1'b0;
        #5 tb_d = 1'b1; 
        #10 tb_d = 1'b0;
        #5 tb_d = 1'b1;
        #10 tb_d = 1'b0; tb_reset_n = 1'b1; tb_set_n = 1'b0;
        #5 tb_d = 1'b1;
        #10 tb_d = 1'b0;
        #5 tb_d = 1'b1; tb_set_n = 1'b1;
        #10 tb_d = 1'b0; tb_set_n = 1'b0;
        #5 tb_d = 1'b1; tb_reset_n = 1'b1;
        #10 tb_d = 1'b0;
        #5 tb_d = 1'b1; tb_reset_n = 1'b0;
        #10 $stop;
    end
endmodule