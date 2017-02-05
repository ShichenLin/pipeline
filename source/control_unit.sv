`include "control_unit_if.vh"

module control_unit(
	control_unit_if.cu cuif
);
	
	always_comb
	begin
		cuif.RegWr = 0;
		cuif.ALUSrc = ALURT;
		cuif.RegSel = ALUr;
		cuif.PCSrc = Norm;
		cuif.RegDst = RegRD;
		cuif.ExtOp = 0;
		cuif.dWEN = 0;
		cuif.dREN = 0;
		cuif.ALUOp = ALU_ADD;
		casez(cuif.instr[31:26])
			RTYPE: begin
				cuif.RegWr = cuif.ihit;
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
				cuif.RegWr = cuif.ihit;
				cuif.PCSrc = PCJ;
				cuif.RegSel = Jal;
				cuif.RegDst = RegJal;
			end
			BEQ: begin
				cuif.ALUOp = ALU_SUB;
				cuif.PCSrc = cuif.equal ? Bran : Norm;
			end
			BNE: begin
				cuif.ALUOp = ALU_SUB;
				cuif.PCSrc = cuif.equal ? Norm : Bran;
			end
			ADDI,
			ADDIU: begin
				cuif.RegWr = cuif.ihit;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_ADD;
				cuif.ExtOp = 1;
				cuif.RegDst = RegRT;
			end
			SLTI: begin
				cuif.RegWr = cuif.ihit;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_SLT;
				cuif.ExtOp = 1;
				cuif.RegDst = RegRT;
			end
			SLTIU: begin
				cuif.RegWr = cuif.ihit;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_SLTU;
				cuif.RegDst = RegRT;
			end
			ANDI: begin
				cuif.RegWr = cuif.ihit;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_AND;
				cuif.RegDst = RegRT;
			end
			ORI: begin
				cuif.RegWr = cuif.ihit;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_OR;
				cuif.RegDst = RegRT;
			end
			XORI: begin
				cuif.RegWr = cuif.ihit;
				cuif.ALUSrc = Imm;
				cuif.ALUOp = ALU_XOR;
				cuif.RegDst = RegRT;
			end
			LUI: begin
				cuif.RegWr = cuif.ihit;
				cuif.RegSel = Lui;
				cuif.RegDst = RegRT;
			end
			LW: begin
				cuif.RegDst = RegRT;
				cuif.RegWr = cuif.dhit;
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
