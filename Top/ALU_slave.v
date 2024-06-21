module ALU_slave(clk, reset_n, s_sel, s_wr, s_addr, s_din, inst_empty, op_done, s_dout, s_interrupt, alu_begin, instruction, result);
	input clk, reset_n, s_sel, s_wr;
	input[15:0] s_addr;
	input[31:0] s_din;
	
	input inst_empty;
	input op_done;
	
	output reg[31:0] s_dout;
	output reg s_interrupt;
	
	output reg alu_begin;

	reg[31:0] OPERATION_START;
	reg[31:0] INTERRUPT;
	reg[31:0] INTERRUPT_ENABLE;
	reg[31:0] INSTRUCTION;
	reg[31:0] RESULT;
	reg[31:0] ALU_STATUS;
	reg[31:0] OPERAND_00;
	reg[31:0] OPERAND_01;
	reg[31:0] OPERAND_02;
	reg[31:0] OPERAND_03;
	reg[31:0] OPERAND_04;
	reg[31:0] OPERAND_05;
	reg[31:0] OPERAND_06;
	reg[31:0] OPERAND_07;
	reg[31:0] OPERAND_08;
	reg[31:0] OPERAND_09;
	reg[31:0] OPERAND_10;
	reg[31:0] OPERAND_11;
	reg[31:0] OPERAND_12;
	reg[31:0] OPERAND_13;
	reg[31:0] OPERAND_14;
	reg[31:0] OPERAND_15;
	
	assign instruction = INSTRUCTION;
	assign result = RESULT;
	
	parameter Waiting = 2'b00;
	parameter Executing = 2'b01;
	parameter Done = 2'b10;
	parameter Fault = 2'b11;
	
	always @ (posedge clk or negedge reset_n)
		begin
			if (reset_n == 1'b0) //reset
				begin
					OPERATION_START = 32'h0000_0000; 
					INTERRUPT = 32'h0000_0000; 
					INTERRUPT_ENABLE = 32'h0000_0000; 
					INSTRUCTION = 32'h0000_0000; 
					RESULT = 32'h0000_0000; 
					ALU_STATUS = 32'h0000_0000; 
					OPERAND_00 = 32'h0000_0000;
					OPERAND_01 = 32'h0000_0000;
					OPERAND_02 = 32'h0000_0000;
					OPERAND_03 = 32'h0000_0000;
					OPERAND_04 = 32'h0000_0000;
					OPERAND_05 = 32'h0000_0000;
					OPERAND_06 = 32'h0000_0000;
					OPERAND_07 = 32'h0000_0000;
					OPERAND_08 = 32'h0000_0000;
					OPERAND_09 = 32'h0000_0000;
					OPERAND_10 = 32'h0000_0000;
					OPERAND_11 = 32'h0000_0000;
					OPERAND_12 = 32'h0000_0000;
					OPERAND_13 = 32'h0000_0000;
					OPERAND_14 = 32'h0000_0000;
					OPERAND_15 = 32'h0000_0000;
					s_dout = 32'h0000_0000;
					s_interrupt = 1'b0;
					we = 1'b0;
					wAddr = 4'b0000;
					wData = 32'h0000_0000;
				end
				
			else if (reset_n == 1'b1)
				begin
					if((s_sel == 1) && (s_wr == 1))	// write
						begin
							if(s_addr[7:0] == 8'b0000_0000)
								OPERATION_START = s_din;
							else if(s_addr[7:0] == 8'b0000_0001)
								INTERRUPT = s_din;
							else if(s_addr[7:0] == 8'b0000_0010)
								INTERRUPT_ENABLE = s_din;
							else if(s_addr[7:0] == 8'b0000_0011) begin
								INSTRUCTION = s_din;
								inst_wr_en = 1'b1;
							end	
								/*
							else if(s_addr[7:0] == 8'b0000_0100)
								RESULT = s_din;
							else if(s_addr[7:0] == 8'b0000_0101)
								ALU_STATUS = s_din;
								*/
							else if(s_addr[7:0] == 8'b0001_0000) begin
								OPERAND_00 = s_din;
								wData = s_din;
								wAddr = 4'b0000;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_0001) begin
								OPERAND_01 = s_din;
								wData = s_din;
								wAddr = 4'b0001;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_0010) begin
								OPERAND_02 = s_din;
								wData = s_din;
								wAddr = 4'b0010;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_0011) begin
								OPERAND_03 = s_din;
								wData = s_din;
								wAddr = 4'b0011;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_0100) begin
								OPERAND_04 = s_din;
								wData = s_din;
								wAddr = 4'b0100;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_0101) begin
								OPERAND_05 = s_din;
								wData = s_din;
								wAddr = 4'b0101;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_0110) begin
								OPERAND_06 = s_din;
								wData = s_din;
								wAddr = 4'b0110;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_0111) begin
								OPERAND_07 = s_din;
								wData = s_din;
								wAddr = 4'b0111;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1000) begin
								OPERAND_08 = s_din;
								wData = s_din;
								wAddr = 4'b1000;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1001) begin
								OPERAND_09 = s_din;
								wData = s_din;
								wAddr = 4'b1001;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1010) begin
								OPERAND_10 = s_din;
								wData = s_din;
								wAddr = 4'b1010;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1011) begin
								OPERAND_11 = s_din;
								wData = s_din;
								wAddr = 4'b1011;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1100) begin
								OPERAND_12 = s_din;
								wData = s_din;
								wAddr = 4'b1100;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1101) begin
								OPERAND_13 = s_din;
								wData = s_din;
								wAddr = 4'b1101;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1110) begin
								OPERAND_14 = s_din;
								wData = s_din;
								wAddr = 4'b1110;
								we = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0001_1111) begin
								OPERAND_15 = s_din;
								wData = s_din;
								wAddr = 4'b1111;
								we = 1'b1;
							end
							else;	
						end
				
					else if((s_sel == 1) && (s_wr == 0))	// read
						begin
							if(s_addr[7:0] == 8'b0000_0000)
								s_dout = OPERATION_START;
							else if(s_addr[7:0] == 8'b0000_0001)
								s_dout = INTERRUPT;
							else if(s_addr[7:0] == 8'b0000_0010)
								s_dout = INTERRUPT_ENABLE;
							else if(s_addr[7:0] == 8'b0000_0011) begin
								s_dout = INSTRUCTION;
								inst_rd_en = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0000_0100) begin
								s_dout = RESULT;
								r_rd_en = 1'b1;
							end
							else if(s_addr[7:0] == 8'b0000_0101)
								s_dout = ALU_STATUS;
							else if(s_addr[7:0] == 8'b0001_0000)
								s_dout = OPERAND_00;
							else if(s_addr[7:0] == 8'b0001_0001)
								s_dout = OPERAND_01;
							else if(s_addr[7:0] == 8'b0001_0010)
								s_dout = OPERAND_02;	
							else if(s_addr[7:0] == 8'b0001_0011)
								s_dout = OPERAND_03;	
							else if(s_addr[7:0] == 8'b0001_0100)
								s_dout = OPERAND_04;	
							else if(s_addr[7:0] == 8'b0001_0101)
								s_dout = OPERAND_05;	
							else if(s_addr[7:0] == 8'b0001_0110)
								s_dout = OPERAND_06;	
							else if(s_addr[7:0] == 8'b0001_0111)
								s_dout = OPERAND_07;	
							else if(s_addr[7:0] == 8'b0001_1000)
								s_dout = OPERAND_08;	
							else if(s_addr[7:0] == 8'b0001_1001)
								s_dout = OPERAND_09;	
							else if(s_addr[7:0] == 8'b0001_1010)
								s_dout = OPERAND_10;	
							else if(s_addr[7:0] == 8'b0001_1011)
								s_dout = OPERAND_11;	
							else if(s_addr[7:0] == 8'b0001_1100)
								s_dout = OPERAND_12;	
							else if(s_addr[7:0] == 8'b0001_1101)
								s_dout = OPERAND_13;	
							else if(s_addr[7:0] == 8'b0001_1110)
								s_dout = OPERAND_14;	
							else if(s_addr[7:0] == 8'b0001_1111)
								s_dout = OPERAND_15;	
							else;	
						end
					else if (s_sel == 1'b0)
						s_dout = 32'h0000_0000; //meaningless output
					else
						s_dout = 32'hxxxx_xxxx; //error
				
					if(inst_wr_err == 1'b1) begin
						ALU_STATUS[1:0] = 2'b11; 
						INSTRUCTION = 32'h0;
						inst_wr_en = 1'b0;
					end
					else if(inst_rd_err == 1'b1) begin
						ALU_STATUS[1:0] = 2'b11; 
						INSTRUCTION = 32'h0;
						inst_rd_en = 1'b0;
					end
					else if(r_wr_err == 1'b1) begin
						ALU_STATUS[1:0] = 2'b11; 
						RESULT = 32'h0;
						r_wr_en = 1'b0;
					end
					else if(r_rd_err == 1'b1) begin
						ALU_STATUS[1:0] = 2'b11; 
						RESULT = 32'h0;
						r_rd_en = 1'b0;
					end
					else ;
		
					if(OPERATION_START[0] == 1'b1) begin
							if(inst_empty == 1'b1) 
								ALU_STATUS = 2'b11;
							else if(inst_empty == 1'b0)
								ALU_STATUS = 2'b01; 
							else 
								ALU_STATUS = 2'bxx;
						end
					
					if(INTERRUPT[0] == 1'b0) begin
							s_interrupt = 1'b0;
							OPERATION_START[0] = 1'b0;
						end
					
					if(INTERRUPT_ENABLE == 1'b1) 
						if(INTERRUPT[0] == 1'b1)
							s_interrupt = 1'b1;
					else if(INTERRUPT_ENABLE == 1'b0)
						if(INTERRUPT[0] == 1'b1)
							s_interrupt = 1'b0;		
					else
						s_interrupt = 1'bx;

					if(op_done == 1'b1) 
						begin
							INTERRUPT[0] = 1'b1;
							s_interrupt = 1'b1;
							ALU_STATUS = 2'b10;
						end
				end
		end 
endmodule 