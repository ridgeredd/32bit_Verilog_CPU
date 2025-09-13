module ALU_decoder(opb5,funct3,funct7b5,ALUOp,ALUControl);

   input opb5;
   input [2:0] funct3;
   input       funct7b5;
   input [1:0] ALUOp;
   output reg [3:0] ALUControl;
	
	wire [3:0] outFinal;
	
	wire [3:0] out000;
	wire [3:0] out0XX;
	
	wire [3:0] out1XX;
	wire [3:0] out101;
	
	wire [3:0] outXXX;
	
	wire [3:0] out000_op1;
	
	// Op = 10 part 1
	
	mux2 #(.WIDTH(4)) mux000_op1 (
		.d0(4'b0000),
		.d1(4'b0001),
		.sel(funct7b5),
		.y(out000_op1)
	);
	
	mux2 #(.WIDTH(4)) mux000 (
		.d0(4'b0000),
		.d1(out000_op1),
		.sel(opb5),
		.y(out000)
	);
	
	mux4 #(.WIDTH(4)) mux0XX (
		.d0(out000),
		.d1(4'b0110),
		.d2(4'b0101),
		.d3(4'b1001),
		.sel(funct3[1:0]),
		.y(out0XX)
	);
	
	// Op = 10 part 2
	
	mux4 #(.WIDTH(4)) mux1XX (
		.d0(4'b0100),
		.d1(out101),
		.d2(4'b0011),
		.d3(4'b0010),
		.sel(funct3[1:0]),
		.y(out1XX)
	);
	
	mux2 #(.WIDTH(4)) mux101 (
		.d0(4'b0111),
		.d1(4'b1000),
		.sel(funct7b5),
		.y(out101)
	);
	
	// select between op = 10
	
	mux2 #(.WIDTH(4)) mux_op10 (
		.d0(out0XX),
		.d1(out1XX),
		.sel(funct3[2]),
		.y(outXXX)
	);
	
	// final output
	mux3 #(.WIDTH(4)) muxFinal (
		.d0(4'b0000),
		.d1(4'b0001),
		.d2(outXXX),
		.sel(ALUOp),
		.y(outFinal)
	);
	
	
	always@(outFinal) begin
		ALUControl <= outFinal;
	end
   
endmodule
