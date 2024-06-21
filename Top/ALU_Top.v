module ALU_Top(clk, reset_n, s_sel, s_wr, s_addr, s_din, s_dout, s_interrupt);
	input clk, reset_n, s_sel, s_wr;
	input[15:0] s_addr;
	input[31:0] s_din;
	
	wire[3:0] wAddr, rAddr;
	wire re;
	wire we;
	wire[31:0] wData, rData;
	
	wire inst_rd_en, inst_wr_en;
	wire[31:0] inst_din;
	wire[31:0] inst_dout;
	wire inst_full, inst_empty, inst_wr_ack, inst_wr_err, inst_rd_ack, inst_rd_err;
	wire[3:0] inst_data_count;
	
	wire r_rd_en, r_wr_en;
	wire[31:0] r_din;
	wire[31:0] r_dout;
	wire[31:0] INSTRUCTION;
	wire r_full, r_empty, r_wr_ack, r_wr_err, r_rd_ack, r_rd_err;
	wire[3:0] r_data_count;
	
	wire alu_begin;
	wire alu_done;
	
	output[31:0] s_dout;
	output s_interrupt;

	// ALU slave
	ALU_slave U0_ALU_slave(.clk(clk), .reset_n(reset_n), .s_sel(s_sel), .s_wr(s_wr), .s_addr(s_addr), .s_din(s_din), .s_interrupt(s_interrupt),
							  .inst_wr_err(inst_wr_err), .r_rd_err(r_rd_err), .r_dout(r_dout), .inst_empty(inst_empty), .op_done(op_done),
							  .s_dout(s_dout), .we(we), .wAddr(wAddr), .wData(wData), .inst_wr_en(inst_wr_en), .r_rd_en(r_rd_en), .instruction(INSTRUCTION),
							  .result(RESULT), .inst_dout(inst_dout)); 	
	// operand Register file
	DMAC_Register_file U1_Operand_Register_file(clk, reset_n, wAddr, wData, we, rAddr, rData); 
	// instruction fifo	8
	fifo U2_Instruction_fifo(.clk(clk), .reset_n(reset_n), .rd_en(inst_rd_en), .wr_en(inst_wr_en), .d_in(INSTRUCTION), .d_out(inst_dout),
									 .inst_full(inst_full), .inst_empty(inst_empty), .inst_wr_ack(inst_wr_ack), .inst_wr_err(inst_wr_err), .inst_rd_ack(inst_rd_ack),
									 .inst_rd_err(inst_rd_err), .inst_data_count(inst_data_count)); 
	// result fifo		16
	Result_fifo U2_Result_fifo(.clk(clk), .reset_n(reset_n), .r_rd_en(r_rd_en), .r_wr_en(r_wr_en), .d_in(RESULT), .r_dout(r_dout), .r_full(r_full),
										.r_empty(r_empty), .r_wr_ack(r_wr_ack), .r_wr_err(r_wr_err), .r_rd_ack(r_rd_ack), .r_rd_err(r_rd_err), .r_data_count(r_data_count)); 

	ALU_alu_top (.clk(clk), .reset_n(reset_n), alu_begin, inst_empty, inst_rd_err, inst_rd_ack, inst_dout, r_full, r_wr_err, r_wr_ack, rData, inst_rd_en, r_wr_en, .op_done(op_done), re, rAddr, r_din); 
	
endmodule 