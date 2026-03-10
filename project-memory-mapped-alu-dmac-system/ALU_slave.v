module ALU_slave(
    clk,
    reset_n,
    s_sel,
    s_wr,
    s_addr,
    s_din,
    o_wr_ack,
    o_wr_err,
    r_rd_ack,
    r_rd_err,
    r_dout,
    instruction_empty,
    alu_done,
    o_din,
    o_push,
    r_pop,
    we,
    wAddr,
    wData,
    s_dout,
    s_interrupt,
    alu_begin,
    operand_state,
    instruction_state,
    need_pop,
    RESULT
);
    input clk, reset_n, s_sel, s_wr;
    input [15:0] s_addr;
    input [31:0] s_din;
    input o_wr_ack, o_wr_err, r_rd_ack, r_rd_err, instruction_empty, alu_done;
    input [31:0] r_dout;

    output reg [31:0] o_din, wData, s_dout, RESULT;
    output reg o_push, r_pop, we, s_interrupt, alu_begin, operand_state, instruction_state, need_pop;
    output reg [3:0] wAddr;

    reg [31:0] OPERATION_START;
    reg [31:0] INTERRUPT;
    reg [31:0] INTERRUPT_ENABLE;
    reg [31:0] INSTRUCTION;
    reg [31:0] ALU_STATUS;
    reg [31:0] OPERAND [0:15];
    integer i;

    parameter Waiting = 2'b00;
    parameter Executing = 2'b01;
    parameter Done = 2'b10;
    parameter Fault = 2'b11;
    parameter before_operand = 1'b0;
    parameter after_operand = 1'b1;
    parameter before_instruction = 1'b0;
    parameter after_instruction = 1'b1;

    always @(posedge clk or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            OPERATION_START = 32'h0000_0000;
            INTERRUPT = 32'h0000_0000;
            INTERRUPT_ENABLE = 32'h0000_0000;
            INSTRUCTION = 32'h0000_0000;
            RESULT = 32'h0000_0000;
            ALU_STATUS = 32'h0000_0000;
            for (i = 0; i < 16; i = i + 1)
                OPERAND[i] = 32'h0000_0000;
            o_din = 32'h0000_0000;
            o_push = 1'b0;
            r_pop = 1'b0;
            we = 1'b0;
            wAddr = 4'b0000;
            wData = 32'h0000_0000;
            s_dout = 32'h0000_0000;
            s_interrupt = 1'b0;
            alu_begin = 1'b0;
            operand_state = before_operand;
            instruction_state = before_instruction;
            need_pop = 1'b0;
        end else begin
            // Operand writes and instruction pushes are exposed as one-cycle pulses to the submodules.
            if (operand_state == after_operand) begin
                we = 1'b0;
                operand_state = before_operand;
            end

            if (instruction_state == after_instruction) begin
                if (o_wr_ack == 1'b1) begin
                    o_push = 1'b0;
                    o_din = 32'h0000_0000;
                    instruction_state = before_instruction;
                end else if (o_wr_err == 1'b1) begin
                    o_push = 1'b0;
                    o_din = 32'h0000_0000;
                    instruction_state = before_instruction;
                    ALU_STATUS[1:0] = Fault;
                end
            end

            if (r_pop == 1'b1)
                r_pop = 1'b0;

            if (r_rd_err == 1'b1)
                ALU_STATUS[1:0] = Fault;

            if ({s_sel, s_wr} == 2'b11) begin
                case (s_addr[7:0])
                    8'h00: OPERATION_START = {31'h0, s_din[0]};
                    8'h01: begin
                        INTERRUPT = {31'h0, s_din[0]};
                        if (s_din[0] == 1'b0) begin
                            OPERATION_START[0] = 1'b0;
                            alu_begin = 1'b0;
                            if (ALU_STATUS[1:0] == Done)
                                ALU_STATUS[1:0] = Waiting;
                        end
                    end
                    8'h02: INTERRUPT_ENABLE = {31'h0, s_din[0]};
                    8'h03: begin
                        // Writing INSTRUCTION mirrors the word into the FIFO so execution can happen later.
                        INSTRUCTION = s_din;
                        o_din = s_din;
                        o_push = 1'b1;
                        instruction_state = after_instruction;
                    end
                    8'h10, 8'h11, 8'h12, 8'h13, 8'h14, 8'h15, 8'h16, 8'h17,
                    8'h18, 8'h19, 8'h1A, 8'h1B, 8'h1C, 8'h1D, 8'h1E, 8'h1F: begin
                        OPERAND[s_addr[3:0]] = s_din;
                        wData = s_din;
                        wAddr = s_addr[3:0];
                        we = 1'b1;
                        operand_state = after_operand;
                    end
                    default: ;
                endcase
            end else if ({s_sel, s_wr} == 2'b10) begin
                case (s_addr[7:0])
                    8'h00: s_dout = OPERATION_START;
                    8'h01: s_dout = INTERRUPT;
                    8'h02: s_dout = INTERRUPT_ENABLE;
                    8'h03: s_dout = INSTRUCTION;
                    8'h04: begin
                        s_dout = r_dout;
                        RESULT = r_dout;
                        r_pop = 1'b1;
                    end
                    8'h05: s_dout = ALU_STATUS;
                    8'h10, 8'h11, 8'h12, 8'h13, 8'h14, 8'h15, 8'h16, 8'h17,
                    8'h18, 8'h19, 8'h1A, 8'h1B, 8'h1C, 8'h1D, 8'h1E, 8'h1F:
                        s_dout = OPERAND[s_addr[3:0]];
                    default: s_dout = 32'h0000_0000;
                endcase
            end else begin
                s_dout = 32'h0000_0000;
            end

            // OPERATION_START transitions the ALU from Waiting to Executing once at least one instruction exists.
            if ((ALU_STATUS[1:0] != Fault) && (OPERATION_START[0] == 1'b1) && (ALU_STATUS[1:0] == Waiting)) begin
                if (instruction_empty == 1'b1)
                    ALU_STATUS[1:0] = Fault;
                else begin
                    alu_begin = 1'b1;
                    ALU_STATUS[1:0] = Executing;
                end
            end

            if ((ALU_STATUS[1:0] == Executing) && (alu_done == 1'b1)) begin
                alu_begin = 1'b0;
                ALU_STATUS[1:0] = Done;
                INTERRUPT[0] = 1'b1;
            end

            // Interrupt output is just the latched status bit gated by the enable register.
            if (INTERRUPT_ENABLE[0] == 1'b1 && INTERRUPT[0] == 1'b1)
                s_interrupt = 1'b1;
            else
                s_interrupt = 1'b0;
        end
    end
endmodule
