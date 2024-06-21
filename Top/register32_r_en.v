module register32_r_en(clk, reset_n, d_in, d_out, en); // Resettable enabled 32-bit register
input	clk, reset_n, en;
input [31:0] d_in;		
output [31:0] d_out;	
	
// instance Resettable enabled 32-bit register
register8_r_en U0_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[7:0]), .d_out(d_out[7:0]), .en(en)); 
register8_r_en U1_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[15:8]), .d_out(d_out[15:8]), .en(en));  
register8_r_en U2_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[23:16]), .d_out(d_out[23:16]), .en(en));  
register8_r_en U3_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[31:24]), .d_out(d_out[31:24]), .en(en));  

endmodule