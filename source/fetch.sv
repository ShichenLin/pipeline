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
		else if(pcif.ihit)
			PC <= nxtPC;
	end
	
	always_comb
	begin
		casez(pcif.PCSrc)
			Norm:	nxtPC = PC + 4;
			Bran:	nxtPC = PC + 4 + {{14{pcif.imm[15]}}, pcif.imm, 2'b0};
			PCJr:	nxtPC = rfif.rdat1;
			PCJ:	nxtPC = {PC[31:28], pcif.jaddr, 2'b0};
		endcase
	end
	
	assign pcif.imemaddr = PC;
	assign pcif.nPC = PC + 4;
endmodule
