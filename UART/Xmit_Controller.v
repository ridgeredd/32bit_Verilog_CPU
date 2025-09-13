module Xmit_Controller (Reset, Clock, WR, Idle, Start, Shift, Parity, Stop, TxRDY);

   input Reset;
   input Clock;
   input WR;
   output reg Idle;
   output reg Start;
   output reg Shift;
   output reg Parity;
   output reg Stop;
   output reg 	    TxRDY; // 1 = buffer empty, 0 = buffer full

   wire 	    TxRDY_clock;
   reg [2:0] Tcnt;	// transmit bit count
   reg [2:0] Tcnt_next;
   reg [2:0] Tstate;	// transmission state
   reg [2:0] Tstate_next;
   
   parameter TidleS = 0, TstartS = 1, TshiftS = 2, TparityS = 3, TstopS = 4;

   // current state
   always @(posedge Reset or posedge Clock)
     begin
	if (Reset)
	  Tcnt <= 3'b000;
	else
	  Tcnt <= Tcnt_next;
     end

   // next state
   always @(Tstate,Tcnt)
     begin
	if (Tstate == TshiftS)
	  Tcnt_next <= Tcnt + 3'b001;
	else
	  Tcnt_next <= Tcnt;
     end

   // current state
   always @(posedge Reset or posedge Clock)
     begin
	if (Reset)
	  Tstate <= TidleS;
	else
	  Tstate <= Tstate_next;
     end

   // next state
   always @(TxRDY,Tstate,Tcnt)
     begin
	case (Tstate)
	  TidleS:   
	    if (TxRDY == 0) // A write to the TxD buffer has occurred
	      Tstate_next <= TstartS;
	    else
	      Tstate_next <= TidleS;
	  TstartS: Tstate_next <= TshiftS; // start bit
	  TshiftS:  
	    if (Tcnt == 3'b111) 
	      Tstate_next <= TparityS; // 8 data bits
	    else 
	      Tstate_next <= TshiftS;
	  TparityS: Tstate_next <= TstopS; //parity bit
	  TstopS:   Tstate_next <= TidleS; //stop bit
	  default: Tstate_next <= TidleS;
	endcase
     end

   // output logic
   always @(Tstate)
     begin
	case (Tstate)
	  TstartS:
	    begin
	       Idle <= 1'b0;
	       Start <= 1'b1;
	       Shift <= 1'b0;
	       Parity <= 1'b0;
	       Stop <= 1'b0;
	    end
	  TshiftS:  
	    begin
	       Idle <= 1'b0;
	       Start <= 1'b0;
	       Shift <= 1'b1;
	       Parity <= 1'b0;
	       Stop <= 1'b0;
	    end
	  TparityS:
	    begin
	       Idle <= 1'b0;
	       Start <= 1'b0;
	       Shift <= 1'b0;
	       Parity <= 1'b1;
	       Stop <= 1'b0;
	    end
	  TstopS:
	    begin
	       Idle <= 1'b0;
	       Start <= 1'b0;
	       Shift <= 1'b0;
	       Parity <= 1'b0;
	       Stop <= 1'b1;
	    end
	  default: // idle state
	    begin
	       Idle <= 1'b1;
	       Start <= 1'b0;
	       Shift <= 1'b0;
	       Parity <= 1'b0;
	       Stop <= 1'b0;
	    end
	endcase
     end // always @ (Tstate)

   // TxRDY logic: TxD buffer = 0 (full), 1 (empty)
   // A write (WR = 1) resets to 0, indicating the TxD buffer is full.
   // At system reset (Reset == 1), the TxD buffer is empty.
   // It should also be empty when entering the Idle state.
   assign TxRDY_clock = Reset | Idle;
   
   always @(posedge WR, posedge TxRDY_clock)
     begin
	if (WR)
	  TxRDY <= 1'b0;
	else
	  TxRDY <= 1'b1;
     end

endmodule
