module ns_logic(load, inc, state, next_state);
    // binary encoding
    parameter IDLE_STATE = 3'b000;
    parameter LOAD_STATE = 3'b001;
    parameter INC_STATE = 3'b010;
    parameter INC2_STATE = 3'b011;
    parameter DEC_STATE = 3'b100;
    parameter DEC2_STATE = 3'b101;

    input load, inc;
    input [2:0] state;
    output [2:0] next_state;
    reg [2:0] next_state;

    always @(load, inc, state) begin
        case (state)
            IDLE_STATE: // 3'b000
            begin
                if (load == 1'b1)
                    next_state <= LOAD_STATE;
                else if (inc == 1'b1)
                    next_state <= INC_STATE;
                else if (inc == 1'b0)
                    next_state <= DEC_STATE;
                else
                    next_state <= state;
            end
            LOAD_STATE: // 3'b001
            begin
                if (load == 1'b1)
                    next_state <= LOAD_STATE; // load state
                else if (inc == 1'b1)
                    next_state <= INC_STATE; // increase state
                else if (inc == 1'b0)
                    next_state <= DEC_STATE; // decrease state
                else
                    next_state <= state; // default
            end
            INC_STATE: // 3'b010
            begin
                if (load == 1'b1)
                    next_state <= LOAD_STATE; // load state
                else if (inc == 1'b1)
                    next_state <= INC2_STATE; // increase2 state
                else if (inc == 1'b0)
                    next_state <= DEC_STATE; // decrease state
                else
                    next_state <= state; // default
            end
            INC2_STATE: // 3'b011
            begin
                if (load == 1'b1)
                    next_state <= LOAD_STATE; // load state
                else if (inc == 1'b1)
                    next_state <= INC_STATE; // increase state
                else if (inc == 1'b0)
                    next_state <= DEC_STATE; // decrease state
                else
                    next_state <= state; // default
            end
            DEC_STATE: // 3'b100
            begin
                if (load == 1'b1)
                    next_state <= LOAD_STATE; // load state
                else if (inc == 1'b1)
                    next_state <= INC_STATE; // increase state
                else if (inc == 1'b0)
                    next_state <= DEC2_STATE; // decrease2 state
                else
                    next_state <= state; // default
            end
            DEC2_STATE: // 3'b101
            begin
                if (load == 1'b1)
                    next_state <= LOAD_STATE; // load state
                else if (inc == 1'b1)
                    next_state <= INC_STATE; // increase state
                else if (inc == 1'b0)
                    next_state <= DEC_STATE; // decrease state
                else
                    next_state <= state; // default
            end
            default: next_state = 3'bx; // state = 3'b110 / 3'b111 -> next_state = 3'bx
        endcase
    end
endmodule