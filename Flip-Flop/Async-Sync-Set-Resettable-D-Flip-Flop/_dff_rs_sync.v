module _dff_rs_sync(clk, set_n, reset_n, d, q); // Synchronous Set/Resettable D flip flop
    input clk, set_n, reset_n, d; // input clock, set, reset
    output q; // output q
    reg q;

    always @(posedge clk) begin // while (posedge clock)
        if (reset_n == 0)
            q <= 1'b0;
        else if (set_n == 0)
            q <= 1'b1;
        else
            q <= d;
    end
endmodule