`timescale 1ns/100ps

module tb_shifter8;		// testbench 8-bit shifter
reg tb_clk, tb_reset_n;	// input clock, reset
reg [2:0] tb_op;		// 3-bit opcode (operation code)
reg [1:0] tb_shamt;	// input shift amount
reg [7:0] tb_d_in;	// input tb_d_in
wire [7:0] tb_d_out; // output tb_d_out
	
shifter8 U0_shifter8(.clk(tb_clk), .reset_n(tb_reset_n), .op(tb_op), .shamt(tb_shamt), .d_in(tb_d_in), .d_out(tb_d_out));
// instance 8-bit shifter

parameter NOP=3'b000;
parameter LOAD=3'b001;
parameter LSL=3'b010;
parameter LSR=3'b011;
parameter ASR=3'b100;

parameter STEP = 10;	
always #(STEP/2) tb_clk = ~tb_clk; // clock period 10
		
initial
begin
tb_clk=1; tb_op=NOP;  tb_d_in=8'b0; tb_reset_n=1'b0; tb_shamt=2'b00; // initial value
#13	tb_reset_n=1; 	// change value
#10 	tb_op=LOAD; tb_d_in=8'b10001000;
#10	tb_op=ASR; tb_shamt=2'b11;
#10	tb_op=LSR; tb_shamt=2'b10;
#10	tb_op=LSL; tb_shamt=2'b11;
#15	tb_reset_n=0;
#20	$stop;
end
endmodule
