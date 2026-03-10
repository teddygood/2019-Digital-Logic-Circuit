module bus_addressdecoder(address, sel);
    input [15:0] address;
    output reg [4:0] sel;

    wire [7:0] upper_8bit;
    assign upper_8bit = address[15:8];

    always @(*) begin
        // The top byte chooses DMAC, ALU, operand RAM, instruction RAM, or result RAM respectively.
        case (upper_8bit)
            8'h00: sel = 5'b10000;
            8'h01: sel = 5'b01000;
            8'h02: sel = 5'b00100;
            8'h03: sel = 5'b00010;
            8'h04: sel = 5'b00001;
            default: sel = 5'b00000;
        endcase
    end
endmodule
