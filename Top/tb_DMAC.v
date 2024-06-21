`timescale 1ns/100ps

module tb_DMAC;

   reg         clk, reset_n;     
   reg         m_grant;            
   reg [31:0]   m_din;            
   reg          s_sel, s_wr;      
   reg [15:0]   s_addr;         
   reg [31:0]   s_din;            
   
   wire         m_req, m_wr;      
   wire [15:0]   m_addr;         
   wire [31:0]   m_dout, s_dout;  
   wire         s_interrupt;         
   
   // Instance of dmac
   DMAC_Top U0_DMAC_Top(.clk(clk), .reset_n(reset_n), .m_grant(m_grant), .m_din(m_din), .s_sel(s_sel), .s_wr(s_wr), .s_addr(s_addr),
                .s_din(s_din), .m_req(m_req), .m_wr(m_wr), .m_addr(m_addr), .m_dout(m_dout), .s_dout(s_dout), .s_interrupt(s_interrupt));
            
	always
		begin
			#5; clk = ~clk; //cycle of clk is 10ns
		end   
     initial begin
                  clk = 1; reset_n = 0; m_grant = 1'b0; m_din = 32'b0;
                  s_sel = 1'b0; s_wr = 1'b0; s_addr = 16'b0; s_din = 32'b0;
      #15;   	reset_n = 1'b1;
      #10;         s_sel = 1'b1; s_addr = 16'h01;
      #20;      s_wr = 1'b1; s_addr = 16'h02; s_din = 32'h0000_0001;
      #10;         s_addr = 16'h04; s_din = 32'h0000_0010;
      #10;         s_addr = 16'h05; s_din = 32'h0000_0020;
      #10;         s_addr = 16'h06; s_din = 32'h0000_0004;
      #10;         s_addr = 16'h03; s_din = 32'h0000_0001;
      #10;         s_addr = 16'h04; s_din = 32'h0000_0030;
      #10;         s_addr = 16'h05; s_din = 32'h0000_0040;
      #10;         s_addr = 16'h06; s_din = 32'h0000_0005;
      #10;         s_addr = 16'h03; s_din = 32'h0000_0001;
      #10;         s_addr = 16'h00;
      #10;         s_din = 32'h0000_0001;
      #10;         s_addr = 16'h016; s_din = 32'h0000_0003;
      #10;         s_addr = 16'h00; s_din = 32'h0000_0000;
      #10;         s_sel = 0; s_wr = 0; s_din = 0;
      #10;         s_wr = 1'b0;
      #40;      m_grant = 1'b1;
      #100;      s_sel = 1'b1; s_wr = 1'b1; s_addr = 16'h01; s_din = 32'h0000_0001;
      #10;         s_sel = 1'b0; s_wr = 1'b0; s_addr = 16'h00; s_din = 32'h0000_0000;
      #20;      $stop;
   end
endmodule


