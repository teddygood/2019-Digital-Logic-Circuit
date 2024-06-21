module mx2_32bits(d0, d1, s, y); // 32-bit 2-to-1 Multiplexer
    input [31:0] d0, d1;
    input s; // selection signal
    output [31:0] y;

    assign y = (s == 1'b0) ? d0 : d1;
    // if(s==0) y=d0;
    // else y=d1;

endmodule