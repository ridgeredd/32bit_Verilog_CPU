module UART_BaudGen (Reset, Clock, BaudClock, BaudClock16);
  
   input Clock;		// System clock
   input Reset;		// System reset
   output BaudClock;    // Baud clock
   output BaudClock16;	// Baud clock x 16

  reg [4:0] BaudCount;	     // baud counter

  always @(posedge Reset or posedge Clock)
	if (Reset) BaudCount = 5'b00000;  // reset baud rate counter
	else BaudCount = BaudCount + 5'b00001;	  // increment baud counter

  assign BaudClock   = BaudCount[4];	// baud clock
  assign BaudClock16 = BaudCount[0];	// baud clock rate x 16

endmodule
