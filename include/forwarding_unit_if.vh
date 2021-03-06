`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNOT_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
interface forwarding_unit_if;

   //fetch
   word_t jraddr_fe;
   logic jrForwarding_fe;
   
   //decode
   word_t instru_de;
   logic regWr_de;
   logic [1:0] regSel_de;
   
   // execute
    word_t ALUOut_ex, lui_ex, npc_ex;
   regbits_t rs_ex, rt_ex;
   regbits_t regDst_ex;
   logic regWr_ex;
   logic [1:0] regSel_ex;
   logic dWEN_ex;
   logic srcA_ex, srcB_ex;
   word_t forA_ex, forB_ex;
   word_t forDmemstore_ex;
   logic srcDmemstore_ex;
   logic [1:0] ALUSrc_ex;
   //memory
   word_t lui_me, ALUOut_me, npc_me, dmemload_me;
   regbits_t regDst_me;
   logic regWr_me;
   logic [1:0] regSel_me;
   
   //wb
   word_t wdat_wb;
   regbits_t regDst_wb;
   logic regWr_wb;
  
   modport fu (
      input instru_de, regWr_de, regSel_de, ALUOut_ex, lui_ex, npc_ex,
     rs_ex, rt_ex, regDst_ex, regWr_ex, regSel_ex, lui_me, ALUOut_me,
     npc_me, dmemload_me, regDst_me, regWr_me, wdat_wb, dWEN_ex, ALUSrc_ex,
     regDst_wb, regWr_wb, regSel_me,
      output jraddr_fe, jrForwarding_fe, srcA_ex, srcB_ex, forA_ex, forB_ex, forDmemstore_ex, srcDmemstore_ex
   );

endinterface
`endif
