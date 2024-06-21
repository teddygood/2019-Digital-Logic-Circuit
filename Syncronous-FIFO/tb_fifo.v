`timescale 1ns/100ps

module tb_fifo;	// testbench fifo
reg tb_clk, tb_reset_n, tb_rd_en, tb_wr_en;	// clock, reset, read enable, write enable
reg [31:0] tb_d_in;
wire [31:0] tb_d_out;

wire tb_full, tb_empty;	// data full, empty signal
wire tb_wr_ack, tb_wr_err, tb_rd_ack, tb_rd_err;
// write acknowledge, error, read acknowledge, error
wire [3:0] tb_data_count;

// instance fifo
fifo U0_fifo(.clk(tb_clk), .reset_n(tb_reset_n), .rd_en(tb_rd_en), .wr_en(tb_wr_en), .d_in(tb_d_in), .d_out(tb_d_out),
.data_count(tb_data_count),.full(tb_full),.empty(tb_empty),.wr_ack(tb_wr_ack),.wr_err(tb_wr_err),.rd_ack(tb_rd_ack),.rd_err(tb_rd_err)); 

parameter temp = 10;
always #(temp/2) tb_clk = ~tb_clk;	// clock period 10

initial
begin
		tb_clk=1; tb_reset_n=0; tb_rd_en=0; tb_wr_en=0; tb_d_in=32'h0;			// initial value
#12 	tb_reset_n=1; 														// change value
#10 	tb_rd_en=1;
#6 	tb_wr_en=1; tb_rd_en=0; tb_d_in=32'h0000_0001;
#10;  tb_d_in = 32'h00000002;
#10;  tb_d_in = 32'h00000003;
#10;  tb_d_in = 32'h00000004;
#10;  tb_d_in = 32'h00000005;
#10;  tb_d_in = 32'h00000006;
#10;  tb_d_in = 32'h00000007;
#10;  tb_d_in = 32'h00000008;
#10;  tb_d_in = 32'h00000009;
#10;  tb_d_in = 32'h0000000a;
#10;  tb_d_in = 32'h0000000b;
#10;	tb_rd_en=1; tb_wr_en=0;
#120; $stop;
end
endmodule
