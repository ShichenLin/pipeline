/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  	input CLK, nRST,
  	cache_control_if.cc ccif
);
  	// type import
  	import cpu_types_pkg::*;

  	// number of cpus for cc
  	parameter CPUS = 2;
  	
	assign	ccif.iwait = ccif.ramstate != ACCESS || ccif.dWEN || ccif.dREN;
	assign	ccif.dwait = ccif.ramstate != ACCESS || ~(ccif.dREN || ccif.dWEN);
	assign	ccif.iload = ccif.ramload;
	assign	ccif.dload = ccif.ramload;
	assign	ccif.ramWEN = ccif.dWEN;
	assign	ccif.ramREN = ccif.iREN && ~ccif.dWEN || ccif.dREN;
	assign	ccif.ramstore = ccif.dstore;
	assign	ccif.ramaddr = (ccif.dREN || ccif.dWEN) ? ccif.daddr : ccif.iaddr;
		
		//multicore signals
	assign	ccif.ccinv = 0;
	assign	ccif.ccwait = 0;
	assign	ccif.ccsnoopaddr = 0;
endmodule
