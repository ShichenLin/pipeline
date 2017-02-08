`include "memory_if.vh"

module memory(
	input logic CLK, nRST,
	memory_if.me meif
);

	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			meif.dmemREN <= 0;
			meif.dmemWEN <= 0;
			meif.nPC_next <= 0;
			meif.regWr_next <= 0;
			meif.regSel_next <= 0;
			meif.regDst_next <= 0;
			meif.ALUOut_next <= 0;
			meif.halt_next <= 0;
      		meif.dmemstore_next <= 0;
      		meif.lui_next <= 0;
		end
		else if(meif.flush)
		begin
			meif.dmemREN <= 0;
			meif.dmemWEN <= 0;
			meif.nPC_next <= 0;
			meif.regWr_next <= 0;
			meif.regSel_next <= 0;
			meif.regDst_next <= 0;
			meif.ALUOut_next <= 0;
			meif.halt_next <= 0;
      		meif.dmemstore_next <= 0;
      		meif.lui_next <= 0;
		end
		else if(meif.meen)
		begin
			meif.dmemREN <= 0;
			meif.dmemWEN <= 0;
			meif.dmemREN <= meif.dREN;
			meif.dmemWEN <= meif.dWEN;
			meif.nPC_next <= meif.nPC;
			meif.regWr_next <= meif.regWr;
			meif.regSel_next <= meif.regSel;
			meif.regDst_next <= meif.regDst;
			meif.ALUOut_next <= meif.ALUOut;
			meif.halt_next <= meif.halt;
     		meif.dmemstore_next <= meif.dmemstore;
      		meif.lui_next <= meif.lui;
		end
	end
endmodule
