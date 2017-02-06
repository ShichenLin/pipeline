`ifndef "EXECUTE_IF_VH"
`define "EXECUTE_IF_VH"

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
   regsel_t regSel;
   regbit_t regDst;
   //out
   word_t nPC_next;
   logic dREN_next, dWEN_next, regWr_next;
   regsel_t regSel_next;
   regbit_t regDst_next;

   //input signals from decode
   word_t rdat1, rdat2, imm;
   logic [SHAM_W-1 : 0] shamt;
   aluop_t ALUOp;
   alusrc ALUSrc;
   //input from Forwarding Unit
   logic srcA, rcB;
   word_t forData;
   //output to mem state
   word_t ALUOut_next;
   // output to PC
   logic equal;

   modport ex (
      input flush, ihit, nPC, dWEN, regWr, regSel, regDst,
     rdat1, rdat2, imm, shamt, ALUOp, ALUSrc, srcA, srcB, forData,
      output nPC_next, dREN_next, dWEN_next, regWr_next, regSel_next,
     regDst_next, ALUOut_next, equal
   );
   modport dp (
      input nPC_next, dREN_next, dWEN_next, regWr_next, regSel_next,
     regDst_next, ALUOut, equal,
      output flush, ihit, nPC, dWEN, regWr, regSel, regDst,
     rdat1, rdat2, imm, shamt, ALUOp, ALUSrc, srcA, srcB, forData
   );
endinterface
`endif

