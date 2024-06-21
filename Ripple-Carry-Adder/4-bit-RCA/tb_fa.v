`timescale 1ns/100ps			// Setting the Time Unit of Simulation

module tb_fa;					// full adder testbench
reg a, b, ci;
wire s, co;
  fa U0_fa(.a(a), .b(b), .ci(ci), .s(s), .co(co));		// full adder module

initial begin
  ci=1'b0; a=1'b0; b=1'b0; 		// Start value
  #10 ci=1'b0; a=1'b0; b=1'b1;	// Change value
  #10 ci=1'b0; a=1'b1; b=1'b0;
  #10 ci=1'b0; a=1'b1; b=1'b1;
  #10 ci=1'b1; a=1'b0; b=1'b0;
  #10 ci=1'b1; a=1'b0; b=1'b1;
  #10 ci=1'b1; a=1'b1; b=1'b0;
  #10 ci=1'b1; a=1'b1; b=1'b1;   
  #10	$stop;
end
endmodule
