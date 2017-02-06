`ifndef "PROGRAM_COUNTER_IF_VH"
`define "PROGRAM_COUNTER_IF_VH"

import cpu_types_pkg::*;

interface program_counter_if;
   logic [25:0] jaddr;
   logic [15:0] imm;
   pcsrc_t PCSrc;
   logic equal;
   word_t imemaddr;
   word_t nPC;
   logic ihit;

   modport pc (
      input jaddr, imm, PCSrc, equal, ihit,
      output imemaddr, nPC
   );

   modport dp (
      input imemaddr, nPC,
      output jaddr, imm, PCSrc, equal, ihit
   );

endinterface
`endif
