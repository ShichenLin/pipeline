/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "fetch_if.vh"
`include "decode_if.vh"
`include "execute_if.vh"
`include "memory_if.vh"
`include  "write_back_if.vh"

module datapath (
  	input logic CLK, nRST,
  	datapath_cache_if.dp dpif
);
  	// import types
  	import cpu_types_pkg::*;
    import control_unit_pkg::*;
	// interfaces
	fetch_if pcif();
	decode_if deif();
	execute_if exif();
	memory_if meif();
	write_back_if wbif();
	
	// wrappers
	fetch pc (CLK, nRST, pcif);
	decode de (CLK, nRST, deif);
	execute ex (CLK, nRST, exif);
	memory me (CLK, nRST, meif);
	write_back wb (CLK, nRST, wbif);
	
	//datapath
	assign dpif.imemaddr = pcif.imemaddr;
	assign dpif.dmemstore = meif.rtdat;
	assign dpif.dmemaddr = meif.ALUOut_next;
	assign dpif.imemREN = ~deif.halt;
	assign dpif.dmemREN = meif.dmemREN;
	assign dpif.dmemWEN = meif.dmemWEN;
	assign dpif.halt = deif.halt;
	
	//fetch
	assign pcif.jaddr = 0;
	assign pcif.jraddr = 0;
	assign pcif.imm = 0;
	assign pcif.PCSrc = Norm;
	assign pcif.equal = 0;
	assign pcif.ihit = dpif.ihit;
	
	//decode
	assign deif.instru = dpif.imemload;
	assign deif.nPC = pcif.nPC;
	assign deif.ihit = dpif.ihit;
	assign deif.WEN = wbif.WEN;
	assign deif.wdat = wbif.wdat;
	assign deif.wsel = wbif.wsel;
	assign deif.flush = 0;
	
	//execute
	assign exif.flush = 0;
	assign exif.ihit = dpif.ihit;
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
	//forwarding
	assign exif.forData = 0;
	assign exif.srcA = 0;
	assign exif.srcB = 0;
	
	//memory
	assign meif.nPC = exif.nPC_next;
	assign meif.regWr = exif.regWr_next;
	assign meif.dREN = exif.dREN_next;
	assign meif.dWEN = exif.dWEN_next;
	assign meif.regSel = exif.regSel_next;
	assign meif.regDst = exif.regDst_next;
	assign meif.ALUOut = exif.ALUOut;
	assign meif.dmemload = dpif.dmemload;
	assign meif.dhit = dpif.dhit;
	assign meif.ihit = dpif.ihit;
	assign meif.flush = 0;
	
	//write_back
	assign wbif.nPC = meif.nPC_next;
	assign wbif.regWr = meif.regWr_next;
	assign wbif.regSel = meif.regSel_next;
	assign wbif.regDst = meif.regDst_next;
	assign wbif.ALUOut = meif.ALUOut_next;
	assign wbif.dmemload = meif.dmemload;
	assign wbif.dhit = dpif.dhit;
	assign wbif.ihit = dpif.ihit;
	assign wbif.flush = 0;
	
endmodule
