module Rcv_Controller(Reset, Clock, StartDetect, RD, Idle, Shift, Parity, Stop, RxRDY);
   input Reset;
   input Clock;
   input StartDetect;
   input RD; // read signal for Dout
   output reg Idle;
   output reg Shift;
   output reg Parity;
   output reg Stop;
   output reg RxRDY;
   
   reg [2:0] RcvBitCnt;	 // receive bit counts
   reg [2:0] RcvBitCnt_next;
   reg [1:0] RcvState;	 // reception state
   reg [1:0] RcvState_next;

   wire 	    RxRDY_reset;
   
   parameter RcvIdle = 2'd0, RcvShift = 2'd1, RcvParity = 2'd2, RcvStop = 2'd3;

   // Receive controller - current state
   always @(posedge Reset or posedge Clock) 
     begin
	if (Reset)
	  RcvState <= RcvIdle;
	else
	  RcvState <= RcvState_next;
   end

   // next-state
   always @(RcvState, RcvBitCnt, StartDetect)
     begin
	case (RcvState)
	  RcvIdle:
	    if (StartDetect == 1'b1)
	      RcvState_next <= RcvShift; // shift after start detected
	    else
	      RcvState_next <= RcvIdle;
	  RcvShift:
	    if (RcvBitCnt == 3'b111)
	      RcvState_next <= RcvParity;  // parity state after 8 bits
	    else 
	      RcvState_next <= RcvShift;
	  RcvParity: RcvState_next <= RcvStop;
	  RcvStop:   RcvState_next <= RcvIdle;
	endcase
   end

   // output
   always @(RcvState)
     begin
	case (RcvState)
	  RcvIdle:
	    begin
	       Idle <= 1;
	       Shift <= 0;
	       Parity <= 0;
	       Stop <= 0;
	    end
	  RcvShift:
	    begin
	       Idle <= 0;
	       Shift <= 1;
	       Parity <= 0;
	       Stop <= 0;
	    end
	  RcvParity:
	    begin
	       Idle <= 0;
	       Shift <= 0;
	       Parity <= 1;
	       Stop <= 0;
	    end
	  RcvStop:
	    begin
	       Idle <= 0;
	       Shift <= 0;
	       Parity <= 0;
	       Stop <= 1;
	    end
	endcase
   end

   // RcvBitCnt - current state
   always @(posedge StartDetect or posedge Clock) 
     begin
	if (StartDetect)
	  RcvBitCnt <= 3'b000;
	else
	  RcvBitCnt <= RcvBitCnt_next;
     end

   // RcvBitCnt - next-state
   always @(RcvState, RcvBitCnt)
     begin
	if (RcvState == RcvShift)
	  RcvBitCnt_next <= RcvBitCnt + 3'b001;
	else
	  RcvBitCnt_next <= RcvBitCnt;
     end

   // RxRDY logic: RxD buffer = 0 (empty), 1 (full)
   // A read (RD = 1) resets to 0, indicating the RxD buffer is empty.
   // At system reset (Reset == 1), the RxD buffer is empty.
   // It should be full when entering the stop state, so Stop
   // can be used as the clock for the flip flop.
   assign RxRDY_reset = Reset | RD;
   
   always @(posedge RxRDY_reset, posedge Stop)
     begin
	if ( RxRDY_reset ) 
	  RxRDY <= 1'b0;
	else 
	  RxRDY <= 1'b1;
     end

endmodule
