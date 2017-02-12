/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

`include "hazard_unit_if.vh"
`include "fetch_if.vh"
`include "decode_if.vh"
`include "execute_if.vh"
`include "memory_if.vh"
`include  "write_back_if.vh"

module datapath (
  	input logic CLK, nRST,
  	datapath_cache_if.dp dpif
);

	parameter PC_INIT = 0;

  	// import types
  	import cpu_types_pkg::*;

	// interfaces
	hazard_unit_if huif();
	fetch_if pcif();
	decode_if deif();
	execute_if exif();
	memory_if meif();
	write_back_if wbif();
  forward_unit fuif();
// instrution flow
  word_t instr, instru_ex, instru_ex_next,
  instru_me, instru_me_next, instru_wb, instru_wb_next;
  assign instru_ex = instr;
  assign instru_me = instru_ex_next;
  assign instru_wb = instru_me_next;
	// wrappers
	hazard_unit hu (huif);
	fetch #(.PC_INIT(PC_INIT)) pc (CLK, nRST, pcif);
	decode de (CLK, nRST, instr, deif);
	execute ex (CLK, nRST, instru_ex, instru_ex_next, exif);
	memory me (CLK, nRST, instru_me, instru_me_next, meif);
	write_back wb (CLK, nRST, instru_wb, instru_wb_next, wbif);
  forward_unit fu(fuif);
  //forward_unit
  assign fuif.instr_de = instr;
  assign fuif.regWr_de = deif.regWr_next;
  assign fuif.regSel_de = deif.regSel_next;

  assign fuif.ALUOut_ex = exif.ALUOut_next;
  assign fuif.lui_ex = exif.lui_next;
  assign fuif.npc_ex = exif.npc_next;
  assign fuif.rs_ex = exif.rs_next;
  assign fuif.rt_ex = exif.rt_next;
  assign fuif.regDst_ex = exif.regDst_next;
  assign fuif.regWr_ex = exif.regWr_next;
  assign fuif.regSel_ex = exif.regSel_next;

  assign fuif.ALUOut_me = meif.ALUOut_next;
  assign fuif.lui_me = meif.lui_next;
  assign fuif.npc_me = meif.npc_next;
  assign fuif.dmemload_me = meif.dmemload_next;
  assign fuif.regDst_me = meif.regDst_next;
  assign fuif.regWr_me = meif.regWr_next;
  assign fuif.regSel_me = meif.regSel_next;

  assign fuif.wdat_wb = wbif.wdat_next;
  assign fuif.regDst_wb = wbif.regDst_next;
  assign fuif.regWr_wb = wbif.regWr_next;
  assign fuif.regSel_wb = wbif.regSel_next;

	//datapath
	assign dpif.imemaddr = pcif.imemaddr;
	assign dpif.dmemaddr = meif.ALUOut_next;
	assign dpif.imemREN = ~meif.halt_next;
	assign dpif.dmemREN = meif.dmemREN;
	assign dpif.dmemWEN = meif.dmemWEN;
  assign dpif.dmemstore = meif.dmemstore_next;
	assign dpif.halt = meif.halt_next;

	//hazard unit
	assign huif.ihit = dpif.ihit;
	assign huif.dhit = dpif.dhit;
	assign huif.ldst = meif.dmemREN | meif.dmemWEN;

	//fetch
	assign pcif.jaddr = 0;
	assign pcif.jraddr = 0;
	assign pcif.imm = 0;
	assign pcif.PCSrc = 2'd0;
	assign pcif.equal = 0;
	assign pcif.pcen = huif.pcen;

	//decode
	assign deif.instru = dpif.imemload;
	assign deif.nPC = pcif.nPC;
	assign deif.WEN = wbif.WEN;
	assign deif.wdat = wbif.wdat;
	assign deif.wsel = wbif.wsel;
	assign deif.flush = huif.deflush;
	assign deif.deen = huif.deen;

	//execute
	assign exif.halt = deif.halt;
	assign exif.flush = huif.exflush;
	assign exif.exen = huif.exen;
	assign exif.nPC = deif.nPC_next;
	assign exif.dWEN = deif.dWEN_next;
	assign exif.dREN = deif.dREN_next;
	assign exif.regWr = deif.regWr_next;
	assign exif.regSel = deif.regSel_next;
	assign exif.regDst = deif.regDst_next;
	assign exif.ALUOp = deif.ALUOp_next;
	assign exif.ALUSrc = deif.ALUSrc_next;
	assign exif.rdat1 = deif.rdat1_next;
	assign exif.rdat2 = deif.rdat2_next;
	assign exif.imm = deif.imm_next;
	assign exif.shamt = deif.shamt_next;
	assign exif.rt = deif.rt_next;
	assign exif.rs = deif.rs_next;
  assign exif.lui = deif.lui_next;
/*
	//forwarding
	assign exif.forData = 0;
	assign exif.srcA = 0;
	assign exif.srcB = 0;
*/
	//memory
	assign meif.halt = exif.halt_next;
	assign meif.nPC = exif.nPC_next;
	assign meif.regWr = exif.regWr_next;
	assign meif.dREN = exif.dREN_next;
	assign meif.dWEN = exif.dWEN_next;
	assign meif.regSel = exif.regSel_next;
	assign meif.regDst = exif.regDst_next;
	assign meif.ALUOut = exif.ALUOut_next;
	assign meif.flush = huif.meflush;
	assign meif.meen = huif.meen;
	assign meif.lui = exif.lui_next;
	assign meif.dmemstore = exif.dmemstore_next;

	//write_back
	assign wbif.nPC = meif.nPC_next;
	assign wbif.regWr = meif.regWr_next;
	assign wbif.regSel = meif.regSel_next;
	assign wbif.regDst = meif.regDst_next;
	assign wbif.ALUOut = meif.ALUOut_next;
	assign wbif.dmemload = dpif.dmemload;
	assign wbif.wben = huif.wben;
  	assign wbif.lui = meif.lui_next;

endmodule
