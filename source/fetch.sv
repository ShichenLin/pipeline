`include "fetch_if.vh"

module fetch(
	input logic CLK, nRST,
	fetch_if.pc pcif
);

	parameter PC_INIT = 0;
	word_t PC, nxtPC;

	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
			PC <= PC_INIT;
		else if(pcif.pcen)
			PC <= nxtPC;
	end
	
	always_comb
	begin
		casez(pcif.PCSrc)
			2'd0:	nxtPC = PC + 4; //normal
			2'd3:	nxtPC = pcif.brPC + {{14{pcif.imm[15]}}, pcif.imm, 2'b0}; //branch
			2'd1:	nxtPC = pcif.jraddr; //jr
			2'd2:	nxtPC = {pcif.jPC[31:28], pcif.jaddr, 2'b0}; //j
			default:nxtPC = PC + 4;
		endcase
	end

	assign pcif.imemaddr = PC;
	assign pcif.nPC = PC + 4;
endmodule
