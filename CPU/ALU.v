module ALU(A, B, ALUcontrol, result, flags);

    input [31:0] A;
    input [31:0] B;
    input [3:0] ALUcontrol;
    output reg [31:0] result;
    output [3:0] flags; // {v,c,n,z}

    wire [31:0] invB;
    wire [31:0] sum;
    wire cout;
	 
	 wire addSubSetle;
	 wire difAResult;
	 wire ofpossible;
	 
	 wire [31:0] result1;
	 wire [31:0] result2;
	 wire [31:0] result3;
	 wire [31:0] result4;
	 wire signed [31:0] arithmeticShift;
	 
	 // signals to determine overflow flag
	 
	 assign addSubSetle = (~ALUcontrol[3] & ~ALUcontrol[2] & ~ALUcontrol[1]) | 
	 (~ALUcontrol[3] & ~ALUcontrol[1] & ALUcontrol[0]) | 
	 (~ALUcontrol[2] & ~ALUcontrol[1] & ALUcontrol[0]);
	 
	 assign difAResult = A[31] ^ sum[31];
	 assign ofpossible = ~(A[31] ^ B[31] ^ ALUcontrol[0]);
	 
	 assign flags[3] = addSubSetle & difAResult & ofpossible; //overflow flag
	 
	 // summation

    assign invB = ALUcontrol[0] ? ~B : B;
	 assign {cout,sum} = invB + A + ALUcontrol[0];
	 assign flags[2] = addSubSetle & cout; //carry flag
	 
	 // computation to determine possible results
	 
	 assign arithmeticShift = ($signed(A)) >>> B[4:0];
	 
	 assign result1 = ALUcontrol[1] ? (ALUcontrol[0] ? A | B: A & B) : sum; //result between 0000, 0001, 0010, 0011
	 assign result2 = ALUcontrol[1] ? (ALUcontrol[0] ? A >> B[4:0]: A << B[4:0]) : (ALUcontrol[0] ? {31'b0, sum[31] ^ flags[3]} : A ^ B); //result between 0100, 0101, 0110, 0111
	 assign result3 = ALUcontrol[0] ? {31'b0, ~flags[2]} : arithmeticShift; //result between 1000, 1001
	 
	 // assign result based on controls
	 
	 assign result4 = ALUcontrol[2] ? result2 : result1; // select between 00XX and 01XX results
	 
	 //remaining flags
	 
	 assign flags[0] = &(~result); //zero flag
	 assign flags[1] = result[31];// negative flag
	 
	 always @(result3, result4, ALUcontrol[3]) begin
		result <= ALUcontrol[3] ? result3 : result4; // select between 1XXX and 0XXX results
	 end
	 
	 

endmodule
