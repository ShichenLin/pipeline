`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface hazard_unit_if;
	logic ihit, dhit;
	logic exld, meldst;
	regbits_t rs, rt, exrdst, merdst;
	logic [2:0] PCSrc;
	logic [1:0] PCSel;
	logic equal;
	//enable signals
	logic pcen, deen, exen, meen, wben;
	//flush signals
	logic deflush, exflush, meflush;
	modport hu (
		input ihit, dhit, exld, meldst, rs, rt, exrdst, merdst, PCSrc, equal,
		output pcen, deen, exen, meen, wben,
			   deflush, exflush, meflush,
			   PCSel
	);
endinterface
`endif
