`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNOT_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
interface forwarding_unit_if;
    //fetch
   word_t jraddr_fe;
   logic jrForwarding_fe;
   //decode
   word_t rdat1_de, opcode_de, instru_de;
   logic regWr_de;
   logic [1:0] regSel_de;
   // execute
   word_t forData_ex;
   logic srcA_ex, srcB_ex;
   word_t ALUOut_ex;
   regbits_t rs_ex, rt_ex;
   regbits_t regDst_ex;
   logic regWr_ex;
   logic [1:0] regSel_ex;
   //memory
   word_t lui_me, ALUOut_me, npc_me;
   regbits_t regDst_me;
   logic regWr_me;
   //wb
   word_t wdat_wb;
   regbits_t regDst_wb;
   logic regWr_wb;
   logic [1:0] regSel_wb;

   modport fu (

   );

endinterface
`endif
