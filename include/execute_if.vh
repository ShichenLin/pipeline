`ifndef EXECUTE_IF_VH
`define EXECUTE_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface execute_if;
   //latch control
   logic flush;
   logic exen;
   //pass through signals
   //in
   word_t nPC;
   logic dREN, dWEN, regWr;
   logic [2:0] regSel;
   regbits_t regDst, rt, rs, rt_next, rs_next;
   //out
   logic[2:0] ALUSrc_next;
   word_t nPC_next;
   logic dREN_next, dWEN_next, regWr_next;
   logic [2:0] regSel_next;
   regbits_t regDst_next;

   //input signals from decode
   word_t rdat1, rdat2, imm;
   word_t shamt;
   aluop_t ALUOp;
   logic [2:0] ALUSrc;
   //input from Forwarding Unit
   logic srcA, srcB;
   word_t forA, forB;
   //output to mem state
   word_t ALUOut_next;
   
   logic equal;
   logic halt, halt_next;
   word_t dmemstore_next;
   word_t lui, lui_next;
   logic [15:0] brimm, brimm_next;
   
   modport ex (
      input flush, exen, nPC, dREN, dWEN, regWr, regSel, regDst, rdat1, rdat2,
imm, shamt, ALUOp, ALUSrc, srcA, srcB, forA, forB, rt, rs, halt, lui, brimm,
      output nPC_next, dREN_next, dWEN_next, regWr_next, regSel_next, regDst_next, ALUOut_next, equal, halt_next, dmemstore_next, lui_next, brimm_next, rt_next, rs_next, ALUSrc_next
   );

endinterface
`endif

