`ifndef "DECODE_WRITE_BACK_IF_VH"
`define "DECODE_WRITE_BACK_IF_VH"

`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

interface decode_write_back_if;
   // Pass through signals
   word_t nPCIn;
   word_t nPC_next;
   //decode inputs
   word_t instru;
   logic ihit;
   // decode outputs
   regbits_t regDst_next; // Wsel
   logic dREN_next, dWEN_next, regWr_next;
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
   // write_back inputs
   word_t regWr;
   regbit_t regDst;
   regsel_t regSel;
   word_t dmemload;
   word_t nPC;
   word_t ALUOut;
   //flush
   logic flush;
   modport dw (
      input nPCIn, ihit, instru, regWr, regDst, regSel, dmemload, nPC, ALUOut,
      flush,
      output nPC_next, regSel_next, ALUOp_next, PCSrc_next, ALUSrc_next,
      rdat1_next, rdat2_next, imm_next, PCSrc, shamt_next
   );

   modport dp (
     input nPC_next, regSel_next, ALUOp_next, PCSrc_next, ALUSrc_next,
     rdat1_next, rdat2_next, imm_next, PCSrc, shamt_next,
     output nPCIn, ihit, instru, regWr, regDst, regSel, dmemload, nPC, ALUOut,
     flush
   );

endinterface
`endif
