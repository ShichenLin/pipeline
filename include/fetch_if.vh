`ifndef FETCH_IF_VH
`define FETCH_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface fetch_if;
   logic [25:0] jaddr;
   logic [15:0] imm;
   logic [2:0] PCSrc;
   logic equal;
   word_t imemaddr;
   word_t nPC;
   word_t jraddr;
   logic pcen;

   modport pc (
      input jaddr, jraddr, imm, PCSrc, equal, pcen,
      output imemaddr, nPC
   );

endinterface
`endif
