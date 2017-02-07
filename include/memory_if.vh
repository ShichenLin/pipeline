`ifndef "MEMORY_IF_VH"
`define "MEMORY_IF_VH"

`include "control_unit_pkg.vh"
import control-unit_pkg::*:
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface memory_if;
   //pass throught signals
  // input
   word_t nPC;
   logic dREN, dWEN, regWr;
   regsel_t regSel;
   regbits_t regDst;
   word_t ALUOut;
   //output
    word_t nPC_next;
   logic regWr_next;
   regsel_t regSel_next;
   regbits_t regDst_next;
   word_t ALUOut_next;
   //interface with caches
   //output
   logic dmemREN, dmemWEN;
   word_t dmemaddr, dmemstore;
   //input
   word_t dmemload, rtdat;
   logic dhit;
   //output to next state
   word_t dmemload_next;
   //latch control signals
   logic flush, ihit;
   
   modport me (
      input nPC, regWr, dREN, dWEN, regSel, regDst, ALUOut, dmemload, flush, ihit, dhit, rtdat,
      output nPC_next, regWr_next, regSel_next, regDst_next, ALUOut_next,
             dmemload_next, dmemREN, dmemWEN, dmemaddr, dmemstore
   );

endinterface
`endif
