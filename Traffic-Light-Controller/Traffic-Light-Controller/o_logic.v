/*
module o_logic(q, La, Lb); // output logic

input [1:0] q;	// q0, q1
output [1:0] La, Lb;	// La0, La1, Lb0, Lb1
wire not_q1;

_inv U0_inv(.a(q[1]), .y(not_q1));						// q1_bar
assign La[1] = q[1];											// La1 = q1		
_and2 U2_and2(.a(not_q1), .b(q[0]), .y(La[0]));		// La0=q1_bar q[0]
assign Lb[1] = not_q1;										// Lb1=q1_bar
_and2 U3_and3(.a(q[1]), .b(q[0]), .y(Lb[0]));		// Lb0=q1 q0

endmodule
*/

module o_logic(q, La, Lb);
input [1:0] q;
output [1:0] La, Lb;
reg [1:0] La, Lb;
always@*
case(q)
   2'b00:
   begin
   La <= 2'b00; Lb <= 2'b10;
   end
   2'b01:
   begin
   La <= 2'b01; Lb <= 2'b10;
   end
   2'b10:
   begin
   La <= 2'b10; Lb <= 2'b00;
   end
   2'b11:
   begin
   La <= 2'b10; Lb <= 2'b01;
   end
   default:
   begin
   La<=1'bxx; Lb<=1'bxx;
   end
endcase
endmodule
