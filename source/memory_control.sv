/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

module memory_control (
  	input CLK, nRST,
  	cache_control_if ccif
);

  	coh_ctrl coc (CLK, nRST, ccif);
endmodule
