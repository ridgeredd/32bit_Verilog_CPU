module  Xmit_BufferRegister(Clock, Din, Dout);

   input Clock;
   input [31:0] Din;
   output reg [7:0] Dout;

   always @(posedge Clock)
       Dout <= Din[7:0];
   
endmodule
