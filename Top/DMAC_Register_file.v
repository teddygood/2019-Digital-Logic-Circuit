module DMAC_Register_file(clk, reset_n, wAddr, wData, we, rAddr, rData); // Register file
input clk, reset_n, we; // clk(clock), reset_n(reset signal), we(write enable)
input [3:0] wAddr, rAddr; // wAddr(decoder signal), rAddr(MUX signal)
input [31:0] wData;	
output [31:0] rData;	
	
wire [15:0] to_reg;
wire [31:0]	from_reg[15:0];
	
// instance 8 32-bit register 
register32_16 U0_register32_16(.clk(clk), .reset_n(reset_n), .en(to_reg), .d_in(wData), .d_out0(from_reg[0]), .d_out1(from_reg[1]), .d_out2(from_reg[2]), 
											.d_out3(from_reg[3]), .d_out4(from_reg[4]), .d_out5(from_reg[5]), .d_out6(from_reg[6]), .d_out7(from_reg[7]), .d_out8(from_reg[8]),
											.d_out9(from_reg[9]), .d_out10(from_reg[10]), .d_out11(from_reg[11]), .d_out12(from_reg[12]), .d_out13(from_reg[13]), .d_out14(from_reg[14]), .d_out15(from_reg[15]));
	
// instance write operation
DMAC_write_operation U1_write_operation( .Addr(wAddr), .we(we), .to_reg(to_reg));

// instance read operation
DMAC_read_operation U2_read_operation(.Addr(rAddr), .Data(rData), .from_reg0(from_reg[0]), .from_reg1(from_reg[1]), .from_reg2(from_reg[2]),
												.from_reg3(from_reg[3]), .from_reg4(from_reg[4]), .from_reg5(from_reg[5]), .from_reg6(from_reg[6]), .from_reg7(from_reg[7]),
												.from_reg7(from_reg[7]), .from_reg8(from_reg[8]), .from_reg9(from_reg[9]), .from_reg10(from_reg[10]), .from_reg11(from_reg[11]),
												.from_reg12(from_reg[12]), .from_reg13(from_reg[13]), .from_reg14(from_reg[14]), .from_reg15(from_reg[15]));
	
endmodule
	