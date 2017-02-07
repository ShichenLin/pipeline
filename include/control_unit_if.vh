`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

`include "cpu_types_pkg.vh"
`include "control_unit_pkg.vh"
import cpu_types_pkg::*;
import control_unit_pkg::*;

interface control_unit_if;

	word_t instr;
	alusrc_t ALUSrc;
	logic dREN, dWEN;
	aluop_t ALUOp;
	regsel_t RegSel;
	regbit_t RegDst;
	pcsrc_t PCSrc;
	logic RegWr, ExtOp; //ExtOp 0:zero 1:sign

	modport cu (
		input 	instr,
		output 	ALUSrc, ALUOp,
				RegSel, RegWr, RegDst,
				ExtOp, PCSrc,
				dREN, dWEN
	);

	modport tb (
		input 	ALUSrc, ALUOp,
				RegSel, RegWr, RegDst,
				ExtOp, PCSrc,
				dREN, dWEN,
		output 	instr
	);

endinterface

`endif
