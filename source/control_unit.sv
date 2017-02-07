`include "control_unit_if.vh"

module control_unit(
	control_unit_if.cu cuif
);
	regbits_t rs, rt, rd;
	
	assign rs = cuif.instr[25:21];
	assign rt = cuif.instr[20:16];
	assign rd = cuif.instr[15:11];
	
	always_comb
	begin
		cuif.RegWr = 0;
		cuif.ALUSrc = ALURT;
		cuif.RegSel = ALUr;
		cuif.PCSrc = Norm;
		cuif.RegDst = rd;
		cuif.ExtOp = 0;
		cuif.dWEN = 0;
		cuif.dREN = 0;
		cuif.ALUOp = ALU_ADD;
		casez(cuif.instr[31:26])
			RTYPE: begin
				cuif.RegWr = 1;
				casez(cuif.instr[5:0])
					SLL: begin
						cuif.ALUOp = ALU_SLL;
						cuif.ALUSrc = Shamt;
					end
					SRL: begin
						cuif.ALUOp = ALU_SRL;
						cuif.ALUSrc = Shamt;
					end
					JR: begin
						cuif.RegWr = 0;
						cuif.PCSrc = PCJr;
					end
					ADD,
					ADDU:
						cuif.ALUOp = ALU_ADD;
					SUB,
					SUBU:
						cuif.ALUOp = ALU_SUB;
					AND:
						cuif.ALUOp = ALU_AND;
					OR:
						cuif.ALUOp = ALU_OR;
					XOR:
						cuif.ALUOp = ALU_XOR;
					NOR:
						cuif.ALUOp = ALU_NOR;
					SLT:
						cuif.ALUOp = ALU_SLT;
					SLTU:
						cuif.ALUOp = ALU_SLTU;
				endcase
			end
			J: begin
				cuif.PCSrc = PCJ;
			end
			JAL: begin
				cuif.RegWr = 1;
				cuif.PCSrc = PCJ;
				cuif.RegSel = Jal;
				cuif.RegDst = 5'd31;
			end
			BEQ: begin
				cuif.ALUOp = ALU_SUB;
				cuif.PCSrc = Bran;
			end
			BNE: begin
				cuif.ALUOp = ALU_SUB;
				cuif.PCSrc = Bran;
			end
			ADDI,
			ADDIU: begin
				cuif.RegWr = 1;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_ADD;
				cuif.ExtOp = 1;
				cuif.RegDst = rt;
			end
			SLTI: begin
				cuif.RegWr = 1;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_SLT;
				cuif.ExtOp = 1;
				cuif.RegDst = rt;
			end
			SLTIU: begin
				cuif.RegWr = 1;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_SLTU;
				cuif.RegDst = rt;
			end
			ANDI: begin
				cuif.RegWr = 1;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_AND;
				cuif.RegDst = rt;
			end
			ORI: begin
				cuif.RegWr = 1;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_OR;
				cuif.RegDst = rt;
			end
			XORI: begin
				cuif.RegWr = 1;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_XOR;
				cuif.RegDst = rt;
			end
			LUI: begin
				cuif.RegWr = 1;
				cuif.RegSel = Lui;
				cuif.RegDst = rt;
			end
			LW: begin
				cuif.RegDst = rt;
				cuif.RegWr = 1;
				cuif.RegSel = DLoad;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_ADD;
				cuif.dREN = 1;
			end
			SW: begin
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_ADD;
				cuif.dWEN = 1;
			end
		endcase
	end
endmodule
