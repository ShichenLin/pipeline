`include "register_file_if.vh"
//`include "cpu_types_pkg.vh"

module register_file
import cpu_types_pkg::*;
(
	input logic CLK, nRST,
	register_file_if.rf rfif
);
	
	word_t regs [31:0];
	
	always_ff @ (negedge CLK, negedge nRST)
	begin
		if(~nRST)
			regs <= '{default:'0};
		else
			if(rfif.WEN)
				regs[rfif.wsel] <= rfif.wsel != 0 ? rfif.wdat : 0;
	end
	
	assign rfif.rdat1 = regs[rfif.rsel1];
	assign rfif.rdat2 = regs[rfif.rsel2];
endmodule

