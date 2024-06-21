module register32_8(clk, reset_n, en, d_in, d_out0, d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7); // 8 32-bit registers
input	clk, reset_n; 
input [7:0]	en;  
input [31:0] d_in; 
output [31:0] d_out0, d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7; 

// instance Resettable enabled 32-bit register
register32_r_en U0_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out0), .en(en[0])); 
register32_r_en U1_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out1), .en(en[1])); 
register32_r_en U2_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out2), .en(en[2])); 
register32_r_en U3_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out3), .en(en[3])); 
register32_r_en U4_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out4), .en(en[4])); 
register32_r_en U5_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out5), .en(en[5])); 
register32_r_en U6_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out6), .en(en[6])); 
register32_r_en U7_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out7), .en(en[7])); 
	
endmodule

module register32_r_en(clk, reset_n, d_in, d_out, en); // Resettable enabled 32-bit register
input clk, reset_n, en;
input [31:0] d_in;		
output [31:0] d_out;	
	
// instance Resettable enabled 32-bit register
register8_r_en U0_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[7:0]), .d_out(d_out[7:0]), .en(en)); 
register8_r_en U1_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[15:8]), .d_out(d_out[15:8]), .en(en));  
register8_r_en U2_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[23:16]), .d_out(d_out[23:16]), .en(en));  
register8_r_en U3_register8_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in[31:24]), .d_out(d_out[31:24]), .en(en));  
	
endmodule

module register8_r_en(clk, reset_n, d_in, d_out, en); // Resettable enabled 8-bit register
input clk, reset_n, en; 
input [7:0] d_in;   
output [7:0] d_out; 
	
// instance Resettable enabled D flip flop
_dff_r_en U0_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[0]), .q(d_out[0])); 
_dff_r_en U1_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[1]), .q(d_out[1])); 
_dff_r_en U2_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[2]), .q(d_out[2])); 
_dff_r_en U3_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[3]), .q(d_out[3])); 
_dff_r_en U4_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[4]), .q(d_out[4])); 
_dff_r_en U5_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[5]), .q(d_out[5])); 
_dff_r_en U6_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[6]), .q(d_out[6])); 
_dff_r_en U7_dff_r_en(.clk(clk), .reset_n(reset_n), .en(en), .d(d_in[7]), .q(d_out[7])); 
	
endmodule

module _dff_r_en(clk, reset_n, en, d, q);	// Resettable enabled D flip flop
input clk, reset_n, en, d;
output reg q;

always @ (posedge clk or negedge reset_n)
begin
if(reset_n==0) q<=1'b0;
else if(en) q<=d;
else q<=q;
end
endmodule 

