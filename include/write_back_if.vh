`ifndef WRITE_BACK_IF_VH
`define WRITE_BACK_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface write_back_if;
	//inputs
	logic wben;
	logic regWr;
	logic [2:0] regSel;
	regbits_t regDst;
	word_t nPC, ALUOut, lui, dmemload;
	//outputs
	logic WEN;
	word_t wdat;
	regbits_t wsel;
	
	modport wb (
		input regWr, regSel, regDst, nPC, ALUOut, lui, dmemload, wben,
		output WEN, wdat, wsel
	);
	
endinterface
`endif
