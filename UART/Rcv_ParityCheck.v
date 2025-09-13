module Rcv_ParityCheck(Reset, Clock, Compute, Check, RxD, RxParityErr);
   input Reset;
   input Clock;
   input Compute;
   input Check;
   input RxD;
   output reg RxParityErr;
   
   reg 	  RparBit; 	 //receive parity bits

   // Receive parity calculation
   always @(posedge Reset or posedge Clock)
     if (Reset)
       begin
	  RparBit <= 1'b0; 	// reset parity bit
	  RxParityErr <= 1'b0;	// reset parity error flag
       end
     else
       if (Compute) 
	 RparBit <= RparBit ^ RxD;     // calculate parity
       else if (Check)
	 if (RxD != RparBit)
	   RxParityErr <= 1;

endmodule
