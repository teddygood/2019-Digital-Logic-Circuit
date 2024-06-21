module _dff_r(clk, reset_n, d, q); // Asynchronous Resettable D flip flop
    input clk, reset_n, d; // input clock, reset, d
    output q; // output q
    reg q;
    
    always @(posedge clk or negedge reset_n) begin // clock rising edge or reset = 0
        if (reset_n == 0)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule