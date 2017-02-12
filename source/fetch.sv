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
	logic [3:0] jPC;
  always_ff @(posedge CLK, negedge nRST) begin
     if (nRST == 0) begin
       jPC = '0;
     end else begin
       jPC = PC[31:28];
     end
  end
	always_comb
	begin
		casez(pcif.PCSrc)
			2'd0:	nxtPC = PC + 4; //normal
			2'd3:	nxtPC = PC + 4 + {{14{pcif.imm[15]}}, pcif.imm, 2'b0}; //branch
			2'd1:	nxtPC = pcif.jraddr; //jr
			2'd2:	nxtPC = {jPC, pcif.jaddr, 2'b0}; //j
		endcase
	end

	assign pcif.imemaddr = PC;
	assign pcif.nPC = PC + 4;
endmodule
