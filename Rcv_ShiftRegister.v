module Rcv_ShiftRegister(Reset, Clock, Shift, SerIn, OE, Dout);
   input Reset;
   input Clock;
   input Shift;
   input SerIn;
   input OE; // output enable
   output [31:0] Dout;
   
   reg [7:0] Rreg;	 //receive shift registers
   reg [7:0] Rreg_next;

   // Receive shift register
   always @(posedge Reset, posedge Clock)
     begin
	if (Reset)
	  Rreg = 8'h00;
	else
	  Rreg = Rreg_next;
     end

   always @(Rreg, Shift, SerIn)
     begin
	if (Shift)
	  Rreg_next <= {SerIn, Rreg[7:1]}; // shift receive data
	else
	  Rreg_next <= Rreg;
     end

   assign Dout = OE ? {24'h000000, Rreg} : 32'hzzzzzzzz;

endmodule
