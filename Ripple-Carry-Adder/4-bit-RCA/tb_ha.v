`timescale 1ns/100ps		// Setting the Time Unit of Simulation

module tb_ha;				// half adder testbench 
reg a;
reg b;
wire s;
wire co;

  ha U0_ha(.a(a), .b(b), .s(s), .co(co));		// half adder module

initial begin
  a=1'b0; b=1'b0;			// Start value
  #10 a=1'b0; b=1'b1;	// Change value
  #10 a=1'b1; b=1'b0;
  #10 a=1'b1; b=1'b1;
  #10 $stop;
end
endmodule
