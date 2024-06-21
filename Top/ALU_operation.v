module ALU_operation(clk, reset_n, op_code, shamt, operand_a, operand_b, op_start, op_clear, result, result_1 , op_done);
	input clk, reset_n;
	input[3:0] op_code;
	input[1:0] shamt;
	input[31:0] operand_a, operand_b;
	input op_start, op_clear;
	
	output reg[63:0] result;
	output reg op_done;
	
	wire[63:0] w_nop, w_not_a, w_not_b, w_and, w_or, w_xnor, w_xor, w_lsl_a, w_lsr_a, w_asr_a, w_lsl_b, w_lsr_b, w_asr_b, w_add, w_sub, w_mul;
	
	wire w_op_start, w_op_clear, w_op_done;

	//two operand and 16 results(extended)
	
	reg mul_op_start, mul_op_clear;
	assign w_op_start = mul_op_start;
	assign w_op_clear = mul_op_clear;
	
	always@(operand_a, operand_b, op_code) begin
			if(op_code != 4'hf) begin
					if(operand_a[31] == 0)
						if(operand_b[31] == 0) begin
							sign_extend1 = {32'b0, operand_a};
							sign_extend2 = {32'b0, operand_b};
						end
						// operand_b[31] == 1
						else begin
							sign_extend1 = {32'b0, operand_a};
							sign_extend2 = {32'b1, operand_b};
						end
					// operand_a[31] == 1	
					else
						if(operand_b[31] == 0) begin
							sign_extend1 = {32'b1, operand_a};
							sign_extend2 = {32'b0, operand_b};
						end
						// operand_b[31] == 1
						else begin
							sign_extend1 = {32'b1, operand_a};
							sign_extend2 = {32'b1, operand_b};
						end
				end
		end
	
	NOP NOP(sign_extend1, sign_extend2, w_nop);
	NOT_A NOTA(sign_extend1, w_not_a);
	NOT_B NOTB(sign_extend2, w_not_b);
	AND_ AND(sign_extend1, sign_extend2, w_and);
	OR_ OR(sign_extend1, sign_extend2, w_or);
	XOR_ XOR(sign_extend1, sign_extend2, w_xor);
	XNOR_ XNOR(sign_extend1, sign_extend2, w_xnor);
	LSL_A LSLA(sign_extend1, shamt, w_lsl_a);
	LSR_A LSRA(sign_extend1, shamt, w_lsr_a);
	ASR_A ASRA(sign_extend1, shamt, w_asr_a);
	LSL_B LSLB(sign_extend2, shamt, w_lsl_b);
	LSR_B LSRB(sign_extend2, shamt, w_lsr_b);
	ASR_B ASRB(sign_extend2, shamt, w_asr_b);
	ADD ADD(sign_extend1, sign_extend2, w_add);
	SUB SUB(sign_extend1, ~sign_extend2, w_sub);
	MUL MUL(.clk(clk), .reset_n(reset_n), .multiplier(sign_extend1), .multiplicand(sign_extend2), .op_start(w_op_start), .op_clear(w_op_clear), .op_done(w_op_done), .result(w_mul));
	//16 calculating blocks
	
	always @ (posedge clk or negedge reset_n)
		begin
			if (reset_n == 1'b0) 
				begin
					result = 64'b0;
					op_done = 1'b0;
					OP_START = 1'b0;
					OP_CLEAR = 1'b0;
				end
		
			else if (reset_n == 1'b1)
				begin
					if (op_code == 4'h0) // NOP
						begin
							if (op_start == 1'b1)
								begin 
									result = w_nop;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_nop;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h1) // NOT A
						begin
							if (op_start == 1'b1)
								begin 
									result = w_not_a;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_not_a;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h2) //NOTB
						begin
							if (op_start == 1'b1)
								begin 
									result = w_not_b;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_not_b;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h3) //AND
						begin
							if (op_start == 1'b1)
								begin 
									result = w_and;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_and;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h4) //OR
						begin
							if (op_start == 1'b1)
								begin 
									result = w_or;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_or;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h5) //XOR
						begin
							if (op_start == 1'b1)
								begin 
									result = w_xor;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_xor;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h6) //XNOR
						begin
							if (op_start == 1'b1)
								begin 
									result = w_xnor;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_xnor;
									op_done = 1'b0;
								end
						end
					
					else if (op_code == 4'h7) //LSLA
						begin
							if (op_start == 1'b1)
								begin 
									result = w_lsl_a;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_lsl_a;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h8) //LSRA
						begin
							if (op_start == 1'b1)
								begin 
									result = w_lsr_a;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_lsr_a;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'h9) //ASRA
						begin
							if (op_start == 1'b1)
								begin 
									result = w_asr_a;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_asr_a;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'hA) //LSLB
						begin
							if (op_start == 1'b1)
								begin 
									result = w_lsl_b;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_lsl_b;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'hB) //LSRB
						begin
							if (op_start == 1'b1)
								begin
									result = w_lsr_b;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_lsr_b;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'hC) //ASRB
						begin
							if (op_start == 1'b1)
								begin 
									result = w_asr_b;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_asr_b;
									op_done = 1'b0;
								end
						end
					
					else if (op_code == 4'hD) //ADD
						begin
							if (op_start == 1'b1)
								begin 
									result = w_add;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_add;
									op_done = 1'b0;
								end
						end
						
					else if (op_code == 4'hE) //SUB
						begin
							if (op_start == 1'b1)
								begin 
									result = w_sub;
									op_done = 1'b1;
								end
							else if (op_start == 1'b0)
								begin
									result = w_sub;
									op_done = 1'b0;
								end
						end
					
					else if (op_code == 4'hF) begin
							if (op_start == 1'b1) begin
									mul_op_clear = 1'b0;
									mul_op_start = 1'b1;
									op_done = 1'b0;
							end
							if (op_clear == 1'b1) begin
									mul_op_clear = 1'b1;
									mul_op_start = 1'b0;
									op_done = 1'b0;
							end
							if (w_op_done == 1'b1) begin
									result = w_mul;
									op_done = 1'b1;
							end
					end
					
					else //wrong opcode
						begin
							result = 32'hx;
							op_done = 1'bx;
						end
				end
		end
	
endmodule 