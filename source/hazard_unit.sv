`include "hazard_unit_if.vh"

module hazard_unit(
	hazard_unit_if.hu huif
);
	always_comb
	begin
		huif.deflush = 0;
		huif.exflush = 0;
		huif.meflush = 0;		
		if(huif.ldst)
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
		else if(huif.ihit) //move pipe forward
		begin
			huif.pcen = 1;
			huif.deen = 1;
			huif.exen = 1;
			huif.meen = 1;
			huif.wben = 1;
		end
		else begin //stall pipe
			huif.pcen = 0;
			huif.deen = 0;
			huif.exen = 0;
			huif.meen = 0;
			huif.wben = 0;
		end
	end
endmodule
