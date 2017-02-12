`include "write_back_if.vh"

module write_back(
	input logic CLK, nRST,
  input word_t instru_wb,
  output word_t instru_wb_next,
	write_back_if.wb wbif
);
	logic [1:0] R_regSel;
	word_t R_nPC, R_ALUOut, R_lui, R_dmemload;

	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			R_regSel <= 2'd0;//alu output
			R_nPC <= 0;
			R_ALUOut <= 0;
			R_lui <= 0;
			R_dmemload <= 0;
			wbif.WEN <= 0;
			wbif.wsel <= 0;
      		instru_wb_next <= '0;
		end
		else if(wbif.wben)
		begin
			R_dmemload <= wbif.dmemload;
			R_regSel <= wbif.regSel;
			wbif.WEN <= wbif.regWr;
			wbif.wsel <= wbif.regDst;
			R_regSel <= wbif.regSel;
			R_nPC <= wbif.nPC;
			R_ALUOut <= wbif.ALUOut;
			R_lui <= wbif.lui;
			wbif.WEN <= wbif.regWr;
			wbif.wsel <= wbif.regDst;
      		instru_wb_next <= instru_wb;
		end
	end

	always_comb
	begin
		casez(R_regSel)
			2'd0: wbif.wdat = R_ALUOut;//alu output
			2'd3: wbif.wdat = R_dmemload;//data load
			2'd1: wbif.wdat = R_nPC;//jal
			2'd2: wbif.wdat = R_lui;//lui
		endcase
	end
endmodule
