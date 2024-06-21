module cla8(a, b, ci, s, co); // 8-bit carry look-ahead adder
    input [7:0] a, b;
    input ci; // c in
    output [7:0] s; // sum
    output co; // c out

    wire c1;

    // instance 4-bit carry look-ahead adder 
    cla4 U0_cla4(.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(c1));
    cla4 U1_cla4(.a(a[7:4]), .b(b[7:4]), .ci(c1), .s(s[7:4]), .co(co));

endmodule