`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface hazard_unit_if;
	logic ihit, dhit;
	logic exREN, exWEN, meldst;
	regbits_t rs, rt, exrdst, merdst;
	logic [15:0] imm;
	logic [2:0] PCSrc;
	logic [1:0] PCSel;
	logic equal;
	word_t nPC, braddr;
	logic br, br_result, taken;
	//enable signals
	logic pcen, deen, exen, meen, wben;
	//flush signals
	logic deflush, exflush, meflush;
	
	modport hu (
		input ihit, dhit, meldst, rs, rt, exREN, exWEN, exrdst, merdst, PCSrc, equal, imm, nPC, taken,
		output pcen, deen, exen, meen, wben,
			   deflush, exflush, meflush,
			   PCSel, braddr, br, br_result
	);
	modport tb(
		input pcen, deen, exen, meen, wben,
			   deflush, exflush, meflush,
			   PCSel,
		output ihit, dhit, meldst, rs, rt, exREN, exWEN, exrdst, merdst, PCSrc, equal
	);
endinterface
`endif
