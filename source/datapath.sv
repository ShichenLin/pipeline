/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"
`include "alu_if.vh"
`include "register_file_if.vh"
`include "control_unit_if.vh"
`include  "request_unit_if.vh"

module datapath (
  	input logic CLK, nRST,
  	datapath_cache_if.dp dpif
);
  	// import types
  	import cpu_types_pkg::*;

  	// pc init
  	parameter PC_INIT = 0;

	// interfaces
	alu_if aluif();
	register_file_if rfif();
	control_unit_if cuif();
	request_unit_if ruif();
	
	// wrappers
	`ifndef mapped
		alu ALU (aluif);
		register_file rf (CLK, nRST, rfif);
		control_unit cu (cuif);
		request_unit ru (CLK, nRST, ruif);
	`else
		
	`endif
	
	// declarations
	regbits_t rd, rt, rs;
	logic [IMM_W-1:0] imm;
	logic [SHAM_W-1:0] shamt;
	word_t PC, nxtPC, jaddr;
	logic nxthalt;
	
	//variables assignments
	assign imm = dpif.imemload[15:0];
	assign jaddr = {dpif.imemload[25:0], 2'b0};
	assign shamt = dpif.imemload[10:6];
	assign rd = dpif.imemload[15:11];
	assign rt = dpif.imemload[20:16];
	assign rs = dpif.imemload[25:21];
	
	//register_file assignments
	assign rfif.rsel1 = rs;
	assign rfif.rsel2 = rt;
	assign rfif.WEN = cuif.RegWr;
	assign aluif.portA = rfif.rdat1;
	assign dpif.dmemstore = rfif.rdat2;
	
	//ALU assignments
	assign dpif.dmemaddr = aluif.portO;
	assign aluif.ALUOP = cuif.ALUOp;
	assign cuif.equal = aluif.zero;
	
	//control_unit assignemnts
	assign cuif.instr = dpif.imemload;
	assign cuif.dhit = dpif.dhit;
	assign cuif.ihit = dpif.ihit;
	
	//request_unit assignments
	assign ruif.dREN_c = dpif.halt ? 0 : cuif.dREN;
	assign ruif.dWEN_c = dpif.halt? 0 : cuif.dWEN;
	assign dpif.dmemREN = ruif.dREN_r;
	assign dpif.dmemWEN = ruif.dWEN_r;
	assign ruif.ihit = dpif.ihit;
	assign ruif.dhit = dpif.dhit;
	
	//datapath_assignments
	assign dpif.imemREN = ~dpif.halt;
	assign dpif.imemaddr = PC;
	
	//others
	assign dpif.datomic = 0;
	assign nxthalt = dpif.imemload[31:26] == 6'b111111;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			PC <= '0;
			dpif.halt <= 0;
		end
		else if(dpif.ihit)
		begin
			PC <= nxtPC;
			dpif.halt <= nxthalt;
		end
		else begin
			PC <= PC;
			dpif.halt <= dpif.halt;
		end
	end
	
	always_comb
	begin
		casez(cuif.RegSel)
			ALUr:	rfif.wdat = aluif.portO;
			DLoad:	rfif.wdat = dpif.dmemload;
			Jal:	rfif.wdat = PC + 4;
			Lui:	rfif.wdat = {imm, 16'b0};
		endcase
		casez(cuif.PCSrc)
			Norm:	nxtPC = PC + 4;
			Bran:	nxtPC = PC + 4 + {{14{imm[15]}}, imm, 2'b0};
			PCJr:	nxtPC = rfif.rdat1;
			PCJ:	nxtPC = {PC[31:28], jaddr};
		endcase
		casez(cuif.RegDst)
			RegRD:	rfif.wsel = rd;
			RegRT:	rfif.wsel = rt;
			RegJal: rfif.wsel = 5'd31;
			default:rfif.wsel = rd;
		endcase
		casez(cuif.ALUSrc)
			ALURT:	aluif.portB = rfif.rdat2;
			Imm:	aluif.portB = cuif.ExtOp ? {{16{imm[15]}}, imm} : {16'b0, imm};
			Shamt:	aluif.portB = {27'b0, shamt};
			default:aluif.portB = rfif.rdat2;
		endcase
	end
	
endmodule
