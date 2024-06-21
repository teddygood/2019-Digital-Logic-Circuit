// 1-bit 2 to 1 multiplexer
module mux2(d0, d1, s, y);
    input d0, d1;
    input s;
    output reg y;

    always @(s, d0, d1) begin
        if (s == 0)
            y <= d0;
        else
            y <= d1;
    end
endmodule