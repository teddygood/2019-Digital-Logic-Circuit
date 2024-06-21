module bus_arbit(clk, reset_n, m0_req, m1_req, m0_grant, m1_grant);
	input clk, reset_n;
	input m0_req, m1_req;
	output reg m0_grant, m1_grant;
	
	reg next_state, state;
	
	parameter M0_GRANT = 1'b0;
	parameter M1_GRANT = 1'b1;
	//state encoding
	
	always @ (m0_req, m1_req, state)
		begin
			if (state == M0_GRANT) //when state is m0_grant	
				begin
					case({m0_req,m1_req})
						(2'b0_0): next_state <= M0_GRANT; //no grant
						(2'b0_1): next_state <= M1_GRANT;
						(2'b1_0): next_state <= M0_GRANT;
						(2'b1_1): next_state <= M0_GRANT;
						default : next_state <= 1'bx;
					endcase
				end 
			else if (state == M1_GRANT) //when state is m1_grant
				begin
					case({m0_req,m1_req})
						(2'b0_0): next_state <= M0_GRANT; //no grant
						(2'b0_1): next_state <= M1_GRANT;
						(2'b1_0): next_state <= M0_GRANT;
						(2'b1_1): next_state <= M1_GRANT;
						default : next_state <= 1'bx;
					endcase
				end
			else
				next_state = 1'bx;
		end
	
	always @ (posedge clk, negedge reset_n)
		begin
			if (reset_n == 1'b0) 
				state <= M0_GRANT;
			else
				state <= next_state;
		end	
		
	always @ (state)
		begin
			if (state == M0_GRANT)
				begin
					m0_grant <= 1'b1;
					m1_grant <= 1'b0;
				end 
			else if (state == M1_GRANT)
				begin
					m0_grant <= 1'b0;
					m1_grant <= 1'b1;
				end
			else 
				begin
					m0_grant <= 1'bx;
					m1_grant <= 1'bx;
				end
		end
endmodule 