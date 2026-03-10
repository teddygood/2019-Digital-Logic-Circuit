module bus_arbiter(clk, reset_n, m0_req, m1_req, m0_grant, m1_grant);
    input clk, reset_n;
    input m0_req, m1_req;
    output reg m0_grant, m1_grant;

    reg [1:0] state, next_state;

    parameter NO_GRANT = 2'b00;
    parameter M0_GRANT = 2'b01;
    parameter M1_GRANT = 2'b10;

    always @(*) begin
        // M0 wins ties when both masters request from an idle bus; otherwise the current owner can keep control.
        case (state)
            NO_GRANT: begin
                case ({m0_req, m1_req})
                    2'b00: next_state = NO_GRANT;
                    2'b01: next_state = M1_GRANT;
                    2'b10: next_state = M0_GRANT;
                    2'b11: next_state = M0_GRANT;
                    default: next_state = NO_GRANT;
                endcase
            end
            M0_GRANT: begin
                case ({m0_req, m1_req})
                    2'b00: next_state = NO_GRANT;
                    2'b01: next_state = M1_GRANT;
                    2'b10: next_state = M0_GRANT;
                    2'b11: next_state = M0_GRANT;
                    default: next_state = M0_GRANT;
                endcase
            end
            M1_GRANT: begin
                case ({m0_req, m1_req})
                    2'b00: next_state = NO_GRANT;
                    2'b01: next_state = M1_GRANT;
                    2'b10: next_state = M0_GRANT;
                    2'b11: next_state = M1_GRANT;
                    default: next_state = M1_GRANT;
                endcase
            end
            default: next_state = NO_GRANT;
        endcase
    end

    always @(posedge clk or negedge reset_n) begin
        if (reset_n == 1'b0)
            state <= NO_GRANT;
        else
            state <= next_state;
    end

    always @(*) begin
        // The grant outputs are Moore-style signals derived directly from the current arbitration state.
        case (state)
            NO_GRANT: begin
                m0_grant = 1'b1;
                m1_grant = 1'b0;
            end
            M0_GRANT: begin
                m0_grant = 1'b1;
                m1_grant = 1'b0;
            end
            M1_GRANT: begin
                m0_grant = 1'b0;
                m1_grant = 1'b1;
            end
            default: begin
                m0_grant = 1'b1;
                m1_grant = 1'b0;
            end
        endcase
    end
endmodule
