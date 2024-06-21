// 32-bit 3 to 1 multiplexer
module mux3_32bit(d0, d1, s, y);
    input [31:0] d0, d1;
    input [1:0] s;
    output reg [31:0] y;

    always @(s, d0, d1) begin
        if (s == 2'b00) 
            y <= 32'h0;
        else if (s == 2'b10)
            y <= d0;
        else if (s == 2'b01)
            y <= d1;
        else 
            y = 32'hx;
    end
endmodule