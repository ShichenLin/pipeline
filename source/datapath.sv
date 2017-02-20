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
  	forwarding_unit_if fuif();
  	branch_predictor_if bpif();
  	
	// instrution flow
  	word_t instru_ex, instru_ex_next,
  	instru_me, instru_me_next, instru_wb, instru_wb_next;
  	assign instru_ex = deif.instr;
  	assign instru_me = instru_ex_next;
  	assign instru_wb = instru_me_next;
  	
	// wrappers
	hazard_unit hu (CLK, nRST, huif);
	fetch #(.PC_INIT(PC_INIT)) pc (CLK, nRST, pcif);
	decode de (CLK, nRST, deif);
	execute ex (CLK, nRST, instru_ex, instru_ex_next, exif);
	memory me (CLK, nRST, instru_me, instru_me_next, meif);
	write_back wb (CLK, nRST, instru_wb, instru_wb_next, wbif);
  	forwarding_unit fu (fuif);
  	branch_predictor bp (bpif);
  	
	//forward_unit
	assign fuif.instru_de = deif.instr;
	assign fuif.regWr_de = deif.regWr_next;
	assign fuif.regSel_de = deif.regSel_next;

	assign fuif.ALUOut_ex = exif.ALUOut_next;
  	assign fuif.lui_ex = exif.lui_next;
  	assign fuif.npc_ex = exif.nPC_next;
  	assign fuif.rs_ex = exif.rs_next;
  	assign fuif.rt_ex = exif.rt_next;
  	assign fuif.regDst_ex = exif.regDst_next;
  	assign fuif.regWr_ex = exif.regWr_next;
  	assign fuif.regSel_ex = exif.regSel_next;
  	assign fuif.dWEN_ex = exif.dWEN_next;
  	assign fuif.ALUSrc_ex = exif.ALUSrc_next;

  	assign fuif.ALUOut_me = meif.ALUOut_next;
  	assign fuif.lui_me = meif.lui_next;
  	assign fuif.npc_me = meif.nPC_next;
  	assign fuif.dmemload_me = dpif.dmemload;
  	assign fuif.regDst_me = meif.regDst_next;
  	assign fuif.regWr_me = meif.regWr_next;
  	assign fuif.regSel_me = meif.regSel_next;

  	assign fuif.wdat_wb = wbif.wdat;
  	assign fuif.regDst_wb = wbif.wsel;
  	assign fuif.regWr_wb = wbif.WEN;

	//datapath
	assign dpif.imemaddr = pcif.imemaddr;
	assign dpif.dmemaddr = meif.ALUOut_next;
	assign dpif.imemREN = ~meif.halt_next;
	assign dpif.dmemREN = meif.dmemREN;
	assign dpif.dmemWEN = meif.dmemWEN;
  	assign dpif.dmemstore = meif.dmemstore_next;
	assign dpif.halt = meif.halt_next;

	//branch_predictor
	assign bpif.PC = pcif.imemaddr;
	assign bpif.br = huif.br;
	assign bpif.br_result = huif.br_result;
	assign bpif.braddr = huif.braddr;
	assign bpif.brPC = exif.nPC_next;
	
	//hazard unit
	assign huif.ihit = dpif.ihit;
	assign huif.dhit = dpif.dhit;
	assign huif.meldst = meif.dmemREN | meif.dmemWEN;
	assign huif.exREN = exif.dREN_next;
	assign huif.exWEN = exif.dWEN_next;
	assign huif.rs = deif.rs_next;
	assign huif.rt = deif.rt_next;
	assign huif.exrdst = exif.regDst_next;
	assign huif.merdst = meif.regDst_next;
	assign huif.PCSrc = deif.PCSrc;
	assign huif.equal = exif.equal;
	assign huif.imm = exif.brimm_next;
	assign huif.nPC = exif.nPC_next;
	assign huif.taken = bpif.taken;
	
	//fetch
	assign pcif.brPC = exif.nPC_next;
	assign pcif.braddr = huif.braddr;
	assign pcif.jPC = deif.jPC;
	assign pcif.jaddr = deif.instr[25:0];
	assign pcif.jraddr = fuif.jrForwarding_fe ? fuif.jraddr_fe : deif.rdat1_next;
	assign pcif.PCSrc = huif.PCSel;
	assign pcif.pcen = huif.pcen;
	assign pcif.psel = huif.select;
	assign pcif.pPC = nxtPC;
	
	//decode
	assign deif.PC = pcif.imemaddr;
	assign deif.instru = dpif.imemload;
	assign deif.nPC = pcif.nPC;
	assign deif.WEN = wbif.WEN;
	assign deif.wdat = wbif.wdat;
	assign deif.wsel = wbif.wsel;
	assign deif.flush = huif.deflush;
	assign deif.deen = huif.deen;
	
	//execute
	assign exif.brimm = deif.brimm;
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
	assign exif.imm = deif.imm;
	assign exif.shamt = deif.shamt_next;
	assign exif.rt = deif.rt_next;
	assign exif.rs = deif.rs_next;
  	assign exif.lui = deif.lui_next;

	//forwarding
	assign exif.forA = fuif.forA_ex;
  	assign exif.forB = fuif.forB_ex;
	assign exif.srcA = fuif.srcA_ex;
	assign exif.srcB = fuif.srcB_ex;

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
	assign meif.dmemstore = (fuif.srcDmemstore_ex)? fuif.forDmemstore_ex : exif.dmemstore_next;

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
