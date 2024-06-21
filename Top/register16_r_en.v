module register16_r_en(clk, reset_n, d_in, d_out, en); // Resettable enabled 32-bit register
input	clk, reset_n, en;
input [15:0] d_in;		
output [15:0] d_out;	
	
// instance Resettable enabled 32-bit register
register8_r_en U0_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[7:0]), .d_out(d_out[7:0]), .en(en)); 
register8_r_en U1_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[15:8]), .d_out(d_out[15:8]), .en(en));  

endmodule