`include "execute_if.vh"

module execute(
	input logic CLK, nRST,
	execute_if.ex exif
);
	
	word_t nPC;
	logic dREN, dWEN, RegWr;
	regsel RegSel;
	regbit_t RegDst;
	aluop_t ALUop;
	alusrc_t ALUSrc;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		
	end
	
	always_comb
	begin
	
	end
endmodule
