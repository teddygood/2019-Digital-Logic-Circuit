`timescale 1ns/100ps			// Setting the Time Unit of Simulation

module tb_cla4;				// 4 bit carry look-ahead adder testbench
reg [3:0] tb_a, tb_b;
reg tb_ci;
wire [3:0] tb_s;
wire tb_co;
wire [4:0] tb_result;

assign tb_result = {tb_co, tb_s};	// Attach tb_co and tb_s.

cla4 U0_cla4(.a(tb_a), .b(tb_b), .ci(tb_ci), .s(tb_s), .co(tb_co));		// 4 bit cla moudle

initial
begin
  tb_a=0; 				tb_b=0; 			tb_ci=0;		// start value	
  #10; tb_a=4'h3; 	tb_b=4'h5;		tb_ci=0;		// change value
  #10; tb_a=4'h7; 	tb_b=4'h9;		tb_ci=0;
  #10; tb_a=4'h5; 	tb_b=4'h5;		tb_ci=1;
  #10; tb_a=4'h8; 	tb_b=4'h7;		tb_ci=1;
  #10; tb_a=4'hf; 	tb_b=4'hf;		tb_ci=0;
  #10; tb_a=4'hf; 	tb_b=4'hf;		tb_ci=1;
  #10; $stop;
end

endmodule
