module load_store_unit(funct3,LoadType,StoreType);

   input [2:0] funct3;
   output reg [2:0] LoadType;
   output reg [1:0] StoreType;
	
	wire [2:0] finalLoad;
	wire [1:0] finalStore;
	
	wire[2:0] load00X;
	wire[2:0] load10X;
	
	//loading
	
	mux3 #(.WIDTH(3)) muxLoad (
		.d0(load00X),
		.d1(3'b000),
		.d2(load10X),
		.sel(funct3[2:1]),
		.y(finalLoad)
	);
	
	mux2 #(.WIDTH(3)) muxLoad00X (
		.d0(3'b010),
		.d1(3'b101),
		.sel(funct3[0]),
		.y(load00X)
	);
	
	mux2 #(.WIDTH(3)) muxLoad10X (
		.d0(3'b001),
		.d1(3'b100),
		.sel(funct3[0]),
		.y(load10X)
	);
	
	//storing
	
	mux3 #(.WIDTH(2)) muxStore (
		.d0(2'b01),
		.d1(2'b10),
		.d2(2'b00),
		.sel(funct3[1:0]),
		.y(finalStore)
	);
	
	always@(finalLoad) begin
		LoadType <= finalLoad;
	end
	
	always@(finalStore) begin
		StoreType <= finalStore;
	end
	
   
endmodule
