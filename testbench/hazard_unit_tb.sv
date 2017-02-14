`timescale 1 ns / 1 ns

`include "hazard_unit_if.vh"

module hazard_unit_tb();
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
	input CLK,
	output nRST,
	hazard_unit_if.tb huif
);
	initial
	begin
		nRST = 1;
		
	end
endprogram
