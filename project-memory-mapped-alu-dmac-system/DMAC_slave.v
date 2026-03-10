module DMAC_slave(
    clk,
    reset_n,
    s_sel,
    s_wr,
    s_address,
    s_din,
    m_end,
    empty,
    full,
    wr_ack,
    wr_err,
    s_dout,
    s_interrupt,
    m_begin,
    push_1,
    push_2,
    push_3,
    data_1,
    data_2,
    data_3
);
    input clk, reset_n, s_sel, s_wr, m_end, empty, full, wr_ack, wr_err;
    input [15:0] s_address;
    input [31:0] s_din;
    output reg [31:0] s_dout, data_1, data_2, data_3;
    output reg s_interrupt, m_begin, push_1, push_2, push_3;

    reg [31:0] OPERATION_START, INTERRUPT, INTERRUPT_ENABLE;
    reg [31:0] SOURCE_ADDRESS, DESTINATION_ADDRESS, DATA_SIZE, DESCRIPTOR_PUSH, OPERATION_MODE, DMA_STATUS;

    parameter Waiting = 2'b00;
    parameter Executing = 2'b01;
    parameter Done = 2'b10;
    parameter Fault = 2'b11;

    always @(posedge clk or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            OPERATION_START = 32'h0000_0000;
            INTERRUPT = 32'h0000_0000;
            INTERRUPT_ENABLE = 32'h0000_0000;
            SOURCE_ADDRESS = 32'h0000_0000;
            DESTINATION_ADDRESS = 32'h0000_0000;
            DATA_SIZE = 32'h0000_0001;
            DESCRIPTOR_PUSH = 32'h0000_0000;
            OPERATION_MODE = 32'h0000_0000;
            DMA_STATUS = 32'h0000_0000;
            s_dout = 32'h0000_0000;
            s_interrupt = 1'b0;
            m_begin = 1'b0;
            push_1 = 1'b0;
            push_2 = 1'b0;
            push_3 = 1'b0;
            data_1 = 32'h0000_0000;
            data_2 = 32'h0000_0000;
            data_3 = 32'h0000_0000;
        end else begin
            // Descriptor push signals are one-shot writes into the three FIFOs.
            if (push_1 == 1'b1) push_1 = 1'b0;
            if (push_2 == 1'b1) push_2 = 1'b0;
            if (push_3 == 1'b1) push_3 = 1'b0;

            if ({s_sel, s_wr} == 2'b11) begin
                case (s_address[7:0])
                    8'h00: OPERATION_START = {31'h0, s_din[0]};
                    8'h01: begin
                        INTERRUPT = {31'h0, s_din[0]};
                        if (s_din[0] == 1'b0) begin
                            OPERATION_START[0] = 1'b0;
                            m_begin = 1'b0;
                            if (DMA_STATUS[1:0] == Done)
                                DMA_STATUS[1:0] = Waiting;
                        end
                    end
                    8'h02: INTERRUPT_ENABLE = {31'h0, s_din[0]};
                    8'h03: SOURCE_ADDRESS = {16'h0000, s_din[15:0]};
                    8'h04: DESTINATION_ADDRESS = {16'h0000, s_din[15:0]};
                    8'h05: DATA_SIZE = s_din;
                    8'h06: DESCRIPTOR_PUSH = {31'h0, s_din[0]};
                    8'h07: OPERATION_MODE = s_din;
                    default: ;
                endcase
            end else if ({s_sel, s_wr} == 2'b10) begin
                case (s_address[7:0])
                    8'h00: s_dout = OPERATION_START;
                    8'h01: s_dout = INTERRUPT;
                    8'h02: s_dout = INTERRUPT_ENABLE;
                    8'h03: s_dout = SOURCE_ADDRESS;
                    8'h04: s_dout = DESTINATION_ADDRESS;
                    8'h05: s_dout = DATA_SIZE;
                    8'h06: s_dout = DESCRIPTOR_PUSH;
                    8'h07: s_dout = OPERATION_MODE;
                    8'h08: s_dout = DMA_STATUS;
                    default: s_dout = 32'h0000_0000;
                endcase
            end else begin
                s_dout = 32'h0000_0000;
            end

            if (wr_err == 1'b1)
                DMA_STATUS[1:0] = Fault;

            if (DESCRIPTOR_PUSH[0] == 1'b1) begin
                // A descriptor is valid only when all three FIFOs can receive the tuple together.
                if (DATA_SIZE != 32'h0000_0001)
                    DMA_STATUS[1:0] = Fault;
                else if (full == 1'b1)
                    DMA_STATUS[1:0] = Fault;
                else begin
                    push_1 = 1'b1;
                    push_2 = 1'b1;
                    push_3 = 1'b1;
                    data_1 = SOURCE_ADDRESS;
                    data_2 = DESTINATION_ADDRESS;
                    data_3 = DATA_SIZE;
                    DESCRIPTOR_PUSH[0] = 1'b0;
                end
            end

            // Starting DMA with an empty descriptor queue is treated as a controller fault.
            if ((DMA_STATUS[1:0] != Fault) && (OPERATION_START[0] == 1'b1) && (DMA_STATUS[1:0] == Waiting)) begin
                if (empty == 1'b1)
                    DMA_STATUS[1:0] = Fault;
                else begin
                    m_begin = 1'b1;
                    DMA_STATUS[1:0] = Executing;
                end
            end

            if ((DMA_STATUS[1:0] == Executing) && (m_end == 1'b1)) begin
                m_begin = 1'b0;
                INTERRUPT[0] = 1'b1;
                DMA_STATUS[1:0] = Done;
            end

            // The bus interrupt line is asserted only after the transfer completes and software enabled it.
            if (INTERRUPT_ENABLE[0] == 1'b1 && INTERRUPT[0] == 1'b1)
                s_interrupt = 1'b1;
            else
                s_interrupt = 1'b0;
        end
    end
endmodule
