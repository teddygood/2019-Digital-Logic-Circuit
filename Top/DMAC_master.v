module DMAC_master(clk, reset_n, op_start, op_done, op_clear, source_addr, dest_addr, data_size, data_count, rd_en, m_req, m_grant, m_wr, m_addr, m_dout, m_din, op_mode);
	// input value
input clk, reset_n, m_grant, op_clear, op_start;
input [15:0] source_addr, dest_addr, data_size;
input [3:0] data_count;
input [31:0] m_din;
input [1:0] op_mode;

// output value 
output reg op_done, rd_en ;
output reg m_req, m_wr;
output reg [15:0] m_addr;
output reg [31:0] m_dout;


parameter IDLE 			= 3'b000;
parameter FIFO_POP 		= 3'b001;
parameter BUS_REQUEST 	= 3'b010;
parameter MEMORY_READ 	= 3'b011;
parameter MEMORY_WRITE 	= 3'b100;
parameter DONE 			= 3'b101;

reg [2:0] state, next_state;
reg [15:0] master_source, next_master_source, master_destaddr, next_master_destaddr, master_datasize, next_master_datasize;


always@(posedge clk or negedge reset_n)
begin
	if(reset_n == 0) // if reset_n =0, keep state in IDLE
		state <= IDLE;
	else if (reset_n == 1) // if reset_n = 1, pass next state value to state 
		state <= next_state;
	else				// default case 
		state = 3'bx;
end

// decide next state accoding to current state, op_start, op_clear, next_master_datasize, data_count, m_grant 
always@(state, op_start, op_clear, next_master_datasize, data_count, m_grant) 
begin
	case(state)
		IDLE: // if current state is IDLE 
			begin
				if(op_start == 1)
					next_state = FIFO_POP; // if op_start is 1, move to FIFO_POP state
				else
					next_state = IDLE;	 // else keep current state 
			end
		
		FIFO_POP:	// if current state is FIFO_POP
			begin
				if(next_master_datasize != 15'h0) // if next_master's datasize isn't equal with 0
					next_state = BUS_REQUEST;		// move to BUS_REQUEST state 
				else 										// if next_master's datasize is equal with 0
					begin
						if(data_count == 5'h0)			// if current data_count is 0
							next_state = DONE;			// move to DONE state
						else									// in else case, move to FIFO_POP state 
							next_state = FIFO_POP;	
					end
			end
		
		
		BUS_REQUEST:	// if current state is BUS_REQUEST 
			begin
				if(m_grant == 1)				
					next_state = MEMORY_READ; // if m_grant ==1, move to MEMORY_READ state
				else								
					next_state = BUS_REQUEST;	// in else case, keep current state
			end
		
		
		MEMORY_READ: // if current state is MEMORY_READ, move to MEMORY_WRITE state
			next_state = MEMORY_WRITE;
		
		MEMORY_WRITE: // if current state is MEMORY_WRITE
			begin
				if(next_master_datasize != 15'h0) // if next master's datasize isn't equal with 0
					next_state = MEMORY_READ;		// move to MEMORY_READ state
				else 
				begin
					if(data_count == 5'h0)			// if current data count is 0
						next_state = DONE;			// move to DONE state 
					else 
						next_state = FIFO_POP;	// in else case, move to FIFO_POP state
				end
			end
		
		DONE:			// if current state is DONE
			begin
				if(op_clear == 0) 	// if op_clear = 1, move to IDLE state
					next_state = IDLE;
				else						 
					next_state = DONE;	// if op_clear == 0, keep current state 
			end
			
		default
			next_state = 3'bx;
	endcase
end


/* decide source_addr, data_size, destaddr*/
always@(posedge clk or negedge reset_n)
begin
	if(reset_n == 0)//if reset_n is 0, set under values to 0
	begin
		master_source = 15'h0;
		master_destaddr = 15'h0;
		master_datasize = 15'h0;
	end
	
	else if (reset_n == 1)//if reset_n is 0, pass next valus to its parent register 
	begin
		master_source = next_master_source;
		master_destaddr = next_master_destaddr;
		master_datasize = next_master_datasize;
	end
	
	else // default case, set under values to 0
	begin
		master_source = 15'h0;
		master_destaddr = 15'h0;
		master_datasize = 15'h0;
	end
end


/* set next vaules accoding to current state */
always@(state, source_addr, master_source, dest_addr, master_destaddr, data_size, master_datasize, op_mode)
begin
	case(state)
	FIFO_POP:	// if current state is POP, pass current values to each next registers
	begin
		next_master_source  	= source_addr;
		next_master_destaddr = dest_addr;
		next_master_datasize = data_size;
	end
	
	
	BUS_REQUEST:	// if current state is BUS_REQUEST, keep under current values
	begin
		next_master_source = master_source;
		next_master_destaddr = master_destaddr;
		next_master_datasize = master_datasize;
	end
	
	
	MEMORY_READ: // if current state is MEMORY_READ
	begin
		next_master_source = master_source;		// keep master_source, master_desaddr
		next_master_destaddr = master_destaddr;
		next_master_datasize = master_datasize - 1'b1; // minus 1 at master datasize
	end
	
	
	MEMORY_WRITE:// if current state is MEMORY_WRITE
		begin
			if((op_mode[1] == 0) && (op_mode[0] == 1)) // source address increment mode
			begin 
				next_master_source = master_source + 1'b1; // plus 1 at master_source
				next_master_destaddr = master_destaddr;				// keep master_desaddr
			end
			else if((op_mode[1] == 1) && (op_mode[0] == 0)) // destination address increment mode
			begin 
				next_master_source = master_source;					// keep master_source
				next_master_destaddr = master_destaddr+ 1'b1; // plus 1 at master_destaddr
			end
			else if((op_mode[1] == 1) && (op_mode[0] == 1)) // destination, source address increment mode
			begin 
				next_master_source = master_source + 1'b1;		// plus 1 at master_source, master_desaddr
				next_master_destaddr = master_destaddr+ 1'b1;
			end
			else // ((op_mode[1] == 0) && (op_mode[0] == 0))-> keep master_source, master_destaddr 
			begin
				next_master_source = master_source;
				next_master_destaddr = master_destaddr;
			end
		next_master_datasize = master_datasize; // keep master_datasize 
	end
	
	default // in default case, set under registers to 0
	begin
		next_master_source = 15'h0;
		next_master_destaddr = 15'h0;
		next_master_datasize = 15'h0;
	end
	endcase
end

/* rd_en setting */
always@(next_state)
begin
	case(next_state)
		{IDLE} : rd_en = 1'b0;
		{FIFO_POP} : rd_en = 1'b1; // when next state is FIFO_POP, set read enable to 1
		{BUS_REQUEST} : rd_en = 1'b0;
		{MEMORY_READ} : rd_en = 1'b0;
		{MEMORY_WRITE} : rd_en = 1'b0;
		{DONE}	: rd_en = 1'b0;
		default : rd_en = 1'b0;
	endcase
end

/*mASTER output values setting*/
always@(state, master_source, master_destaddr, master_datasize, m_din)
begin
	case(state)
		{IDLE}: // in IDLE state 
		begin
			m_req 		= 1'b0;
			m_wr			= 1'b0;
			m_dout		= 32'b0;
			m_addr 	= 15'b0;
			op_done 		= 1'b0;
		end
		{FIFO_POP}: // in FIFO_POP state 
		begin
			m_req 		= 1'b0;
			m_wr			= 1'b0;
			m_dout		= 32'b0;
			m_addr 	= 15'b0;
			op_done 		= 1'b0;
		end
		{BUS_REQUEST}: // in BUS_REQUEST state
		begin
			m_req 		= 1'b1;	// set m_req to 1
			m_wr			= 1'b0;
			m_dout		= 32'b0;
			m_addr 	= 15'b0;
			op_done 		= 1'b0;
		end
		{MEMORY_READ}:	// in MEMORY_READ state 
		begin
			m_req 		= 1'b1;	// set m_req to 1
			m_wr			= 1'b0;
			m_dout		= 32'b0;
			m_addr 	= master_source; // pass master_source to m_addr 
			op_done 		= 1'b0;
		end
		{MEMORY_WRITE}:  // in MEMORY_WRITE state 
		begin
			m_req 		= 1'b1;	// set m_req to 1
			m_wr			= 1'b1;	// set m_wr to 1
			m_dout		= m_din;	// pass m_din to m_dout 
			m_addr 	= master_destaddr; // pass master_destaddr to m_addr 
			op_done 		= 1'b0;
		end
		{DONE}: // in DONE state
		begin
			m_req 		= 1'b0;
			m_wr			= 1'b0;
			m_dout		= 32'b0;
			m_addr 	= 15'b0;
			op_done 		= 1'b1; // set op_done to 1
		end
		default:		// in default case, set under values to 0
		begin
			m_req 		= 1'b0;
			m_wr			= 1'b0;
			m_dout		= 32'b0;
			m_addr 	= 15'b0;
			op_done 		= 1'b0;
		end
	endcase
end
endmodule
