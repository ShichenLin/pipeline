`include "hazard_unit_if.vh"

module hazard_unit(
	input logic CLK, nRST,
	hazard_unit_if.hu huif
);

	logic [2:0] R_PCSrc;

	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
			R_PCSrc <= '0;
		else if(huif.ihit)
			R_PCSrc <= huif.PCSrc;
	end

	always_comb
	begin
		huif.deflush = 0;
		huif.exflush = 0;
		huif.meflush = 0;
		huif.PCSel = 2'd0;
		if(huif.meldst)
		begin
			if(huif.ihit && huif.dhit) //move pipe forward
			begin
				huif.pcen = 1;
				huif.deen = 1;
				huif.exen = 1;
				huif.meen = 1;
				huif.wben = 1;
			end
			else if(~huif.ihit && huif.dhit) //stall before mem
			begin
				huif.pcen = 0;
				huif.deen = 0;
				huif.exen = 0;
				huif.meen = 0;
				huif.wben = 1;
				huif.meflush = 1;
			end
			else if(huif.ihit && ~huif.dhit) //stall pipe
			begin
				huif.pcen = 0;
				huif.deen = 0;
				huif.exen = 0;
				huif.meen = 0;
				huif.wben = 0;
			end
			else begin //stall pipe
				huif.pcen = 0;
				huif.deen = 0;
				huif.exen = 0;
				huif.meen = 0;
				huif.wben = 0;
			end
		end
		else if(huif.exREN | huif.exWEN) //insert a bubble between decode and execute if necessary
		begin
			if(huif.rs == huif.merdst || huif.rt == huif.merdst) //sitting between dependent instructions
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
				huif.pcen = 0;
				huif.deen = 0;
				huif.exen = 0;
				huif.meen = huif.ihit;
				huif.wben = huif.ihit;
				huif.exflush = huif.ihit;
			end
			else begin
				huif.pcen = huif.ihit;
				huif.deen = huif.ihit;
				huif.exen = huif.ihit;
				huif.meen = huif.ihit;
				huif.wben = huif.ihit;
			end
		end
		else if(R_PCSrc == 3'd3 && huif.equal) //beq
		begin
			huif.PCSel = 2'd3;
			huif.pcen = huif.ihit;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = huif.ihit;
			huif.wben = huif.ihit;
			huif.exflush = huif.ihit;
			huif.deflush = huif.ihit;
		end
		else if(R_PCSrc == 3'd4 && ~huif.equal) //bne
		begin
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
