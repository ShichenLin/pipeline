`ifndef FETCH_IF_VH
`define FETCH_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface fetch_if;
   logic [25:0] jaddr;
   logic [2:0] PCSrc;
   word_t imemaddr;
   word_t nPC, jPC, braddr, pPC;
   word_t jraddr;
   logic pcen;
   logic psel; //predictor select

   modport pc (
      input jaddr, jraddr, braddr, pPC, PCSrc, pcen, jPC, brPC, psel
      output imemaddr, nPC
   );

endinterface
`endif
