`timescale 1ns/100ps // Setting the Time Unit of Simulation

module tb_cntr8; // testbench 8-bit loadable up/down counter
    reg tb_clk, tb_reset_n, tb_inc, tb_load;
    reg [7:0] tb_d_in;
    wire [7:0] tb_d_out;
    wire [2:0] tb_o_state; // verification state
    
    cntr8 I0_cntr8(.clk(tb_clk), .reset_n(tb_reset_n), .inc(tb_inc), .load(tb_load), .d_in(tb_d_in), .d_out(tb_d_out), .o_state(tb_o_state));
    // instance 8-bit loadable up/down counter
    
    parameter STEP = 10;
    always #(STEP / 2) tb_clk = ~tb_clk; // clock period 10
    
    initial begin
        tb_clk = 1; tb_reset_n = 1'b0; tb_inc = 1'b0; tb_load = 1'b0; tb_d_in = 8'b0; // initial value
        #23 tb_reset_n = 1'b1; tb_inc = 1; // change value
        #50 tb_inc = 1'b0;
        #50 tb_load = 1'b1; tb_d_in = 8'b00001000;
        #20 tb_inc = 1'b1; tb_load = 1'b0; tb_d_in = 8'b0;
        #10 tb_d_in = 8'b0; tb_d_in = 8'b00100100; tb_inc = 1'b1;
        #20 tb_reset_n = 0; tb_inc = 0;
        #10 tb_reset_n = 1;
        #40 $stop;
    end
endmodule