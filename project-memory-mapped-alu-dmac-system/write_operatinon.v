module write_operation(Addr, we, to_reg);
	input we;
	input[2:0] Addr;
	output[7:0] to_reg;
	
	wire[7:0] w_a;
	
	_3_to_8_decoder _3_to_8_decoder_1(Addr, w_a);
	
	_and2 _and2_1(we, w_a[0], to_reg[0]);
	_and2 _and2_2(we, w_a[1], to_reg[1]);
	_and2 _and2_3(we, w_a[2], to_reg[2]);
	_and2 _and2_4(we, w_a[3], to_reg[3]);
	_and2 _and2_5(we, w_a[4], to_reg[4]);
	_and2 _and2_6(we, w_a[5], to_reg[5]);
	_and2 _and2_7(we, w_a[6], to_reg[6]);
	_and2 _and2_8(we, w_a[7], to_reg[7]);
	//if we = 0, eight to_reg will be 0
	//if we = 1, only one to_reg will be 1, other seven to_reg will be 0
	
endmodule 