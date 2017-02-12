`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface control_unit_if;

	word_t instr;
	logic [1:0] ALUSrc;
	logic dREN, dWEN;
	aluop_t ALUOp;
	logic [1:0] RegSel;
	regbits_t RegDst;
	logic [2:0] PCSrc;
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
