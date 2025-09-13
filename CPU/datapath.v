module datapath(
	reset,
	clock,
	ImmSrc,
	ALUSrcA,
	ALUSrcB,
	ResultSrc,
	AdrSrc,
	ALUControl,
	IRWrite,
	PCWrite,
	RegWrite,
	LoadType,
	StoreType,
	ReadData,
	op,
	funct3,
	funct7b5,
	Flags,
	Addr,
	WriteData
);

   input wire	reset;
   input wire	clock;
   input wire	AdrSrc;
   input wire	IRWrite;
   input wire	PCWrite;
   input wire	RegWrite;
   input wire [3:0] ALUControl;
   input wire [1:0] ALUSrcA;
   input wire [1:0] ALUSrcB;
   input wire [2:0] ImmSrc;
   input wire [2:0] LoadType;
   input wire [31:0] ReadData;
   input wire [1:0]  ResultSrc;
   input wire [1:0]  StoreType;
   output wire 	     funct7b5;
   output wire [31:0] Addr;
   output wire [3:0]  Flags;
   output wire [2:0]  funct3;
   output wire [6:0]  op;
   output wire [31:0] WriteData;

   wire [31:0] 	      A;
   wire [31:0] 	      A_D;
   wire [31:0] 	      AEqZero;
   wire [31:0] 	      ALUOut;
   wire [31:0] 	      ALUresult;
   wire [31:0] 	      B;
   wire [31:0] 	      B_D;
   wire [31:0] 	      Data;
   wire [31:0] 	      ImmExt;
   wire [31:0] 	      Instr;
   wire [31:0] 	      OldPC;
   wire [31:0] 	      PC;
   wire [31:0] 	      PCIncr;
   wire [31:0] 	      ReadDataOut;
   wire [31:0] 	      Result;
   wire [31:0] 	      SrcA;
   wire [31:0] 	      SrcB;
   wire 	      SYNTHESIZED_WIRE_6;
   wire 	      SYNTHESIZED_WIRE_1;
   wire 	      SYNTHESIZED_WIRE_3;
   wire [31:0] 	      SYNTHESIZED_WIRE_7;

   assign	Addr = SYNTHESIZED_WIRE_7;
   assign	SYNTHESIZED_WIRE_6 = 1;
   assign	SYNTHESIZED_WIRE_1 = 1;
   assign	SYNTHESIZED_WIRE_3 = 1;

   register_n	b2v_A_register(
	.reset(reset),
	.clock(clock),
	.enable(SYNTHESIZED_WIRE_6),
	.D(A_D),
	.Q(A));
	defparam	b2v_A_register.WIDTH = 32;

   ALU	b2v_ALU_0(
	.A(SrcA),
	.ALUcontrol(ALUControl),
	.B(SrcB),
	.flags(Flags),
	.result(ALUresult));

   mux3	b2v_ALUMux(
	.d0(ALUOut),
	.d1(Data),
	.d2(ALUresult),
	.sel(ResultSrc),
	.y(Result));
	defparam	b2v_ALUMux.WIDTH = 32;

   register_n	b2v_ALUOut_register(
	.reset(reset),
	.clock(clock),
	.enable(SYNTHESIZED_WIRE_1),
	.D(ALUresult),
	.Q(ALUOut));
	defparam	b2v_ALUOut_register.WIDTH = 32;

   register_n	b2v_B_register(
	.reset(reset),
	.clock(clock),
	.enable(SYNTHESIZED_WIRE_6),
	.D(B_D),
	.Q(B));
	defparam	b2v_B_register.WIDTH = 32;

   register_n	b2v_Data_register(
	.reset(reset),
	.clock(clock),
	.enable(SYNTHESIZED_WIRE_3),
	.D(ReadDataOut),
	.Q(Data));
	defparam	b2v_Data_register.WIDTH = 32;

   extend	b2v_extend_0(
	.ImmSrc(ImmSrc),
	.Instr(Instr),
	.ImmExt(ImmExt));

   mux2	b2v_InstrDataMemoryMux(
	.sel(AdrSrc),
	.d0(PC),
	.d1(Result),
	.y(SYNTHESIZED_WIRE_7));
	defparam	b2v_InstrDataMemoryMux.WIDTH = 32;

   register_n	b2v_IR(
	.reset(reset),
	.clock(clock),
	.enable(IRWrite),
	.D(ReadData),
	.Q(Instr));
	defparam	b2v_IR.WIDTH = 32;

   register_n	b2v_OldPC_register(
	.reset(reset),
	.clock(clock),
	.enable(IRWrite),
	.D(PC),
	.Q(OldPC));
	defparam	b2v_OldPC_register.WIDTH = 32;

   register_n	b2v_PC_register(
	.reset(reset),
	.clock(clock),
	.enable(PCWrite),
	.D(Result),
	.Q(PC));
	defparam	b2v_PC_register.WIDTH = 32;

   constant_32bit	b2v_PCIncrement(
	.y(PCIncr));
	defparam	b2v_PCIncrement.value = 4;

   read_data	b2v_ReadData_0(
	.Addr(SYNTHESIZED_WIRE_7),
	.LoadType(LoadType),
	.ReadData(ReadData),
	.ReadDataOut(ReadDataOut));

   register_file	b2v_rf_0(
	.reset(reset),
	.clock(clock),
	.we3(RegWrite),
	.a1(Instr[19:15]),
	.a2(Instr[24:20]),
	.a3(Instr[11:7]),
	.wd3(Result),
	.rd1(A_D),
	.rd2(B_D));

   mux4	b2v_SrcAMux(
	.d0(PC),
	.d1(OldPC),
	.d2(A),
	.d3(AEqZero),
	.sel(ALUSrcA),
	.y(SrcA));
	defparam	b2v_SrcAMux.WIDTH = 32;

   mux3	b2v_SrcBMux(
	.d0(B),
	.d1(ImmExt),
	.d2(PCIncr),
	.sel(ALUSrcB),
	.y(SrcB));
	defparam	b2v_SrcBMux.WIDTH = 32;

   write_data	b2v_WriteData_0(
	.Addr(SYNTHESIZED_WIRE_7),
	.rd2(B_D),
	.ReadData(ReadData),
	.StoreType(StoreType),
	.WriteData(WriteData));

   constant_32bit	b2v_ZeroForA(
	.y(AEqZero));
	defparam	b2v_ZeroForA.value = 0;

   assign	funct7b5 = Instr[30];
   assign	funct3[2:0] = Instr[14:12];
   assign	op[6:0] = Instr[6:0];

endmodule
