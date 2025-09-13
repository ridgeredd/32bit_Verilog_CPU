module imm_src_decoder (op,ImmSrc);

   input [6:0] op;
   output reg [2:0] ImmSrc;
	
	wire [2:0] out;
	
	wire [2:0] result_X10X1XX;
	wire [2:0] result_X10X0XX;
	wire [2:0] result_X10XXXX;
	wire [2:0] result_X01XXXX;
	
	//pick between X10X1XX
	mux2 #(.WIDTH(3)) muxX10XX1X (
		.d0(3'b000),
		.d1(3'b011),
		.sel(op[3]),
		.y(result_X10X1XX)
	);
	
	//pick between X10X0XX
	mux2 #(.WIDTH(3)) muxX10XX0X (
		.d0(3'b001),
		.d1(3'b010),
		.sel(op[6]),
		.y(result_X10X0XX)
	);
	
	//pick between X10XXXX's
	mux2 #(.WIDTH(3)) muxX10XXXX (
		.d0(result_X10X0XX),
		.d1(result_X10X1XX),
		.sel(op[2]),
		.y(result_X10XXXX)
	);
	
	//pick between X01XXXX's
	mux2 #(.WIDTH(3)) muxX01XXXX (
		.d0(3'b000),
		.d1(3'b100),
		.sel(op[2]),
		.y(result_X01XXXX)
	);
	
	//final output
	mux4 #(.WIDTH(3)) outMux (
		.d0(3'b000),
		.d1(result_X01XXXX),
		.d2(result_X10XXXX),
		.d3(3'b100),
		.sel(op[5:4]),
		.y(out)
	);
	
	always@(out) begin
		ImmSrc <= out;
	end
   
endmodule
