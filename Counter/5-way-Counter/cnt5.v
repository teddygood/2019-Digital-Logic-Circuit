module cnt5(cnt, clk, reset_n, inc); // 5-way counter
    input clk, reset_n, inc; // input clock, reset, increase/decrease signal
    output [2:0] cnt; // current state

    // Encoded state
    parameter zero = 3'b000;
    parameter one = 3'b001;
    parameter two = 3'b010;
    parameter three = 3'b011;
    parameter four = 3'b100;

    // Sequential circuit part
    reg [2:0] cnt; // current state
    reg [2:0] next_cnt; // next state

    always @(posedge clk or negedge reset_n) begin // clock rising edge or reset falling edge 
        if (reset_n == 1'b0)
            cnt <= zero;
        else
            cnt <= next_cnt;
    end

    always @(inc or cnt) begin // if inc or cnt change
        case ({cnt, inc})
            {zero, 1'b0} : next_cnt <= four;
            {zero, 1'b1} : next_cnt <= one;
            {one, 1'b0} : next_cnt <= zero;
            {one, 1'b1} : next_cnt <= two;
            {two, 1'b0} : next_cnt <= one;
            {two, 1'b1} : next_cnt <= three;
            {three, 1'b0} : next_cnt <= two;
            {three, 1'b1} : next_cnt <= four;
            {four, 1'b0} : next_cnt <= three;
            {four, 1'b1} : next_cnt <= zero;
            default : next_cnt <= 3'bx; // if cnt == 3'b101 / cnt == 3'b110 / cnt == 3'b111 -> next_cnt == 3'bx
        endcase
    end
endmodule