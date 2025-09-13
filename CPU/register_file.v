module register_file(reset,clock,we3,a1,a2,a3,wd3,rd1,rd2);
   
   input reset;
   input clock;
   input we3; // write-enable
   input [4:0] a1; // register address 1
   input [4:0] a2; // register address 2
   input [4:0] a3; // register address 3
   input [31:0] wd3; // write data
   output [31:0] rd1; // read register 1
   output [31:0] rd2; // read register 2
	
	reg [31:0] Q[0:31];
	
	always@(posedge clock, posedge reset) begin //combined these blocks otherwise two drivers
	
		if(reset) begin //reset went high. Takes priority if at same time
			Q[0] <= 32'b0;
			Q[1] <= 32'b0;
			Q[2] <= 32'b0;
			Q[3] <= 32'b0;
			Q[4] <= 32'b0;
			Q[5] <= 32'b0;
			Q[6] <= 32'b0;
			Q[7] <= 32'b0;
			Q[8] <= 32'b0;
			Q[9] <= 32'b0;
			Q[10] <= 32'b0;
			Q[11] <= 32'b0;
			Q[12] <= 32'b0;
			Q[13] <= 32'b0;
			Q[14] <= 32'b0;
			Q[15] <= 32'b0;
			Q[16] <= 32'b0;
			Q[17] <= 32'b0;
			Q[18] <= 32'b0;
			Q[19] <= 32'b0;
			Q[20] <= 32'b0;
			Q[21] <= 32'b0;
			Q[22] <= 32'b0;
			Q[23] <= 32'b0;
			Q[24] <= 32'b0;
			Q[25] <= 32'b0;
			Q[26] <= 32'b0;
			Q[27] <= 32'b0;
			Q[28] <= 32'b0;
			Q[29] <= 32'b0;
			Q[30] <= 32'b0;
			Q[31] <= 32'b0;
		end 
		
		else begin //rising edge write
			if (we3 && (a3 != 5'b0)) begin //write enable and not write to R0
				Q[a3] <= wd3; //write address
			end
		end
	end
	
	assign rd1 = Q[a1];
	assign rd2 = Q[a2];
	
   
endmodule
