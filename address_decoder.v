module address_decoder (MemWrite,Addr,RAM_CS,RAM_WE,ROM_CS,UART_WR, UART_RD, CE_SR,CE_UART);

   input MemWrite;
   input [31:0] Addr;
   output reg	RAM_CS;
   output reg	RAM_WE;
   output reg	ROM_CS;
   output reg 	UART_WR;
   output reg 	UART_RD;
   output reg 	CE_UART;
   output reg 	CE_SR;

   // The memory map has non-volatile ROM (32 bits wide) from 
   // address 0x00000000 to 0x00001FFF:
   // Bit number
   // 3    2    2    1    1    1    0    0
   // 1    7    3    9    5    1    7    3
   // 0000 0000 0000 0000 0001 1111 1111 1111 = 0x00001FFF

   // The memory map has volatile RAM memory from
   // address 0x00002000 to address 0x000002FFF:
   // Bit number
   // 3    2    2    1    1    1    0    0
   // 1    7    3    9    5    1    7    3
   // 0000 0000 0000 0000 0010 0000 0000 0000 = 0x00002000
   // 0000 0000 0000 0000 0010 1111 1111 1111 = 0x00002FFF
	
	always @(Addr, MemWrite) begin
		if(Addr < 32'h2000) begin // ROM
			ROM_CS <= 1'b1;
			RAM_CS <= 1'b0;
			RAM_WE <= 1'b0;
			UART_WR <= 1'b0;
			UART_RD <= 1'b0;
			CE_UART <= 1'b0;
			CE_SR <= 1'b0;
		end else if(Addr < 32'h3000) begin // RAM
			ROM_CS <= 1'b0;
			RAM_CS <= 1'b1;
			RAM_WE <= MemWrite;
			UART_WR <= 1'b0;
			UART_RD <= 1'b0;
			CE_UART <= 1'b1;
			CE_SR <= 1'b0;
		end else if(Addr == 32'h3000) begin // transmit / receive
			ROM_CS <= 1'b0;
			RAM_CS <= 1'b0;
			RAM_WE <= 1'b0;
			UART_WR <= MemWrite;
			UART_RD <= ~MemWrite;
			CE_UART <= 1'b1;
			CE_SR <= 1'b0;
		end else if(Addr == 32'h3004) begin // status register
			ROM_CS <= 1'b0;
			RAM_CS <= 1'b0;
			RAM_WE <= 1'b0;
			UART_WR <= 1'b0;
			UART_RD <= ~MemWrite; // this is required to read from status register
			CE_UART <= 1'b0;
			CE_SR <= 1'b1;
		end
	end

endmodule
