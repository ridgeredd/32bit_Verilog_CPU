module UART_Xmit(Reset,Clock,WR,Din,TxRDY,TxD);

   input wire	Reset;
   input wire	Clock;
   input wire	WR;
   input wire [31:0] Din;
   output wire 	     TxRDY;
   output wire 	     TxD;

   wire 	     parity;
   wire 	     parity_bit;
   wire [1:0] 	     sel;
   wire 	     SerialOut;
   wire 	     shift;
   wire 	     start;
   wire 	     start_not;
   wire [7:0] 	     Tbuf;

   assign	sel[0] = shift;
   assign	sel[1] = parity;
   assign	start_not =  ~start;
	
	wire unused1;
	wire unused2;

   Xmit_ParityGenerator	b2v_ParityGenerator(
	.Reset(start),
	.Clock(Clock),
	.Din(SerialOut),
	.Enable(shift),
	.Parity(parity_bit));

   Xmit_ShiftRegister	b2v_ShiftRegister(
	.Load(start),
	.Shift(shift),
	.Clock(Clock),
	.Din(Tbuf),
	.SerOut(SerialOut));

   Xmit_mux3	b2v_TxD_MUX(
	.d0(start_not),
	.d1(SerialOut),
	.d2(parity_bit),
	.sel(sel),
	.y(TxD));

   Xmit_BufferRegister	b2v_XmitBuffer(
	.Clock(WR),
	.Din(Din),
	.Dout(Tbuf));

   Xmit_Controller	b2v_XmitController(
	.Reset(Reset),
	.Clock(Clock),
	.WR(WR),
	.Start(start),
	.Shift(shift),
	.Parity(parity),
	.TxRDY(TxRDY),
	.Idle(unused1),
	.Stop(unused2));
	defparam	b2v_XmitController.TidleS = 0;
	defparam	b2v_XmitController.TstartS = 1;
	defparam	b2v_XmitController.TshiftS = 2;
	defparam	b2v_XmitController.TparityS = 3;
	defparam	b2v_XmitController.TstopS = 4;

endmodule
