module UART_Rcv(Reset,Clock,RxD,RD,RxParityErr,RxRDY,Dout);

   input wire	Reset;
   input wire	Clock;
   input wire	RxD;
   input wire	RD;
   output wire	RxParityErr;
   output wire	RxRDY;
   output wire [31:0] Dout;

   wire 	      BaudClock;
   wire 	      Idle;
   wire 	      Parity;
   wire 	      Shift;
   wire 	      StartDetect;
	
	wire unused;

   Rcv_BaudCounterStartBitDetector	b2v_BaudCounterStartBitDetect(
	.Reset(Reset),
	.Clock(Clock),
	.RxD(RxD),
	.Idle(Idle),
	.Shift(Shift),
	.StartDetect(StartDetect),
	.BaudClock(BaudClock));
	defparam	b2v_BaudCounterStartBitDetect.S0 = 2'b00;
	defparam	b2v_BaudCounterStartBitDetect.S1 = 2'b01;
	defparam	b2v_BaudCounterStartBitDetect.S2 = 2'b10;
	defparam	b2v_BaudCounterStartBitDetect.S3 = 2'b11;

   Rcv_ParityCheck	b2v_ParityCheck(
	.Reset(StartDetect),
	.Clock(BaudClock),
	.Compute(Shift),
	.Check(Parity),
	.RxD(RxD),
	.RxParityErr(RxParityErr));

   Rcv_Controller	b2v_ReceiveController(
	.Reset(Reset),
	.Clock(BaudClock),
	.StartDetect(StartDetect),
	.RD(RD),
	.Idle(Idle),
	.Shift(Shift),
	.Parity(Parity),
	.RxRDY(RxRDY),
	.Stop(unused));
	defparam	b2v_ReceiveController.RcvIdle = 2'b00;
	defparam	b2v_ReceiveController.RcvParity = 2'b10;
	defparam	b2v_ReceiveController.RcvShift = 2'b01;
	defparam	b2v_ReceiveController.RcvStop = 2'b11;

   Rcv_ShiftRegister	b2v_ShiftRegister(
	.Reset(Reset),
	.Clock(BaudClock),
	.Shift(Shift),
	.SerIn(RxD),
	.OE(RD),
	.Dout(Dout));

endmodule
