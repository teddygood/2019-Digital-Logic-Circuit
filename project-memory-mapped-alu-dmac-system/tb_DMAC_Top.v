`timescale 1ns/100ps

module tb_DMAC_Top;
    reg clk, reset_n;
    reg s_sel, s_wr;
    reg [15:0] s_addr;
    reg [31:0] s_din;
    reg m_grant;
    reg [31:0] m_din;

    wire m_req, m_wr;
    wire [15:0] m_addr;
    wire [31:0] m_dout, s_dout;
    wire s_interrupt;

    reg [31:0] mem [0:1023];
    integer i;

    DMAC_Top dut(
        .clk(clk),
        .reset_n(reset_n),
        .m_grant(m_grant),
        .m_din(m_din),
        .s_sel(s_sel),
        .s_wr(s_wr),
        .s_addr(s_addr),
        .s_din(s_din),
        .m_req(m_req),
        .m_wr(m_wr),
        .m_addr(m_addr),
        .m_dout(m_dout),
        .s_dout(s_dout),
        .s_interrupt(s_interrupt)
    );

    always #5 clk = ~clk;

    always @(*) begin
        if (m_req) begin
            m_grant = 1'b1;
            if (m_wr == 1'b0)
                m_din = mem[m_addr[11:2]];
            else
                m_din = 32'h0000_0000;
        end else begin
            m_grant = 1'b0;
            m_din = 32'h0000_0000;
        end
    end

    always @(posedge clk) begin
        if (m_req && m_grant && m_wr)
            mem[m_addr[11:2]] <= m_dout;
    end

    task write_reg;
        input [15:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            s_sel = 1'b1;
            s_wr = 1'b1;
            s_addr = addr;
            s_din = data;
            @(negedge clk);
            s_sel = 1'b0;
            s_wr = 1'b0;
            s_addr = 16'h0000;
            s_din = 32'h0000_0000;
        end
    endtask

    task read_reg;
        input [15:0] addr;
        begin
            @(negedge clk);
            s_sel = 1'b1;
            s_wr = 1'b0;
            s_addr = addr;
            @(posedge clk);
            $display("DMAC read %h -> %h (interrupt=%b)", addr, s_dout, s_interrupt);
            @(negedge clk);
            s_sel = 1'b0;
            s_addr = 16'h0000;
        end
    endtask

    initial begin
        clk = 1'b0;
        reset_n = 1'b1;
        s_sel = 1'b0;
        s_wr = 1'b0;
        s_addr = 16'h0000;
        s_din = 32'h0000_0000;

        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'h0000_0000;

        mem[16'h0200 >> 2] = 32'h1111_1111;
        mem[16'h0204 >> 2] = 32'h2222_2222;

        #2 reset_n = 1'b0;
        #12 reset_n = 1'b1;

        write_reg(16'h0003, 32'h0000_0200);
        write_reg(16'h0004, 32'h0000_0300);
        write_reg(16'h0005, 32'h0000_0001);
        write_reg(16'h0006, 32'h0000_0001);

        write_reg(16'h0003, 32'h0000_0204);
        write_reg(16'h0004, 32'h0000_0304);
        write_reg(16'h0005, 32'h0000_0001);
        write_reg(16'h0006, 32'h0000_0001);

        write_reg(16'h0002, 32'h0000_0001);
        write_reg(16'h0000, 32'h0000_0001);

        repeat (40) @(posedge clk);

        read_reg(16'h0008);
        read_reg(16'h0001);
        $display("DMAC dst 0300 -> %h", mem[16'h0300 >> 2]);
        $display("DMAC dst 0304 -> %h", mem[16'h0304 >> 2]);

        write_reg(16'h0001, 32'h0000_0000);
        write_reg(16'h0002, 32'h0000_0000);

        #40;
        $finish;
    end
endmodule
