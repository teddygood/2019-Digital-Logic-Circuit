module DMAC_slave(clk, reset_n, s_sel, s_wr, op_done, op_clear, s_addr, s_din, source_addr, dest_addr, data_size, op_start, s_interrupt, wr_en, s_dout, op_mode, empty, full);
	input clk, reset_n, s_sel, s_wr, op_done;
	input [15:0] s_addr;
	input [31:0] s_din;
	input empty, full;
	
	output reg [15:0] source_addr, dest_addr, data_size;
	output op_start, op_clear, wr_en;
	output reg s_interrupt;
	output reg [31:0] s_dout;
	output [1:0] op_mode;
	
	parameter Waiting = 2'b00;
	parameter Executing = 2'b01;
	parameter Done = 2'b10;
	parameter Fault = 2'b11;

	reg[31:0] OPERATION_START; //OPERATION_START
	reg[31:0] INTERRUPT; //INTERRUPT
	reg[31:0] INTERRUPT_ENABLE; //INTERRUPT_ENABLE
	reg[31:0] SOURCE_ADDRESS; //SOURCE_ADDRESS
	reg[31:0] DESTINATION_ADDRESS; //DESTINATION_ADDRESS
	reg[31:0] DATA_SIZE; //DATA_SIZE
	// reg[31:0] DESCRIPTOR_SIZE; //DESCRIPTOR_SIZE
	reg[31:0] DESCRIPTOR_PUSH; //DESCRIPTOR_SIZE
	reg[31:0] OPERATION_MODE; //OPERATION_MODE
	reg[31:0] DMA_STATUS; //DMA_STATUs

	assign op_start 		= OPERATION_START[0];
	assign op_clear		= INTERRUPT[0];
	assign wr_en 			= DESCRIPTOR_PUSH[0];
	assign op_mode 		= OPERATION_MODE[1:0];
	
	always @ (posedge clk or negedge reset_n)
		begin
			if(reset_n == 1'b0)
				begin
					OPERATION_START = 32'h0000_0000; //OPERATION_START
					INTERRUPT = 32'h0000_0000; //INTERRUPT
					INTERRUPT_ENABLE = 32'h0000_0000; //INTERRUPT_ENABLE
					SOURCE_ADDRESS = 32'h0000_0000; //SOURCE_ADDRESS
					DESTINATION_ADDRESS = 32'h0000_0000; //DESTINATION_ADDRESS
					DATA_SIZE = 32'h0000_0000; //DATA_SIZE
					// DESCRIPTOR_SIZE = 32'h0000_0000; //DESCRIPTOR_SIZE
					DESCRIPTOR_PUSH = 32'h0000_0000;
					OPERATION_MODE = 32'h0000_0000; //OPERATION_MODE
					DMA_STATUS <= 32'h0000_0000; //DMA_STATUS
					s_dout = 32'h0000_0000;
					s_interrupt = 1'b0;
				end
			else if(reset_n == 1'b1)
				begin
					if((s_sel == 1) && (s_wr == 1))	// write
						begin
							if(s_addr[7:0] == 8'b0000_0000)
								OPERATION_START <= s_din;
							else if(s_addr[7:0] == 8'b0000_0001)
								INTERRUPT <= s_din;
							else if(s_addr[7:0] == 8'b0000_0010)
								INTERRUPT_ENABLE <= s_din;
							else if(s_addr[7:0] == 8'b0000_0011)
								SOURCE_ADDRESS <= s_din;
							else if(s_addr[7:0] == 8'b0000_0100)
								DESTINATION_ADDRESS <= s_din;
							else if(s_addr[7:0] == 8'b0000_0101)
								DATA_SIZE <= s_din;
							else if(s_addr[7:0] == 8'b0000_0110)
								DESCRIPTOR_PUSH <= s_din;
							else if(s_addr[7:0] == 8'b0000_0111)
								OPERATION_MODE <= s_din;
							/*
							else if(s_addr[7:0] == 8'b0000_1000)
								DMA_STATUS = s_din;
							*/
							else;	
						end
				
					else if((s_sel == 1) && (s_wr == 0))  // read
						begin
							if(s_addr[7:0] == 8'b0000_0000)
								s_dout <= OPERATION_START;
							else if(s_addr[7:0] == 8'b0000_0001)
								s_dout <= INTERRUPT;
							else if(s_addr[7:0] == 8'b0000_0010)
								s_dout <= INTERRUPT_ENABLE;
							else if(s_addr[7:0] == 8'b0000_0011)
								s_dout <= SOURCE_ADDRESS;
							else if(s_addr[7:0] == 8'b0000_0100)
								s_dout <= DESTINATION_ADDRESS;
							else if(s_addr[7:0] == 8'b0000_0101)
								s_dout <= DATA_SIZE;
							else if(s_addr[7:0] == 8'b0000_0110)
								s_dout <= DESCRIPTOR_PUSH;
							else if(s_addr[7:0] == 8'b0000_0111)
								s_dout <= OPERATION_MODE;
							else if(s_addr[7:0] == 8'b0000_1000)
								s_dout <= DMA_STATUS;
							else
								s_dout <= 32'hxxxx_xxxx;
						end
					else if(s_sel == 1'b0)
						s_dout = 32'h0000_0000; // default case
					else
						s_dout = 32'hxxxx_xxxx; // error

					if(OPERATION_START[0] == 1'b0)
						DMA_STATUS <= 2'b00;
					else if(OPERATION_START[0] == 1'b1) 
						begin
							if(empty == 1'b1)		// fifo empty
								DMA_STATUS <= 2'b11; 
							else if(empty == 1'b0)
								DMA_STATUS <= 2'b01;
							else
								DMA_STATUS <= 2'bxx;
						end
					else ;
							
					if(INTERRUPT[0] == 1'b0) 
						begin
							s_interrupt = 1'b0;
							OPERATION_START[0] <= 1'b0;
						end
						/*
					else if(INTERRUPT[0] == 1'b1)
						begin
							s_interrupt = 1'b1;
							OPERATION_START[0] = 1'b0;
						end
						*/
					else ;
					
					if(INTERRUPT_ENABLE == 1'b1) 
						if(INTERRUPT[0] == 1'b1)
							s_interrupt <= 1'b1;
					else if(INTERRUPT_ENABLE == 1'b0)
						if(INTERRUPT[0] == 1'b1)
							s_interrupt <= 1'b0;		
					else
						s_interrupt <= 1'bx;
						
					if(DESCRIPTOR_PUSH[0] == 1'b1) // push to fifo
						begin
							if(full == 1'b1) // fifo is full (error)
								DMA_STATUS <= 2'b11;
							else if(full == 1'b0) // fifo is not full
								begin
									source_addr <= SOURCE_ADDRESS[15:0];
									dest_addr <= DESTINATION_ADDRESS[15:0];
									data_size <= DATA_SIZE[15:0];
									DESCRIPTOR_PUSH[0] <= 1'b0;
								end
						end
					else if(DESCRIPTOR_PUSH[0] == 1'b0)
						begin
							source_addr <= 16'h0;
							dest_addr <= 16'h0;
							data_size <= 16'h0;
							DESCRIPTOR_PUSH[0] <= 1'b0;
						end	
					else ;
						
					if(op_done == 1'b1) 
						begin
							INTERRUPT[0] <= 1'b1;
							s_interrupt <= 1'b1;
							// op_start = 1'b0; 
							DMA_STATUS <= 2'b10; 
						end
					else ;
				end
				else ;
		end
endmodule 