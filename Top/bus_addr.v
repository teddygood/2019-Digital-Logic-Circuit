module bus_addr(s_address,s0_sel, s1_sel, s2_sel, s3_sel, s4_sel); // address decoder module
	input [15:0] s_address;
	output reg s0_sel, s1_sel, s2_sel, s3_sel, s4_sel;

always@(s_address)
	begin
	/* DMAC */
	if((s_address >= 15'h000)&&(s_address < 15'h01F))
		{s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} <= 5'b10000;	 // s0_sel  = 1
	/* ALU */		//
	else if((s_address >= 15'h100)&&(s_address < 15'h11F)) 
		{s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} <= 5'b01000;	 // s1_sel = 1		
	/* RAM(operand) */
	else if((s_address >= 15'h200)&&(s_address < 15'h23F)) 
		{s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} <= 5'b00100;	 // s2_sel = 1		
	/* RAM(Instruction) */
	else if((s_address >= 15'h300)&&(s_address < 15'h33F)) 
		{s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} <= 5'b00010;	 // s3_sel = 1							
	/* RAM(Result) */
	else if((s_address >= 15'h400)&&(s_address < 15'h43F)) 
		{s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} <= 5'b00001;	 // s4_sel = 1							
	/* Default */
	else
		{s0_sel, s1_sel, s2_sel, s3_sel, s4_sel} <= 5'bx;	
		
		
	end
endmodule