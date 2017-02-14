`timescale 1 ns / 1 ns

//`include "hazard_unit_if.vh"

module hazard_unit_tb;
	// clock period
  	parameter PERIOD = 20;

  	// signals
  	logic CLK = 1, nRST;

  	// clock
  	always #(PERIOD/2) CLK++;
  	
  	//interface
  	hazard_unit_if huif ();
  	
  	//program
  	test PROG (CLK, nRST, huif);
  	
  	//dut
  	hazard_unit DUT (CLK, nRST, huif);
endmodule

program test(
	input logic CLK,
	output logic nRST,
	hazard_unit_if.tb huif
);
	initial
	begin
		nRST = 0;
		huif.ihit = 0;
		huif.dhit = 0;
		huif.exREN = 0;
		huif.exWEN = 0;
		huif.meldst = 0;
		huif.rs = 0;
		huif.rt = 0;
		huif.exrdst = 0;
		huif.merdst = 0;
		huif.PCSrc = 0;
		huif.equal = 0;
		
		//start
		@(posedge CLK) nRST = 1;
		
		//normal case
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
		
		//case1
		huif.exREN = 1;
		huif.rs = 5'd1;
		huif.merdst = 5'd1;
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
		huif.merdst = 0;
		
		//case2 lw jr
		huif.exrdst = 5'd31;
		huif.PCSrc = 3'd1;
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
		
		//case3 and case4 branch
		huif.PCSrc = 3'd3;
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
		huif.equal = 1;
		huif.PCSrc = 3'd4;
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
		huif.equal = 0;
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
		
		//case5 j-type
		huif.PCSrc = 3'd2;
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
		
		//case6 jr
		huif.PCSrc = 3'd1;
		@(negedge CLK) huif.ihit = 1;
		@(posedge CLK) huif.ihit = 0;
	end
endprogram
