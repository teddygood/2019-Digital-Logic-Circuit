module ram(
input           clk,      
input           cen,      
input           wen,      
input   [5:0]   addr,
input   [31:0]  din,
output  [31:0]  dout
);
    reg [31:0] mem [0:63];
    reg [31:0] dout_reg;


	integer i;
	initial 
	begin
		for(i = 0; i<32; i = i+1)
			mem[i] <= 5'b0;
	end
	
    always @(posedge clk) begin
        if(cen == 1'b1 && wen == 1'b1) begin//write
            mem[addr] <= din;
            dout_reg <= 32'd0;
        end
        else if(cen == 1'b1) begin //read
            dout_reg <= mem[addr];
        end
        else begin
            dout_reg <= 32'd0;
        end
    end

    assign dout = dout_reg;

endmodule 