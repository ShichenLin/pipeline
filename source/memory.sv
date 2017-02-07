`include "memory_if.vh"

module memory(
	input logic CLK, nRST,
	memory_if.me meif
);
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST || meif.flush)
		begin
			meif.dmemREN <= 0;
			meif.dmemWEN <= 0;
			meif.nPC_next <= 0;
			meif.regWr_next <= 0;
			meif.regSel_next <= 0;
			meif.regDst_next <= 0;
			meif.ALUOut_next <= 0;
			meif.dmemload_next <= 0;
		end
		else if(meif.dhit)
		begin
			meif.dmemREN <= 0;
			meif.dmemWEN <= 0;
		end
		else if(meif.ihit)
		begin
			meif.dmemREN <= meif.dREN;
			meif.dmemWEN <= meif.dWEN;
			meif.nPC_next <= meif.nPC;
			meif.regWr_next <= meif.regWr;
			meif.regSel_next <= meif.regSel;
			meif.regDst_next <= meif.regDst;
			meif.ALUOut_next <= meif.ALUOut;
			meif.dmemload_next <= meif.dmemload;
		end
	end
endmodule
