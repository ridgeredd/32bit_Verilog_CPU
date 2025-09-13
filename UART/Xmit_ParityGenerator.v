module Xmit_ParityGenerator (Reset, Clock, Din, Enable, Parity);

   input Reset;
   input Clock;
   input Din;
   input Enable;
   output reg Parity;

   // Transmit parity calculation
   always @(posedge Clock)
     if (Reset)
       // reset value = 0 => even parity
       // reset value = 1 => odd parity
       Parity <= 1'b0;
     else 
       if (Enable)
	 // Parity is computed as the XOR of the data bits.
	 Parity <= Parity ^ Din;

endmodule
