module register32_16(clk, reset_n, en, d_in, d_out0, d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7, d_out8, d_out9, d_out10, d_out11, d_out12, d_out13, d_out14, d_out15); // 8 32-bit registers
input	clk, reset_n; 
input [15:0] en;  
input [31:0] d_in; 
output [31:0] d_out0, d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7, d_out8, d_out9, d_out10, d_out11, d_out12, d_out13, d_out14, d_out15; 

// instance Resettable enabled 32-bit register
register32_r_en U0_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out0), .en(en[0])); 
register32_r_en U1_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out1), .en(en[1])); 
register32_r_en U2_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out2), .en(en[2])); 
register32_r_en U3_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out3), .en(en[3])); 
register32_r_en U4_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out4), .en(en[4])); 
register32_r_en U5_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out5), .en(en[5])); 
register32_r_en U6_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out6), .en(en[6])); 
register32_r_en U7_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out7), .en(en[7])); 
register32_r_en U8_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out8), .en(en[8])); 
register32_r_en U9_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out9), .en(en[9])); 
register32_r_en U10_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out10), .en(en[10])); 
register32_r_en U11_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out11), .en(en[11])); 
register32_r_en U12_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out12), .en(en[12])); 
register32_r_en U13_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out13), .en(en[13])); 
register32_r_en U14_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out14), .en(en[14])); 
register32_r_en U15_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out15), .en(en[15])); 


	
endmodule
