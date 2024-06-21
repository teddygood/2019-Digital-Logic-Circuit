module os_logic(state, d_in, d_out); // output state logic
    // binary encoding
    parameter IDLE_STATE = 3'b000;
    parameter LOAD_STATE = 3'b001;
    parameter INC_STATE = 3'b010;
    parameter INC2_STATE = 3'b011;
    parameter DEC_STATE = 3'b100;
    parameter DEC2_STATE = 3'b101;

    input [2:0] state;
    input [7:0] d_in;
    output [7:0] d_out;

    reg [7:0] d_out;
    wire [7:0] d_inc; // increase
    wire [7:0] d_dec; // decrease 

    always @(state) begin
        case (state)
            IDLE_STATE: d_out <= 8'b00000000; // IDLE state
            LOAD_STATE: d_out <= d_in; // LOAD state
            INC_STATE: d_out <= d_inc; // INC state
            INC2_STATE: d_out <= d_inc; // INC2 state
            DEC_STATE: d_out <= d_dec; // DEC state
            DEC2_STATE: d_out <= d_dec; // DEC2 state
            default: d_out <= 8'bx; // state = 3'b110 / 3b'111 -> d_out
        endcase
    end

    // instance 8-bit carry look-ahead adder/subtracter 
    cla8 U0_cla8(.a(d_out), .b(8'b00000001), .ci(1'b0), .s(d_inc));
    cla8 U1_cla8(.a(d_out), .b(8'b11111111), .ci(1'b0), .s(d_dec));

endmodule