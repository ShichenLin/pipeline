`include "decode_write_back_if.vh"

module decode_write_back(
	input logic CLK, nRST,
	decode_write_back_if.dw dwif
);

	word_t instr;
	regbit_t rs, rt, shamt;
	logic [15:0] imm;
	control_unit_if cuif();
	register_file_if rfif();
	
	control_unit cu (cuif);
	register_file rf (rfif);
	
	assign rs = instr[25:21];
	assign rt = instr[20:16];
	assign imm = instr[15:0];
	assign cuif.instr = instr;
	assign shamt_next = {27'b0, instr[10:6]};
	assign dwif.imm_next = cuif.ExtOp ? {{16{imm[15]}, imm} : {16'b0, imm};
	assign dwif.lui_next = {imm, 16'b0}
	assign dwif.ALUOp_next = cuif.ALUOp;
	assign dwif.ALUSrc_next = cuif.ALUSrc;
	assign dwif.regSel_next = cuif.regSel;
	assign dwif.PCSrc_next = cuif.PCSrc;
	assign dwif.rdat1_next = rfif.rdat1;
	assign dwif.rdat2_next = rfif.rdat2;
	
	always_ff @ (posedge CLk, negedge nRST)
	begin
		if(~nRST || dwif.flush)
		begin
			dwif.nPC_next <= 0;
			instr <= 0;
		end
		else if(dwif.ihit)
			dwif.nPC_next <= dwif.nPCIn;
			instr <= dwif.instru;
		end
	end
	
	always_comb
	begin
		casez(dwif.regSel)
			ALUr: rfif.wdat = dwif.ALUOut;
			Dload: rfif.wdat = dwif.dmemload;
			Jal: rfif.wdat = dwif.nPC;
			Lui: rfif.wdat = dwif.lui;
		endcase
	end
endmodule
