module extend(Instr,ImmSrc,ImmExt);

   input [31:0] Instr;
   input [2:0] 	ImmSrc;
   output reg [31:0] ImmExt;
	
	wire[31:0] case000; //sign extended immediate
	wire[31:0] case001; //store
	wire[31:0] case010; //branch
	wire[31:0] case011; //jump
	wire[31:0] case100; //upper immediate???
	
	wire[31:0] case0XX;
	
	assign case000 = {{20{Instr[31]}}, Instr[31:20]}; // 000
	assign case001 = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; //001
	assign case010 = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};
	assign case011 = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
	assign case100 = {Instr[31:12], 12'b0};
	
	assign case0XX = ImmSrc[1] ? (ImmSrc[0] ? case011 : case010) // 011 vs 010
	: (ImmSrc[0] ? case001: case000); // 001 vs 000
	
	always @(case100, case0XX, ImmSrc[2]) begin
		ImmExt <= ImmSrc[2] ? case100 : case0XX;
	end
	
   
endmodule
