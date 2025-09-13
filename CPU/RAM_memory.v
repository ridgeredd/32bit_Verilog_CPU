module RAM_memory(clock,CS,WE,Addr,WD,RD);

   input clock;
   input WE; // write-enable
   input CS; // chip-select
   input [11:0] Addr;
   input [31:0] WD; // write-data
   output [31:0] RD; // read-data
   
   reg [31:0]  RAM[0:1023];
   reg [31:0]  RD_output;

   integer     i;
  
   initial
   begin
      for (i = 0; i < 64; i = i + 1)
	RAM[i] = 32'h00000000;
   end

   // Writes occur on the falling edge of the clock to allow 
   // sufficient delay for the non-word writes to drive the 
   // remaining bytes of the the read data RD from RAM.
   always @(negedge clock)
     begin
	if ((CS == 1) && (WE == 1)) // Write
	  RAM[Addr[11:2]] <= WD;
     end

   // The read data RD is driven whenever the RAM is selected
   // to ensure that non-word writes occur correctly.
   always @(CS,RAM,Addr)
     begin
	if (CS == 1) // Read
	  RD_output <= RAM[Addr[11:2]]; // word-aligned
	else
	  RD_output <= 32'bz;
     end

   assign RD = RD_output;

endmodule
