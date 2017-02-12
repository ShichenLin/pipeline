`ifndef DECODE_IF_VH
`define DECODE_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface decode_if;
   // Pass through signals
   word_t nPC, nPC_next;
   word_t PC, jPC;
   logic [25:0] jaddr;
   //decode inputs
   word_t instru, instr;
   logic deen;
   // decode outputs
   regbits_t regDst_next, rt_next, rs_next; // Wsel
   logic dREN_next, dWEN_next, regWr_next;
   logic [1:0] regSel_next;
   aluop_t ALUOp_next;
   logic [1:0] ALUSrc_next;
   word_t rdat1_next;
   word_t rdat2_next;
   word_t imm, lui_next, brimm;
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
      input nPC, deen, instru, WEN, wdat, wsel, flush, PC,
      output nPC_next, instr, jPC, jaddr, dWEN_next, dREN_next, regWr_next, regSel_next,
			regDst_next, ALUOp_next, ALUSrc_next, rdat1_next, rdat2_next,
			imm, brimm, PCSrc, shamt_next, lui_next, rt_next, rs_next, halt
   );


endinterface
`endif
