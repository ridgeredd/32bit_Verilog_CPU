module cpu(reset, clock, ReadData, MemWrite, Addr, WriteData);

   input wire	reset;
   input wire	clock;
   input wire [31:0] ReadData;
   output wire 	     MemWrite;
   output wire [31:0] Addr;
   output wire [31:0] WriteData;

   wire 	      AdrSrc;
   wire [3:0] 	      ALUControl;
   wire [1:0] 	      ALUSrcA;
   wire [1:0] 	      ALUSrcB;
   wire [3:0] 	      Flags;
   wire [2:0] 	      funct3;
   wire 	      funct7b5;
   wire [2:0] 	      ImmSrc;
   wire 	      IRWrite;
   wire [2:0] 	      LoadType;
   wire [6:0] 	      op;
   wire 	      PCWrite;
   wire 	      RegWrite;
   wire [1:0] 	      ResultSrc;
   wire [1:0] 	      StoreType;

   controller	b2v_controller_0(
	.reset(reset),
	.clock(clock),
	.funct7b5(funct7b5),
	.Flags(Flags),
	.funct3(funct3),
	.op(op),
	.AdrSrc(AdrSrc),
	.IRWrite(IRWrite),
	.PCWrite(PCWrite),
	.RegWrite(RegWrite),
	.MemWrite(MemWrite),
	.ALUControl(ALUControl),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.ImmSrc(ImmSrc),
	.LoadType(LoadType),
	.ResultSrc(ResultSrc),
	.StoreType(StoreType));

   datapath	b2v_datapath_0(
	.reset(reset),
	.clock(clock),
	.AdrSrc(AdrSrc),
	.IRWrite(IRWrite),
	.PCWrite(PCWrite),
	.RegWrite(RegWrite),
	.ALUControl(ALUControl),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.ImmSrc(ImmSrc),
	.LoadType(LoadType),
	.ReadData(ReadData),
	.ResultSrc(ResultSrc),
	.StoreType(StoreType),
	.funct7b5(funct7b5),
	.Addr(Addr),
	.Flags(Flags),
	.funct3(funct3),
	.op(op),
	.WriteData(WriteData));

endmodule
