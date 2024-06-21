module register3_r_en(clk, reset_n, d_in, d_out, en); // Resettable enabled 3-bit register
input clk, reset_n, en;
input [2:0] d_in;
output [2:0] d_out;

_dff_r_en U0_dff_r_en(clk, reset_n,en,d_in[0], d_out[0]);
_dff_r_en U1_dff_r_en(clk, reset_n,en,d_in[1], d_out[1]);
_dff_r_en U2_dff_r_en(clk, reset_n,en,d_in[2], d_out[2]);

endmodule