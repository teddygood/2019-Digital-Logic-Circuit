module ALU_Top(clk, reset_n, s_sel, s_wr, s_addr, s_din, s_dout, s_interrupt);
    input clk, reset_n, s_sel, s_wr;
    input [15:0] s_addr;
    input [31:0] s_din;
    output [31:0] s_dout;
    output s_interrupt;

    wire [3:0] wAddr, rAddr;
    wire re, we;
    wire [31:0] wData, rData;

    wire o_rd_en, o_wr_en;
    wire [31:0] o_din, o_dout;
    wire o_full, o_empty, o_wr_ack, o_wr_err, o_rd_ack, o_rd_err;
    wire [3:0] o_data_count;

    wire r_rd_en, r_wr_en;
    wire [31:0] r_din, r_dout;
    wire r_full, r_empty, r_wr_ack, r_wr_err, r_rd_ack, r_rd_err;
    wire [4:0] r_data_count;

    wire alu_begin, alu_done;
    wire operand_state, instruction_state, need_pop;
    wire [4:0] alu_state;
    wire [31:0] operand1, operand2, result2, result1, RESULT;

    // Operand registers are memory-mapped so the host can preload ALU sources directly.
    ALU_registerfile_2 operand_register_file(
        .clk(clk),
        .reset_n(reset_n),
        .wAddr(wAddr),
        .wData(wData),
        .we(we),
        .re(re),
        .rAddr(rAddr),
        .rData(rData)
    );

    fifo instruction_fifo(
        .clk(clk),
        .reset_n(reset_n),
        .rd_en(o_rd_en),
        .wr_en(o_wr_en),
        .d_in(o_din),
        .d_out(o_dout),
        .full(o_full),
        .empty(o_empty),
        .wr_ack(o_wr_ack),
        .wr_err(o_wr_err),
        .rd_ack(o_rd_ack),
        .rd_err(o_rd_err),
        .data_count(o_data_count)
    );

    DMAC_fifo result_fifo(
        .clk(clk),
        .reset_n(reset_n),
        .rd_en(r_rd_en),
        .wr_en(r_wr_en),
        .d_in(r_din),
        .d_out(r_dout),
        .full(r_full),
        .empty(r_empty),
        .wr_ack(r_wr_ack),
        .wr_err(r_wr_err),
        .rd_ack(r_rd_ack),
        .rd_err(r_rd_err),
        .data_count(r_data_count)
    );

    // ALU_slave implements the register map, while ALU_alu_top consumes queued instructions and operands.
    ALU_slave slave_if(
        .clk(clk),
        .reset_n(reset_n),
        .s_sel(s_sel),
        .s_wr(s_wr),
        .s_addr(s_addr),
        .s_din(s_din),
        .o_wr_ack(o_wr_ack),
        .o_wr_err(o_wr_err),
        .r_rd_ack(r_rd_ack),
        .r_rd_err(r_rd_err),
        .r_dout(r_dout),
        .instruction_empty(o_empty),
        .alu_done(alu_done),
        .o_din(o_din),
        .o_push(o_wr_en),
        .r_pop(r_rd_en),
        .we(we),
        .wAddr(wAddr),
        .wData(wData),
        .s_dout(s_dout),
        .s_interrupt(s_interrupt),
        .alu_begin(alu_begin),
        .operand_state(operand_state),
        .instruction_state(instruction_state),
        .need_pop(need_pop),
        .RESULT(RESULT)
    );

    ALU_alu_top execute_if(
        .clk(clk),
        .reset_n(reset_n),
        .alu_begin(alu_begin),
        .o_empty(o_empty),
        .o_rd_err(o_rd_err),
        .o_rd_ack(o_rd_ack),
        .o_dout(o_dout),
        .r_full(r_full),
        .r_wr_err(r_wr_err),
        .r_wr_ack(r_wr_ack),
        .rData(rData),
        .o_pop(o_rd_en),
        .r_push(r_wr_en),
        .alu_done(alu_done),
        .re(re),
        .rAddr(rAddr),
        .wData(r_din),
        .state(alu_state),
        .operand1(operand1),
        .operand2(operand2),
        .result2(result2),
        .result1(result1)
    );
endmodule
