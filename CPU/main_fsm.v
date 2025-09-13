module main_fsm(reset,clock,op,
	       ALUSrcA,ALUSrcB,ResultSrc,AdrSrc,
	       IRWrite,PCUpdate,RegWrite, MemWrite,
               ALUOp,Branch);

   input reset;
   input clock;
   input [6:0] op;
   output reg [1:0] ALUSrcA;
   output reg [1:0] ALUSrcB;
   output reg [1:0] ResultSrc;
   output reg	AdrSrc;
   output reg	IRWrite;
   output reg	PCUpdate;
   output reg	RegWrite;
   output reg	MemWrite;
   output reg [1:0] ALUOp;
   output reg	Branch;

   parameter FETCH = 0, DECODE = 1, MEMADR = 2, MEMREAD = 3, MEMWB = 4,
     MEMWRITE = 5, EXECUTER = 6, ALUWB = 7, EXECUTEI = 8, JAL = 9,
     BEQ = 10, LUI = 11, JALR = 12, JALRWB = 13, AUIPC = 14;
   
   reg [3:0] 	state, nextstate;
  
   // current state
   always @(posedge reset, posedge clock)
     begin
	if (reset == 1)
	  state <= FETCH;
	else
	  state <= nextstate;
     end
  
   // next state logic
   always @(state,op) begin
     case(state)
       FETCH: nextstate <= DECODE;
		 
       DECODE: begin // Decode the opcode, op, to determine the next state
			case(op)
				7'd3: nextstate <= MEMADR;
				7'd19: nextstate <= EXECUTEI;
				7'd23: nextstate <= AUIPC;
				7'd35: nextstate <= MEMADR;
				7'd51: nextstate <= EXECUTER;
				7'd55: nextstate <= LUI;
				7'd99: nextstate <= BEQ;
				7'd103: nextstate <= JALR;
				7'd111: nextstate <= JAL;
				default: nextstate <= MEMADR;
			endcase
		 end
		 
       MEMADR: begin // depends. load or store
			if (op == 7'd3) // Load
				nextstate <= MEMREAD;
			else // Store
				nextstate <= MEMWRITE;
		end
			
       MEMREAD: nextstate <= MEMWB;
       EXECUTER: nextstate <= ALUWB;
       EXECUTEI: nextstate <= ALUWB;
       JAL: nextstate <= ALUWB;
       LUI: nextstate <= ALUWB;
       JALR: nextstate <= JALRWB;
       AUIPC: nextstate <= ALUWB;
       default: nextstate <= FETCH; //all other states to fetch
     endcase
	end
    
   // output logic
   // assign ALUSrcA, ALUSrcB, ResultSrc, AdrSrc, IRWrite, PCUpdate, RegWrite, MemWrite, ALUOp, Branch
   always @(state) begin
     case(state)
       FETCH: begin
			ALUSrcA <= 2'b00; //
			ALUSrcB <= 2'b10; //
			ResultSrc <= 2'b10; //
			AdrSrc <= 1'b0; //
			IRWrite <= 1'b1; //
			PCUpdate <= 1'b1; //
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00; //
			Branch <= 1'b0;
			end
       DECODE: begin
			ALUSrcA <= 2'b01; //
			ALUSrcB <= 2'b01; //
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00; //
			Branch <= 1'b0;
			end
       MEMADR: begin
			ALUSrcA <= 2'b10; //
			ALUSrcB <= 2'b01; //
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00; //
			Branch <= 1'b0;
			end
       MEMREAD: begin
			ALUSrcA <= 2'b00; //
			ALUSrcB <= 2'b00; //
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b1;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       MEMWB: begin 
			ALUSrcA <= 2'b00;
			ALUSrcB <= 2'b00;
			ResultSrc <= 2'b01; //
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b1; //
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       MEMWRITE: begin 
			ALUSrcA <= 2'b00; //check if this is true. This does not match between slides. memwrite = 0 or 1?
			ALUSrcB <= 2'b00;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b1; //
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b1;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       EXECUTER: begin
			ALUSrcA <= 2'b10; //
			ALUSrcB <= 2'b00; //
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b10; //
			Branch <= 1'b0;
			end
       ALUWB: begin
			ALUSrcA <= 2'b00;
			ALUSrcB <= 2'b00;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b1;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       EXECUTEI: begin
			ALUSrcA <= 2'b10;
			ALUSrcB <= 2'b01;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b10;
			Branch <= 1'b0;
			end
       JAL: begin 
			ALUSrcA <= 2'b01;
			ALUSrcB <= 2'b10;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b1;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       BEQ: begin
			ALUSrcA <= 2'b10;
			ALUSrcB <= 2'b00;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b01;
			Branch <= 1'b1;
			end
       LUI: begin
			ALUSrcA <= 2'b11;
			ALUSrcB <= 2'b01;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       JALR: begin
			ALUSrcA <= 2'b10;
			ALUSrcB <= 2'b01;
			ResultSrc <= 2'b10;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b1;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       JALRWB: begin
			ALUSrcA <= 2'b01;
			ALUSrcB <= 2'b10;
			ResultSrc <= 2'b10;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b1;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       AUIPC: begin
			ALUSrcA <= 2'b01;
			ALUSrcB <= 2'b01;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
			end
       default: begin// all zero's?
			ALUSrcA <= 2'b00;
			ALUSrcB <= 2'b00;
			ResultSrc <= 2'b00;
			AdrSrc <= 1'b0;
			IRWrite <= 1'b0;
			PCUpdate <= 1'b0;
			RegWrite <= 1'b0;
			MemWrite <= 1'b0;
			ALUOp <= 2'b00;
			Branch <= 1'b0;
		end
     endcase
	  
	end
          
endmodule
