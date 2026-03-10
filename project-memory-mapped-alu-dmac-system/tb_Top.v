`timescale 1ns/100ps

module tb_Top;
	reg clk, reset_n, m0_req, m0_wr;
	reg [15:0] m0_addr;
	reg [31:0] m0_dout;
	wire m0_grant, a_interrupt, d_interrupt;
	wire [31:0] m_din;

	Top dut(
		.clk(clk),
		.reset_n(reset_n),
		.m0_req(m0_req),
		.m0_wr(m0_wr),
		.m0_addr(m0_addr),
		.m0_dout(m0_dout),
		.m0_grant(m0_grant),
		.a_interrupt(a_interrupt),
		.d_interrupt(d_interrupt),
		.m_din(m_din)
	);

	always #5 clk = ~clk;

	task host_write;
		input [15:0] addr;
		input [31:0] data;
		begin
			@(negedge clk);
			m0_req = 1'b1;
			m0_wr = 1'b1;
			m0_addr = addr;
			m0_dout = data;
			@(negedge clk);
			m0_req = 1'b0;
			m0_wr = 1'b0;
			m0_addr = 16'h0000;
			m0_dout = 32'h0000_0000;
		end
	endtask

	task host_read;
		input [15:0] addr;
		begin
			@(negedge clk);
			m0_req = 1'b1;
			m0_wr = 1'b0;
			m0_addr = addr;
			@(posedge clk);
			$display("READ %h -> %h", addr, m_din);
			@(negedge clk);
			m0_req = 1'b0;
			m0_addr = 16'h0000;
		end
	endtask

	initial begin
		clk = 1'b0;
		reset_n = 1'b1;
		m0_req = 1'b0;
		m0_wr = 1'b0;
		m0_addr = 16'h0000;
		m0_dout = 32'h0000_0000;

		#2 reset_n = 1'b0;
		#12 reset_n = 1'b1;

		// operand memory and instruction memory
		host_write(16'h0200, 32'd1234);
		host_write(16'h0204, 32'd5678);
		host_write(16'h0300, 32'h00003C04); // opcode F, opA 0, opB 1

		// DMAC descriptors: RAM operand -> ALU operand register
		host_write(16'h0003, 32'h0000_0200);
		host_write(16'h0004, 32'h0000_0110);
		host_write(16'h0005, 32'h0000_0001);
		host_write(16'h0006, 32'h0000_0001);

		host_write(16'h0003, 32'h0000_0204);
		host_write(16'h0004, 32'h0000_0111);
		host_write(16'h0005, 32'h0000_0001);
		host_write(16'h0006, 32'h0000_0001);

		host_write(16'h0003, 32'h0000_0300);
		host_write(16'h0004, 32'h0000_0103);
		host_write(16'h0005, 32'h0000_0001);
		host_write(16'h0006, 32'h0000_0001);

		host_write(16'h0002, 32'h0000_0001);
		host_write(16'h0000, 32'h0000_0001);
		repeat (40) @(posedge clk);
		host_write(16'h0001, 32'h0000_0000);
		host_write(16'h0002, 32'h0000_0000);

		host_write(16'h0102, 32'h0000_0001);
		host_write(16'h0100, 32'h0000_0001);
		repeat (120) @(posedge clk);
		host_write(16'h0101, 32'h0000_0000);
		host_write(16'h0102, 32'h0000_0000);

		// ALU result FIFO -> result RAM
		host_write(16'h0003, 32'h0000_0104);
		host_write(16'h0004, 32'h0000_0400);
		host_write(16'h0005, 32'h0000_0001);
		host_write(16'h0006, 32'h0000_0001);

		host_write(16'h0003, 32'h0000_0104);
		host_write(16'h0004, 32'h0000_0404);
		host_write(16'h0005, 32'h0000_0001);
		host_write(16'h0006, 32'h0000_0001);

		host_write(16'h0002, 32'h0000_0001);
		host_write(16'h0000, 32'h0000_0001);
		repeat (40) @(posedge clk);
		host_write(16'h0001, 32'h0000_0000);
		host_write(16'h0002, 32'h0000_0000);

		host_read(16'h0400);
		host_read(16'h0404);

		#50;
		$finish;
	end
endmodule
