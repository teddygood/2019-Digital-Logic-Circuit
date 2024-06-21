module _dff_rs_async(clk, set_n, reset_n, d, q); // Asynchronous Set/Resettable D flip flop
    input clk, set_n, reset_n, d; // input clock, set, reset, d
    output q; // output q
    reg q;

    always @(posedge clk or negedge set_n or negedge reset_n) begin // while (posedge clock || negedge set || negedge reset)
        if (reset_n == 0) 
            q <= 1'b0;
        else if (set_n == 0) 
            q <= 1'b1;
        else 
            q <= d;
    end
endmodule