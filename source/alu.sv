`include "alu_if.vh"
import cpu_types_pkg::*;

module alu
(
	alu_if.alu aluif
);
	always_comb
	begin
		casez(aluif.ALUOP)
			ALU_SLL: begin
				aluif.portO = aluif.portA << aluif.portB;
				aluif.of = 0;
			end
			ALU_SRL: begin
				aluif.portO = aluif.portA >> aluif.portB;
				aluif.of = 0;
			end
			ALU_AND: begin
				aluif.portO = aluif.portA & aluif.portB;
				aluif.of = 0;
			end
			ALU_OR: begin
				aluif.portO = aluif.portA | aluif.portB;
				aluif.of = 0;
			end
			ALU_XOR: begin
				aluif.portO = aluif.portA ^ aluif.portB;
				aluif.of = 0;
			end
			ALU_NOR: begin
				aluif.portO = ~(aluif.portA | aluif.portB);
				aluif.of = 0;
			end
			ALU_ADD: begin
				aluif.portO = $signed(aluif.portA) + $signed(aluif.portB);
				if(~aluif.portO[31] && aluif.portA[31] && aluif.portB[31])
					aluif.of = 1;
				else if(aluif.portO[31] && ~aluif.portA[31] && ~aluif.portB[31])
					aluif.of = 1;
				else
					aluif.of = 0;
			end
			ALU_SUB: begin
				aluif.portO = $signed(aluif.portA) - $signed(aluif.portB);
				if(~aluif.portO[31] && aluif.portA[31] && ~aluif.portB[31])
					aluif.of = 1;
				else if(aluif.portO[31] && ~aluif.portA[31] && aluif.portB[31])
					aluif.of = 1;
				else
					aluif.of = 0;
			end
			ALU_SLT: begin
				aluif.portO = $signed(aluif.portA) < $signed(aluif.portB);
				aluif.of = 0;
			end
			ALU_SLTU: begin
				aluif.portO = aluif.portA < aluif.portB;
				aluif.of = 0;
			end
			default: begin
				aluif.portO = 0;
				aluif.of = 0;
			end
		endcase
	end
	
	assign aluif.neg = aluif.portO[31];
	assign aluif.zero = aluif.portO == 0;
endmodule
