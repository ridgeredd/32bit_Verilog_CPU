	module branch_unit(Branch,flags,funct3,taken);

   input [3:0] flags; // {v,c,n,z}
   input [2:0] funct3;
   input Branch;
   output taken;
	
	wire BC00X;
	wire BC10X;
	wire BC11X;
	
	wire v;
	wire c;
	wire n;
	wire z;
	
	wire BranchCond;
	
	wire blt_cond1;
	wire blt_cond2;
	wire blt;
	
	assign v = flags[3];
	assign c = flags[2];
	assign n = flags[1];
	assign z = flags[0];
	
	assign blt_cond1 = n & ~v; // rs1 - rs2 < 0 (n=1) and overflow = 0. rs1 < rs2
	assign blt_cond2 = ~n & v; // rs1 - rs2 >= 0 (n=0) but overflow = 1. Incorrect sign so rs1 < rs2
	
	assign blt = blt_cond1 | blt_cond2; // I think this is right
	
	mux4 #(.WIDTH(1)) BranchCondMux (
		.d0(BC00X),
		.d1(1'b0), // defining that branch is 0; this is redundant ig if we and with branch
		.d2(BC10X),
		.d3(BC11X),
		.sel(funct3[2:1]),
		.y(BranchCond)
	);
	
	mux2 #(.WIDTH(1)) mux00X ( //beq breaks if z flag; bne breaks if ~z flag
		.d0(z),
		.d1(~z),
		.sel(funct3[0]),
		.y(BC00X)
	);
	
	mux2 #(.WIDTH(1)) mux10X (
		.d0(blt), // blt
		.d1(~blt), // bge
		.sel(funct3[0]),
		.y(BC10X)
	);
	
	mux2 #(.WIDTH(1)) mux11X (//
		.d0(~c),
		.d1(c),
		.sel(funct3[0]),
		.y(BC11X)
	);
	
	
	assign taken = Branch & BranchCond;
   
endmodule
