`ifndef MEMORY_IF_VH
`define MEMORY_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface memory_if;
   //pass throught signals
  // input
   word_t nPC;
   logic dREN, dWEN, regWr;
   logic [2:0] regSel;
   regbits_t regDst;
   word_t ALUOut;
   //output
    word_t nPC_next;
   logic regWr_next;
   logic [2:0] regSel_next;
   regbits_t regDst_next;
   word_t ALUOut_next;
   //interface with caches
   //output
   logic dmemREN, dmemWEN;
   word_t dmemstore;
   //input
   word_t rtdat;
   logic dhit;
   //latch control signals
   logic flush, ihit, halt, halt_next;
   
   modport me (
      input nPC, regWr, dREN, dWEN, regSel, regDst, ALUOut, flush, ihit, dhit, rtdat, halt,
      output nPC_next, regWr_next, regSel_next, regDst_next, ALUOut_next,
             dmemREN, dmemWEN, dmemstore, halt_next
   );

endinterface
`endif
