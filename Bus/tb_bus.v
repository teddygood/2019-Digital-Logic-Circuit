`timescale 1ns/100ps // timescale
module tb_bus; // testbench of bus

    reg clk, reset_n, m0_req, m0_wr, m1_req, m1_wr;
    reg [7:0] m0_address, m1_address;
    reg [31:0] m0_dout, m1_dout, s0_dout, s1_dout;

    wire m0_grant, m1_grant, s0_sel, s1_sel, s_wr;
    wire [7:0] s_address;
    wire [31:0] m_din, s_din;

    // Instance bus 
    bus U0_bus(
        clk, reset_n, m0_req, m0_wr, m0_address, m0_dout, m1_req, m1_wr, m1_address, m1_dout, 
        s0_dout, s1_dout, m0_grant, m1_grant, m_din, s0_sel, s1_sel, s_address, s_wr, s_din
    );

    always begin
        clk = 1; #5; clk = 0; #5; // clock period 10
    end

    initial begin
        // initialize value
        reset_n = 0; m0_req = 0; m0_wr = 0; m0_address = 8'h0; m0_dout = 32'h0; 
        m1_address = 8'h0; m1_req = 0; m1_wr = 0; m1_dout = 32'h0; s0_dout = 32'b0; s1_dout = 32'b0;
        // m0_req = 0, m1_req = 0
        #8 reset_n = 1'b1;
        #5 m0_dout = 32'h61; s0_dout = 32'h81; m0_req = 1'b1; m0_wr = 1'b1; // m0_req = 1, m1_req = 0
        #10 m0_address = 8'h01; m0_dout = 32'h62; s1_dout = 32'h82; 
        #10 m0_address = 8'h02; m0_dout = 32'h63; s0_dout = 32'h83;
        #10 m0_address = 8'h03; m0_dout = 32'h64; s1_dout = 32'h84;
        #10 m0_address = 8'h04; m0_dout = 32'h65; s0_dout = 32'h85;
        #30 m0_address = 8'h05; m1_wr = 1'b1; m0_req = 1'b0; m1_req = 1'b1; // m0_req = 0, m1_req = 1
        #10 m1_address = 8'h21; m1_dout = 32'h66; s0_dout = 32'h86;
        #10 m1_address = 8'h22; m1_dout = 32'h67; s1_dout = 32'h87;
        #10 m1_address = 8'h23; m1_dout = 32'h68; s0_dout = 32'h88;
        #10 m1_address = 8'h24; m1_dout = 32'h69; s1_dout = 32'h89;
        #10 m1_address = 8'h25; m1_dout = 32'h70; s1_dout = 32'h90; 
        #20 reset_n = 1'b0;
        #20 $stop;
    end
endmodule