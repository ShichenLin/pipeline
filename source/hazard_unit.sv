`include "hazard_unit_if.vh"

module hazard_unit(
	input logic CLK, nRST,
	hazard_unit_if.hu huif
);
	
	logic [1:0] R_PCSrc;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
			R_PCSrc <= '0
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
		else if(huif.exldst)
		begin
			if(huif.rs == huif.exrdst || huif.rt == huif.exrdst || huif.rs == huif.merdst || huif.rt == huif.merdst) //insert a bubble between decode and execute
			begin
				if(huif.ihit)
				begin
					huif.pcen = 0;
					huif.deen = 0;
					huif.exen = 0;
					huif.meen = 1;
					huif.wben = 1;
					huif.exflush = 1;
				end
				else begin
					huif.pcen = 0;
					huif.deen = 0;
					huif.exen = 0;
					huif.meen = 0;
					huif.wben = 0;
				end
			end
		end
		else if(R_PCSrc == 3'd3 && huif.equal) //beq
		begin
			huif.PCSel = 2'd3;
			if(huif.ihit)
				begin
					huif.pcen = 0;
					huif.deen = 0;
					huif.exen = 0;
					huif.meen = 1;
					huif.wben = 1;
					huif.exflush = 1;
					huif.deflush = 1;
				end
				else begin
					huif.pcen = 0;
					huif.deen = 0;
					huif.exen = 0;
					huif.meen = 0;
					huif.wben = 0;
				end
		end
		else if(R_PCSrc == 3'd4 && ~huif.equal) //bne
		begin
			huif.PCSel = 2'd3;
			if(huif.ihit)
				begin
					huif.pcen = 0;
					huif.deen = 0;
					huif.exen = 0;
					huif.meen = 1;
					huif.wben = 1;
					huif.exflush = 1;
					huif.deflush = 1;
				end
				else begin
					huif.pcen = 0;
					huif.deen = 0;
					huif.exen = 0;
					huif.meen = 0;
					huif.wben = 0;
				end
		end
		else if(huif.PCSrc == 2'd)
		else if(huif.ihit)
		begin
			huif.pcen = 1;
			huif.deen = 1;
			huif.exen = 1;
			huif.meen = 1;
			huif.wben = 1;
		end
		else begin
			huif.pcen = 0;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = 0;
			huif.wben = 0;
		end
	end
endmodule
