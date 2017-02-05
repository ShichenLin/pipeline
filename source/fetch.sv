`include ""

module fetch(
	input logic CLK, nRST,
);

	parameter PC_INIT = 0;
	word_t PC, nxtPC, jaddr;
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if()
			PC <= PC_INIT;
		else if()
			PC <= PC;
		else
			PC <= nxtPC;
	end
	
	always_comb
	begin
		casez(cuif.PCSrc)
			Norm:	nxtPC = PC + 4;
			Bran:	nxtPC = PC + 4 + {{14{imm[15]}}, imm, 2'b0};
			PCJr:	nxtPC = rfif.rdat1;
			PCJ:	nxtPC = {PC[31:28], jaddr, 2'b0};
		endcase
	end
endmodule
