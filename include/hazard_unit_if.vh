`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface hazard_unit_if;
	logic ihit, dhit;
	logic ldst;
	//enable signals
	logic pcen, deen, exen, meen, wben;
	//flush signals
	logic deflush, exflush, meflush;
	modport hu (
		input ihit, dhit, ldst,
		output pcen, deen, exen, meen, wben,
			   deflush, exflush, meflush
	);
endinterface
`endif
