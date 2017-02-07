`ifndef "DECODE_IF_VH"
`define "DECODE_IF_VH"

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`include "control_unit_pkg.vh"
import control-unit_pkg::*:

interface decode_if;
   // Pass through signals
   word_t nPC;
   word_t nPC_next;
   //decode inputs
   word_t instru;
   logic ihit;
   // decode outputs
   regbits_t regDst_next, rt_next, rs_next; // Wsel
   logic dREN_next, dWEN_next, regWr_next, regWr_next;
   regsel_t regSel_next;
   aluop_t ALUOp_next;
   pcsrc_t PCSrc_next;
   alusrc_t ALUSrc_next;
   word_t rdat1_next;
   word_t rdat2_next;
   word_t imm_next;
   logic [SHAM_W:0] shamt_next;
   //pcsel output
   word_t PCSrc;
   //write back result
   logic WEN;
   word_t wdat;
   regbits_t wsel;   
   //flush
   logic flush;
   logic halt;
   
   modport de (
      input nPC, ihit, instru, WEN, wdat, wsel, flush,
      output nPC_next, dWEN_next, dREN_next, regWr_next, regSel_next, regDst_next, ALUOp_next, PCSrc_next, ALUSrc_next, rdat1_next, rdat2_next, imm_next, PCSrc, shamt_next, lui_next, rt_next, rs_next, halt
   );


endinterface
`endif
