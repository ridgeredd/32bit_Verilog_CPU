module Rcv_BaudCounterStartBitDetector(Reset, Clock, RxD, Idle, Shift, StartDetect, BaudClock);
   input Reset;
   input Clock;
   input RxD;
   input Idle;
   input Shift;
   output reg StartDetect;
   output BaudClock;
   
   reg [3:0] BaudCount; // divide baud clock by 16
   reg [3:0] BaudCount_next;

   reg [1:0] SBState; // start bit detection state
   reg [1:0] SBState_next;
   
   parameter S0 = 2'd0, S1  = 2'd1, S2   = 2'd2, S3 = 2'd3;
   
   // Baud rate clock is Clock / 16
   // current state
   always @(posedge Reset, posedge Clock)
     begin
	if (Reset) 
	  BaudCount <= 4'b0000;
	else
	  BaudCount <= BaudCount_next;
     end

   // next-state
   always @(BaudCount, SBState)
     begin
	if (SBState == S0) 
	  BaudCount_next <= 4'b0000;
	else
	  BaudCount_next <= BaudCount + 4'b0001;
     end
   
   // output logic
   assign BaudClock = BaudCount[3];

   // Start bit detection - current state
   always @(posedge Reset or posedge Clock)
     begin
	if (Reset)
	  SBState <= S0;
	else
	  SBState <= SBState_next;
     end

   // next-state
   always @(SBState, RxD, BaudCount, Shift, Idle)
     begin
	case (SBState)
	  S0: // look for start bit
	    if (RxD == 1'b0)
	      SBState_next <= S1; // start bit detected
	    else
	      SBState_next <= S0;
	  S1:
	    if (RxD == 1'b1)
	      SBState_next <= S0; // false start bit
	    else if (BaudCount == 4'b0110)
	      SBState_next <= S2; // start bit 8 baud clocks long
	    else
	      SBState_next <= S1;
	  S2: 
	    if (Shift == 1'b1)
	      SBState_next <= S3; // cancel StartDetect when shift state entered
	    else
	      SBState_next <= S2;
	  S3: 
	    if (Idle == 1'b1)
	      SBState_next <= S0;	// start over in idle state
	    else
	      SBState_next <= S3;
	endcase
     end

   // Start bit detection - output
   always @(SBState)
     begin
	if (SBState == S2)
	  StartDetect <= 1;
	else
	  StartDetect <= 0;
     end

endmodule
