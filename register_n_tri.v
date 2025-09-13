module register_n_tri
   (reset,clock,enable,OE,D,Q);

   input reset;
   input clock;
   input enable;
   input OE; // output enable
   input [31:0] D;
   output [31:0] Q;
   reg [31:0] Q_internal;
   
   reg [31:0] Q_next;

   // Current-state/output logic
   always @(posedge reset, posedge clock)
     begin
	if (reset == 1)
	  Q_internal <= 32'h00000000;
	else
	  Q_internal <= Q_next;
     end

   // Next-state logic
   always @(Q_internal, enable, D)
     begin
	if (enable == 1)
	  Q_next <= D;
	else
	  Q_next <= Q_internal;
     end

   assign Q = OE ? Q_internal : 32'hzzzzzzzz;

endmodule
