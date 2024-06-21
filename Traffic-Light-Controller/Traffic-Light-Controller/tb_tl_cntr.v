`timescale 1ns/100ps		// Setting the Time Unit of Simulation
module tb_tl_cntr;		// testbench traffic light controller
reg tb_Ta, tb_Tb;			// input Ta, Tb
reg tb_clk, tb_reset_n;	// input clock, reset

wire [1:0] tb_La, tb_Lb;	// output La, Lb
parameter STEP = 10;			// STEP = 10

// instance traffic light controller
tl_cntr U0_tl_cntr(.clk(tb_clk),.reset_n(tb_reset_n),.Ta(tb_Ta),.Tb(tb_Tb),.La(tb_La),.Lb(tb_Lb));

// clock period 10
always #(STEP/2) tb_clk = ~tb_clk;

initial
begin
   tb_clk=0; tb_reset_n=0; tb_Ta=0; tb_Tb=0; // first value 
   #10; tb_reset_n=1; 		// change value
   #40; tb_Ta=1;
	#20; tb_Ta=0;
	#40; tb_Tb=1;
	#60; tb_Tb=0;
   #40; $stop;
end
endmodule

