`ifndef "DECODE_IF_VH"
`define "DECODE_IF_VH"

`include "cpu_types_pkg.vh"
interface decode_if;
   word_t imemload;
   word_t nPC;
   logic ihit;
   pcsrc_t pcsrc;




endinterface
`endif
