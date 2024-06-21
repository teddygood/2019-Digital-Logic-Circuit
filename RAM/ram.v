module ram(clk, cen, wen, addr, din, dout);
input clk, cen, wen;
input [4:0] addr;
input [31:0] din;
output reg [31:0] dout;
reg [31:0] mem [0:31];

integer i;

// initialize
initial 
begin
	for(i = 0; i<32; i = i+1)
		mem[i] <= 5'b0;
end

always @(posedge clk)
	begin
		if(cen == 1 && wen ==1) 		
			begin 
			mem[addr] <= din;
			dout <= 32'b0; 
			end
		else if(cen ==1 && wen ==0)
			dout <= mem[addr]; 
		else
			dout <= 32'b0;						
	end

endmodule
