`ifndef EXECUTE_IF_VH
`define EXECUTE_IF_VH

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface execute_if;
   //latch control
   logic flush;
   logic ihit;
   //pass through signals
   //in
   word_t nPC;
   logic dREN, dWEN, regWr;
   logic [2:0] regSel;
   regbits_t regDst, rt, rs;
   //out
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
   word_t forData;
   //output to mem state
   word_t ALUOut_next, rtdat;
   // output to PC
   logic equal;

   modport ex (
      input flush, ihit, nPC, dREN, dWEN, regWr, regSel, regDst, rdat1, rdat2, imm, shamt, ALUOp, ALUSrc, srcA, srcB, forData, rt, rs,
      output nPC_next, dREN_next, dWEN_next, regWr_next, regSel_next,
     regDst_next, ALUOut_next, equal, rtdat
   );

endinterface
`endif

