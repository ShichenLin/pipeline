`include "write_back_if.vh"

module write_back(
	input logic CLK, nRST,
	write_back_if.wb wbif
);
	logic R_dREN, R_dWEN;
	regsel_t R_regSel;
	word_t R_nPC, R_ALUOut, R_lui, R_dmemload;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST || wbif.flush)
		begin
			R_dREN <= 0;
			R_dWEN <= 0;
			R_regSel <= 0;
			R_nPC <= 0;
			R_ALUOut <= 0;
			R_lui <= 0;
			R_dmemload <= 0;
			wbif.WEN <= 0;
			wbif.wsel <= 0;
		end
		else if(wbif.ihit)
		begin
			R_dREN <= wbif.dREN;
			R_dWEN <= wbif.dWEN;
			R_regSel <= wbif.regSel;
			R_nPC <= wbif.nPC;
			R_ALUOut <= wbif.ALUOut;
			R_lui <= wbif.lui;
			R_dmemload <= wbif.dmemload;
			wbif.WEN <= wbif.regWr;
			wbif.wsel <= wbif.regDst;
		end
	end
	
	always_comb
	begin
		casez(wbif.regSel)
			ALUr: wbif.wdat = R_ALUOut;
			DLoad: wbif.wdat = R_dmemload;
			Jal: wbif.wdat = R_nPC;
			Lui: wbif.wdat = R_lui;
		endcase
	end
endmodule
