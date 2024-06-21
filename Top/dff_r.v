// D-filp flop with reset signal
module dff_r(clk, reset_n, d, q);
input clk, reset_n; 
input [4:0] d;
output reg [4:0] q;

always@(posedge clk or negedge reset_n)
begin
	if(reset_n == 0)
		q<= 5'b0;
	else 				
		q <= d;
end
endmodule
