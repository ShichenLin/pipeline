`include "hazard_unit_if.vh"

module hazard_unit(
	input logic CLK, nRST,
	hazard_unit_if.hu huif
);

	logic [2:0] R_PCSrc;
	logic br_taken;

	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			R_PCSrc <= 0;
			br_taken <= 0;
		end
		else if(huif.exflush)
		begin
			R_PCSrc <= 0;
			br_taken <= 0;
		end
		else if(huif.exen)
		begin
			R_PCSrc <= huif.PCSrc;
			br_taken <= huif.br_taken;
		end
	end

	assign huif.br = (R_PCSrc == 3 || R_PCSrc == 4) ? huif.ihit : 0;
	assign huif.br_result = ((R_PCSrc == 3'd3 && huif.equal) || (R_PCSrc == 3'd4 && ~huif.equal)) ? huif.ihit : 0;
	
	always_comb
	begin
		huif.deflush = 0;
		huif.exflush = 0;
		huif.meflush = 0;
		huif.PCSel = 2'd0;
		huif.braddr = 0;
		if(huif.meldst && (~huif.ihit || ~huif.dhit)) //when either ihit or dhit is not asserted during load or store, stall pipe
		begin
			if(huif.dhit) //stall before mem
			begin
				huif.pcen = 0;
				huif.deen = 0;
				huif.exen = 0;
				huif.meen = 0;
				huif.wben = huif.dhit;
				huif.meflush = huif.dhit;
			end
			else begin //stall pipe
				huif.pcen = 0;
				huif.deen = 0;
				huif.exen = 0;
				huif.meen = 0;
				huif.wben = 0;
			end
		end
		else if((huif.exREN || huif.exWEN) && (huif.rs == huif.merdst || huif.rt == huif.merdst)) //insert a bubble between decode and execute if lw/sw is sitting between dependent instructions
		begin
			huif.pcen = 0;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.exflush = huif.ihit;
		end
		else if(huif.exREN && huif.exrdst == 5'd31 && huif.PCSrc == 3'd1) //lw followed by a dependent jr
		begin
			huif.PCSel = 2'd3;
			huif.braddr = huif.nPC;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.exflush = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else if(R_PCSrc == 3'd3 && huif.equal && ~br_taken) //beq taken but predict not taken
		begin
			huif.braddr = huif.nPC + {{14{huif.imm[15]}}, huif.imm, 2'b0};
			huif.PCSel = 2'd3;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.exflush = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else if(R_PCSrc == 3'd3 && ~huif.equal && br_taken) //beq not taken but predict taken
		begin
			huif.braddr = huif.nPC;
			huif.PCSel = 2'd3;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.exflush = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else if(R_PCSrc == 3'd4 && ~huif.equal && ~br_taken) //bne taken but predict not taken
		begin
			huif.braddr = huif.nPC + {{14{huif.imm[15]}}, huif.imm, 2'b0};
			huif.PCSel = 2'd3;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.exflush = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else if(R_PCSrc == 3'd4 && huif.equal && br_taken) //bne not taken but predict taken
		begin
			huif.braddr = huif.nPC;
			huif.PCSel = 2'd3;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.exflush = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else if(huif.PCSrc == 3'd2) //j-type instruction
		begin
			huif.PCSel = 2'd2;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = huif.ihit;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else if(huif.PCSrc == 3'd1) //jr
		begin
			huif.PCSel = 2'd1;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = huif.ihit;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else begin
			huif.pcen = huif.ihit;
			huif.deen = huif.ihit;
			huif.exen = huif.ihit;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
		end
	end
endmodule
