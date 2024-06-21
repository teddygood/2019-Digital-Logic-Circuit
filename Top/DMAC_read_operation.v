//print output accoding to Addr selectively by using 8to1 multiplexer(for DMAC)
module DMAC_read_operation(Addr, Data, from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6, from_reg7, from_reg8, from_reg9, from_reg10, from_reg11, from_reg12, from_reg13, from_reg14, from_reg15);
input [31:0] from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6, from_reg7, from_reg8, from_reg9, from_reg10, from_reg11, from_reg12, from_reg13, from_reg14, from_reg15;
input [3:0] Addr;
output [31:0] Data;

_16_to_1_MUX U0_16_to_1_MUX(.a(from_reg0), .b(from_reg1), .c(from_reg2), .d(from_reg3), .e(from_reg4), .f(from_reg5), .g(from_reg6), .h(from_reg7),
									.i(from_reg8), .j(from_reg8), .k(from_reg8), .l(from_reg9), .m(from_reg10), .n(from_reg11), .o(from_reg15), .sel(Addr), .d_out(Data));

endmodule
