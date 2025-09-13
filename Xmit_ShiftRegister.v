module Xmit_ShiftRegister (Load, Shift, Clock, Din, SerOut);

   input Load;
   input Shift;
   input Clock;
   input [7:0] Din;
   output      SerOut;

   reg [7:0]   Q;	// transmit shift register
   
   always @(posedge Clock)
     if (Load)
       // Load transmit data into register
       Q <= Din;
     else 
       if (Shift)
	 // Shift register contents
	 Q <= {1'b0, Q[7:1]};

   assign SerOut = Q[0];
   
endmodule // ShiftRegister
