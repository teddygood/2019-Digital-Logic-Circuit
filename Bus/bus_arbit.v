module bus_arbit(m0_req, m1_req, reset_n, clk, state);
    input clk, reset_n, m0_req, m1_req; // clock, reset signal, m0_request, m1_request
    output reg [1:0] state;
    reg [1:0] next_state;

    // Encoding states
    parameter M0_GRANT = 2'b01;
    parameter M1_GRANT = 2'b10;

    always @(posedge clk or negedge reset_n) begin // reset_n, clock
        if (!reset_n) // reset_n == 0
            state <= M0_GRANT;
        else
            state <= next_state;                     
    end

    always @(m0_req, m1_req) begin 
        if ((m0_req == 0 && m1_req == 0) || m0_req == 1)
            next_state <= M0_GRANT; 
        else if ((m0_req == 0) && (m1_req == 1))
            next_state <= M1_GRANT;         
        else if (m1_req == 1)
            next_state <= M1_GRANT;                             
        else if (m1_req == 0)
            next_state <= M0_GRANT;                             
    end

endmodule