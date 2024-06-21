`timescale 1ns/100ps

module tb_Register_file;	// testbench register file
reg tb_clk, tb_reset_n, tb_we; // clk(clock), reset_n(reset signal), we(write enable)
reg [2:0] tb_wAddr, tb_rAddr; 
reg [31:0] tb_wData; 
wire [31:0] tb_rData; 

// instance Register file 	
Register_file I0_Register_file(.clk(tb_clk), .reset_n(tb_reset_n), .wAddr(tb_wAddr), .wData(tb_wData), .we(tb_we), .rAddr(tb_rAddr), .rData(tb_rData));
	 
parameter temp = 10;

always #(temp/2) tb_clk = ~tb_clk;	// clock period 10

initial
begin
		tb_clk=0; tb_reset_n=1'b0; tb_we=1'b0; tb_wAddr=3'b0; tb_wData=32'h0; tb_rAddr=3'b0;
		#7		tb_reset_n=1'b1; tb_we=1'b1;
		#10   tb_wAddr=3'b001; tb_wData=32'h00000001;
      #10   tb_wAddr=3'b010; tb_wData=32'h00000002;
      #10   tb_wAddr=3'b011; tb_wData=32'h00000003;
      #10   tb_wAddr=3'b100; tb_wData=32'h00000004;
      #10   tb_wAddr=3'b101; tb_wData=32'h00000005;
      #10   tb_wAddr=3'b110; tb_wData=32'h00000006;
      #10   tb_wAddr=3'b111; tb_wData=32'h00000007;
      #10   tb_we=1'b0;
      #20   tb_rAddr=3'b001;
      #10   tb_rAddr=3'b010;
      #10   tb_rAddr=3'b011;
      #10   tb_rAddr=3'b100;
      #10   tb_rAddr=3'b101;
      #10   tb_rAddr=3'b110;
      #10   tb_rAddr=3'b111;
		#20	$stop;
	end
	endmodule