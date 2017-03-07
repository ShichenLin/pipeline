`timescale 1 ns / 1 ns

module icache_tb;
	// clock period
	parameter PERIOD = 10;
	
	// signals
	logic CLK = 1, nRST;

	// clock
	always #(PERIOD/2) CLK++;
	
	//innterfaces
	caches_if cif ();
	datapath_cache_if dcif ();
	
	//program
	test PROG (CLK, dcif.ihit, cif.iREN, dcif.imemload,
			   nRST, dcif.imemREN, cif.iwait, dcif.imemaddr, cif.iload);
			   
	//DUT	
	icache ic (CLK, nRST, dcif, cif);
endmodule

program test(
	input logic CLK, ihit, iREN,
		  cpu_types_pkg::word_t imemload,
	output logic nRST, imemREN, iwait,
		   cpu_types_pkg::word_t imemaddr, iload
);
	initial
	begin
		nRST = 1;
		imemREN = 0;
		imemaddr = 32'd0;
		iwait = 1;
		iload = 32'd0;
		@(posedge CLK) nRST = 0;
		@(posedge CLK) nRST = 1;
		
		//compulsory miss
		@(posedge CLK) imemREN = 1;
		@(posedge CLK) if(iREN) $display("Correct iREN Case 1");
		else $display("Wrong iREN Case 1");
		@(posedge CLK) iload = 32'd12;
		iwait = 0;
		@(posedge CLK) iwait = 1;
		if(iREN) $display("Wrong iREN Case 1");
		else $display("Correct iREN Case 1");
		@(negedge CLK) if(ihit && imemload == 32'd12) $display("Correct Load Case 1");
		else $display("Wrong Load Case 1\n");
		imemREN = 0;
		
		//hit
		@(posedge CLK) imemREN = 1;
		@(negedge CLK) if(ihit && imemload == 32'd12) $display("Correct Load Case 2");
		else $display("Wrong Load Case 2");
		imemREN = 0;
		
		//conflict miss
		imemaddr = 32'h40;
		@(posedge CLK) imemREN = 1;
		@(posedge CLK) if(iREN) $display("Correct iREN Case 3");
		else $display("Wrong iREN Case 3");
		@(posedge CLK) iload = 32'd16;
		iwait = 0;
		@(posedge CLK) iwait = 1;
		if(iREN) $display("Wrong iREN Case 3");
		else $display("Correct iREN Case 3");
		@(negedge CLK) if(ihit && imemload == 32'd16) $display("Correct Load Case 3");
		else $display("Wrong Load Case 3");
		imemREN = 0;
	end
endprogram
