`timescale 1ns/100ps 
module tb_ram;
reg clk, cen, wen;
reg [4:0] addr;
reg [31:0] din;
wire [31:0] dout;

ram U0_ram(.clk(clk), .cen(cen), .wen(wen), .addr(addr), .din(din), .dout(dout)); 

always
	begin
		clk=1; #5; clk=0; #5; // clock period 10
	end


initial
begin
	cen = 0; wen = 0; addr = 8'b0; din = 32'b0; // initialize value
	#10; cen = 1; wen = 1; addr = 8'h01; din = 32'h123 ;	// write value
	#10 addr = 8'h02 ; din = 32'h456 ;
	#10 addr = 8'h03 ; din = 32'h798 ;
	#10 addr = 8'h04 ; din = 32'h4;
	#10 addr = 8'h05 ; din = 32'h5;
	#10 addr = 8'h01 ; wen = 0; 			// read value
	#10 addr = 8'h02 ;
	#10 addr = 8'h03 ;
	#10 addr = 8'h04 ;
	#10 addr = 8'h05 ;
	#10 addr = 8'h06 ;
	#10 addr = 8'h07 ;
	#10 addr = 8'h08 ;
	#10 $stop;
end
endmodule
