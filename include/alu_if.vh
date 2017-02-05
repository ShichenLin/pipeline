`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  	// import types
  	import cpu_types_pkg::*;

  	word_t portA, portB;
	logic [3:0] ALUOP;
	logic neg, of, zero;
	word_t portO;

  	// register file ports
  	modport alu (
    	input   portA, portB, ALUOP,
    	output  neg, of, zero, portO
  	);
  	// register file tb
  	modport tb (
    	input  neg, of, zero, portO,
    	output   portA, portB, ALUOP
  	);
endinterface

`endif
