module UART(Reset,WR,Clock,RxD,RD,CE_SR,CE_UART,WriteData,TxD,ReadData);

   input wire	Reset;
   input wire	WR;
   input wire	Clock;
   input wire	RxD;
   input wire	RD;
   input wire	CE_SR;
   input wire	CE_UART;
   input wire [31:0] WriteData;
   output wire 	     TxD;
   output wire [31:0] ReadData;

   wire 	      BaudClock;
   wire 	      BaudClock16;
   wire [31:0] 	      SR_D;
   wire 	      SR_RD_enable;
   wire 	      UART_RD_enable;
   wire 	      UART_WR_enable;
   wire 	      SYNTHESIZED_WIRE_0;

   assign	SYNTHESIZED_WIRE_0 = 1;
   assign	SR_RD_enable = CE_SR & RD;
   assign	UART_RD_enable = RD & CE_UART;
   assign	UART_WR_enable = CE_UART & WR;
   assign	SR_D[31:3] = 29'b00000000000000000000000000000;

   UART_BaudGen	b2v_BaudRateGenerator(
	.Reset(Reset),
	.Clock(Clock),
	.BaudClock(BaudClock),
	.BaudClock16(BaudClock16));

   UART_Rcv	b2v_Receiver(
	.Reset(Reset),
	.Clock(BaudClock16),
	.RxD(RxD),
	.RD(UART_RD_enable),
	.RxParityErr(SR_D[2]),
	.RxRDY(SR_D[1]),
	.Dout(ReadData));

   register_n_tri	b2v_StatusRegister(
	.reset(Reset),
	.clock(Clock),
	.enable(SYNTHESIZED_WIRE_0),
	.OE(SR_RD_enable),
	.D(SR_D),
	.Q(ReadData));

   UART_Xmit	b2v_Transmitter(
	.Reset(Reset),
	.Clock(BaudClock),
	.WR(UART_WR_enable),
	.Din(WriteData),
	.TxRDY(SR_D[0]),
	.TxD(TxD));

endmodule
