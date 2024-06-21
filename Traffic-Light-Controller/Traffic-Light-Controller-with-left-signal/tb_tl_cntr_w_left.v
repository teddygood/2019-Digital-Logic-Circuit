`timescale 1ns/100ps		// Setting the Time Unit of Simulation
module tb_tl_cntr_w_left; // testbench traffic light controller with left turn
reg tb_Ta, tb_Tb;		// input Ta, Tb
reg tb_Tal, tb_Tbl;	// input Tal, Tbl
reg tb_clk, tb_reset_n;	// input clock, reset
	
wire [1:0] tb_La, tb_Lb;	// output La, Lb
parameter STEP = 10;		// STEP = 10

// instance traffic light controller with left turn
tl_cntr_w_left U0_tl_cntr_w_left(.clk(tb_clk),.reset_n(tb_reset_n),.Ta(tb_Ta),.Tb(tb_Tb),.Tal(tb_Tal),.Tbl(tb_Tbl),.La(tb_La),.Lb(tb_Lb));

// clock period 10
always #(STEP/2) tb_clk = ~tb_clk;

initial
begin
   tb_clk=0; tb_reset_n=0; tb_Ta=0; tb_Tb=0; tb_Tal=0; tb_Tbl=0; // first value
	#10 tb_reset_n=1; tb_Ta=1;		// change value
	#20 tb_Tal=1;
	#10 tb_Ta=0;	
	#30 tb_Tal=0;  
	#15 tb_Tb=1;		
	#25 tb_Tbl=1;	
	#5  tb_Tb=0; 		
	#30 tb_Tbl=0;    
	#40 $stop; 
end
endmodule
