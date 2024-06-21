`timescale 1ns/100ps // Setting the Time Unit of Simulation
module tb_cnt5; // testbench cnt5
    reg tb_clk, tb_reset_n; // clock, reset
    reg tb_inc; // increase/decrease signal
    wire [2:0] tb_cnt; // current state

    parameter temp = 10;

    cnt5 U0_cnt5(.cnt(tb_cnt), .clk(tb_clk), .reset_n(tb_reset_n), .inc(tb_inc)); 
    // instance 5-way counter 
    
    always #(temp / 2) tb_clk = ~tb_clk; // clock period 10

    initial begin
        tb_clk = 1; tb_reset_n = 1'b0; tb_inc = 1'b1; // first value
        #3 tb_reset_n = 1'b1; // change value
        #50 tb_inc = 1'b0; 
        #10 tb_reset_n = 1'b0; 
        #20 tb_reset_n = 1'b1; 
        #50 tb_inc = 1'b1;
        #50 $stop; 
    end
endmodule