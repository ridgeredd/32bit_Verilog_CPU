module controller(
	reset,
	clock,
	op,
	funct3,
	funct7b5,
	Flags,
	ImmSrc,
	ALUSrcA,
	ALUSrcB,
	ResultSrc,
	AdrSrc,
	ALUControl,
	IRWrite,
	PCWrite,
	RegWrite,
	MemWrite,
	LoadType,
	StoreType
);


input wire	reset;
input wire	clock;
input wire	funct7b5;
input wire	[3:0] Flags;
input wire	[2:0] funct3;
input wire	[6:0] op;
output wire	IRWrite;
output wire	AdrSrc;
output wire	RegWrite;
output wire	MemWrite;
output wire	PCWrite;
output wire	[3:0] ALUControl;
output wire	[1:0] ALUSrcA;
output wire	[1:0] ALUSrcB;
output wire	[2:0] ImmSrc;
output wire	[2:0] LoadType;
output wire	[1:0] ResultSrc;
output wire	[1:0] StoreType;

wire	[1:0] ALUOp;
wire	Branch;
wire	BranchTaken;
wire	PCUpdate;





ALU_decoder	b2v_ALU_decoder_0(
	.opb5(op[5]),
	.funct7b5(funct7b5),
	.ALUOp(ALUOp),
	.funct3(funct3),
	.ALUControl(ALUControl));


branch_unit	b2v_branch_unit_0(
	.Branch(Branch),
	.flags(Flags),
	.funct3(funct3),
	.taken(BranchTaken));


imm_src_decoder	b2v_imm_src_decoder_0(
	.op(op),
	.ImmSrc(ImmSrc));


load_store_unit	b2v_load_store_unit_0(
	.funct3(funct3),
	.LoadType(LoadType),
	.StoreType(StoreType));


main_fsm	b2v_main_fsm_0(
	.reset(reset),
	.clock(clock),
	.op(op),
	.AdrSrc(AdrSrc),
	.IRWrite(IRWrite),
	.PCUpdate(PCUpdate),
	.RegWrite(RegWrite),
	.MemWrite(MemWrite),
	.Branch(Branch),
	.ALUOp(ALUOp),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.ResultSrc(ResultSrc));
	defparam	b2v_main_fsm_0.FETCH = 0;
	defparam	b2v_main_fsm_0.DECODE = 1;
	defparam	b2v_main_fsm_0.MEMADR = 2;
	defparam	b2v_main_fsm_0.MEMREAD = 3;
	defparam	b2v_main_fsm_0.MEMWB = 4;
	defparam	b2v_main_fsm_0.MEMWRITE = 5;
	defparam	b2v_main_fsm_0.EXECUTER = 6;
	defparam	b2v_main_fsm_0.ALUWB = 7;
	defparam	b2v_main_fsm_0.EXECUTEI = 8;
	defparam	b2v_main_fsm_0.JAL = 9;
	defparam	b2v_main_fsm_0.BEQ = 10;
	defparam	b2v_main_fsm_0.LUI = 11;
	defparam	b2v_main_fsm_0.JALR = 12;
	defparam	b2v_main_fsm_0.JALRWB = 13;
	defparam	b2v_main_fsm_0.AUIPC = 14;

assign	PCWrite = BranchTaken | PCUpdate;


endmodule
