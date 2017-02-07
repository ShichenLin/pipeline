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
   logic regWr;
   regsel_t regSel;
   regbit_t regDst;
   word_t ALUOut;
   //output
    word_t nPC_next;
   logic regWr_next;
   regsel_t regSel_next;
   regbit_t regDst_next;
   word_t ALUOut_next;
   //interface with caches
   //output
   logic dmemREN, dmemWEN;
   //input
   word_t dmemload;
   logic dhit;
   //output to next state
   word_t dmemload_next;
   //latch control signals
   logic flush, ihit;
   modport me (
      input nPC, regWr, regSel, regDst, ALUOut, dmemload, flush, ihit, dhit,
      output nPC_next, regWr_next, regSel_next, regDst_next, ALUOut_next,
             dmemload_next
   );

   modport dp (
      input nPC_next, regWr_next, regSel_next, regDst_next, ALUOut_next,
             dmemload_next,
      output nPC, regWr, regSel, regDst, ALUOut, dmemload, flush, ihit, dhit
   );
endinterface
`endif
