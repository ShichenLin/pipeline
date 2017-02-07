`ifndef "FETCH_IF_VH"
`define "FETCH_IF_VH"

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`include "control_unit_pkg.vh"
import control_unit_pkg::*;;

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

endinterface
`endif
