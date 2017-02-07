`include "memory_if.vh"

module memory(
	input logic CLK, nRST,
	memory_if.me meif
);
	
	logic R_dREN, R_dWEN;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST || meif.flush)
		begin
			meif.dmemdREN <= 0;
			meif.dmemdWEN <= 0;
			meif.nPC_next <= 0;
			meif.regWr_next <= 0;
			meif.regSel_next <= 0;
			meif.regDst_next <= 0;
			meif.ALUOut_next <= 0;
			meif.dmemload_next <= 0;
		end
		else if(meif.ihit)
		begin
			meif.dmemdREN <= meif.dREN;
			meif.dmemdWEN <= meif.dWEN;
			meif.nPC_next <= meif.nPC;
			meif.regWr_next <= meif.regWr;
			meif.regSel_next <= meif.regSel;
			meif.regDst_next <= meif.regDst;
			meif.ALUOut_next <= meif.ALUOut;
			meif.dmemload_next <= meif.dmemload;
		end
	end
endmodule
