`ifndef "FETCH_IF_VH"
`define "FETCH_IF_VH"

import cpu_types_pkg::*;

interface fetch_if;
   logic [25:0] jaddr;
   logic [15:0] imm;
   pcsrc_t PCSrc;
   logic equal;
   word_t imemaddr;
   word_t nPC;
   word_t jraddr;
   logic ihit;

   modport pc (
      input jaddr, jraddr, imm, PCSrc, equal, ihit,
      output imemaddr, nPC
   );

   modport dp (
      input imemaddr, nPC,
      output jaddr, jraddr, imm, PCSrc, equal, ihit
   );

endinterface
`endif
