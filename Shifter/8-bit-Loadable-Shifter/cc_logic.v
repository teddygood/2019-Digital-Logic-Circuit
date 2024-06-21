module cc_logic(op,shamt,d_in,d_out,d_next);	// Combinational Circuit Logic
input [2:0] op;	// opcode
input [1:0] shamt;	// shift amount
input [7:0] d_in;
input [7:0] d_out;
output reg [7:0] d_next;

wire [7:0] d_lsl;		// LSL8 output d_lsl
wire [7:0] d_lsr;		// LSR8 output d_lsr
wire [7:0] d_asr;		// ASR8 output d_asr

// binary encoding
parameter NOP = 3'b000;
parameter LOAD = 3'b001;
parameter LSL = 3'b010;
parameter LSR = 3'b011;
parameter ASR = 3'b100;

always @ (op,shamt,d_in,d_out,d_lsl,d_lsr,d_asr)
begin
case(op)
NOP : d_next <= d_out;
LOAD : d_next <= d_in;
LSL : d_next <= d_lsl;
LSR : d_next <= d_lsr;
ASR : d_next <= d_asr;
default d_next <= 3'bx; // op = 3'b101 / 3'b110 / 3'b111 -> d_next = 3b'x
endcase
end

LSL8 U0_LSL8(.d_in(d_out), .shamt(shamt), .d_out(d_lsl)); // instance 8-bit logical shift left
LSR8 U1_LSR8(.d_in(d_out), .shamt(shamt), .d_out(d_lsr)); // instance 8-bit logical shift right 
ASR8 U2_ASR8(.d_in(d_out), .shamt(shamt), .d_out(d_asr)); // instance 8-bit arithmetic shift right

endmodule
