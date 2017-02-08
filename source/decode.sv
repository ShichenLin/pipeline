`include "decode_if.vh"
`include "control_unit_if.vh"

module decode(
	input logic CLK, nRST,
	decode_if.de deif
);

	word_t instr;
	regbits_t shamt;
	logic [15:0] imm;
	control_unit_if cuif();
	register_file_if rfif();

	control_unit cu (cuif);
	register_file rf (CLK, nRST, rfif);

	assign deif.rs_next = instr[25:21];
	assign deif.rt_next = instr[20:16];
	assign imm = instr[15:0];
	assign cuif.instr = instr;
	assign deif.shamt_next = {26'b0, instr[10:6]};
	assign deif.imm_next = cuif.ExtOp ? {{16{imm[15]}}, imm} : {16'b0, imm};
	assign deif.lui_next = {imm, 16'b0};
	assign deif.ALUOp_next = cuif.ALUOp;
	assign deif.ALUSrc_next = cuif.ALUSrc;
	assign deif.regSel_next = cuif.RegSel;
	assign deif.regDst_next = cuif.RegDst;
	assign deif.PCSrc_next = cuif.PCSrc;
	assign deif.rdat1_next = rfif.rdat1;
	assign deif.rdat2_next = rfif.rdat2;
	assign deif.dREN_next = cuif.dREN;
	assign deif.dWEN_next = cuif.dWEN;
	assign deif.regWr_next = cuif.RegWr;
	assign rfif.rsel1 = instr[25:21];
	assign rfif.rsel2 = instr[20:16];
	assign rfif.WEN = deif.WEN;
	assign rfif.wdat = deif.wdat;
	assign rfif.wsel = deif.wsel;
	assign deif.halt = instr[31:26] == 6'b111111;
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			deif.nPC_next <= 0;
			instr <= 0;
		end
		else if(deif.flush)
		begin
			deif.nPC_next <= 0;
			instr <= 0;
		end
		else if(deif.deen)
		begin
			deif.nPC_next <= deif.nPC;
			instr <= deif.instru;
		end
	end
endmodule
