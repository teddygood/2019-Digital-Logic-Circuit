module cntr8(clk, reset_n, inc, load, d_in, d_out, o_state); // 8-bit loadable up/down counter
    input clk, reset_n, inc, load;
    input [7:0] d_in;
    output [7:0] d_out;
    output [2:0] o_state; // verification state

    wire [2:0] next_state;
    wire [2:0] state;

    assign o_state = state;

    _register3_r U0_register3_r(.clk(clk), .reset_n(reset_n), .d(next_state), .q(state)); // 3-bit register 
    ns_logic U1_ns_logic(.load(load), .inc(inc), .state(state), .next_state(next_state)); // next state logic
    os_logic U2_os_logic(.state(state), .d_in(d_in), .d_out(d_out)); // output logic
endmodule