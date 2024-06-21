module bus_addr(s_address, s0_sel, s1_sel); // Address Decoder module
    input [7:0] s_address;
    output reg s0_sel, s1_sel;

    always @(s_address) begin
        if ((s_address >= 8'h00) && (s_address < 8'h20)) // 0x00 <= s_address < 0x20
            {s0_sel, s1_sel} <= 2'b10; // s0_sel = 1, s1_sel = 0
        else if ((s_address >= 8'h20) && (s_address < 8'h40)) // 0x20 <= s_address < 0x40 
            {s0_sel, s1_sel} <= 2'b01; // s0_sel = 0, s1_sel = 1
        else
            {s0_sel, s1_sel} <= 2'b00;
    end

    /*
    always @(s_address) begin
        if (s_address[7:4] == 4'h0 || s_address[7:4] == 4'h1) // upper 4-bit check
            {s0_sel, s1_sel} = 2'b10;
        else if (s_address[7:4] == 4'h2 || s_address[7:4] == 4'h3) // upper 4-bit check
            {s0_sel, s1_sel} = 2'b01;
        else
            {s0_sel, s1_sel} = 2'b00;
    end
    */
endmodule