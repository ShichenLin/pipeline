`ifndef BRANCH_PREDICTOR_IF_VH
`define BRANCH_PREDICTOR_IF_VH

`include "cpu_types_pkg.vh"

interface branch_predictor_if;
	logic select;
	word_t PC, nxtPC;
	logic br;
	logic br_result; //0:not taken 1:taken
	word_t braddr;
	logic taken;
	
	modport bp (
		input PC, br, br_result, braddr, brPC
		output nxtPC, select, taken
	);
	
endinterface

`endif
