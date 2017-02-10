`include "cpu_types_pkg.vh"
`include "alu_if.vh"
`include "execute_if.vh"


module execute(
   logic CLK,
   logic nRST,
   input word_t instru_ex,
   output word_t instru_ex_next,
   execute_if.ex exif
);

   logic [1:0] alusrc;
   word_t rsdat, shamt, imm;
   aluop_t aluop;
   alu_if aif();

   always_ff@(posedge CLK, negedge nRST) begin
      if (~nRST) begin
         exif.nPC_next <= '0;
         exif.dREN_next <= '0;
         exif.dWEN_next <= '0;
         exif.regWr_next <= '0;
         exif.regSel_next <= '0;
         exif.regDst_next <= '0;
         exif.halt_next <= '0;
         alusrc <= 2'd0;//rt
         aluop <= ALU_SLL;
         rsdat <= '0;
         shamt <= '0;
         imm <= '0;
         exif.lui_next <= '0;
         exif.dmemstore_next <= '0;
         instru_ex_next <= '0;
      end
      else if (exif.flush) begin
      	exif.nPC_next <= '0;
         exif.dREN_next <= '0;
         exif.dWEN_next <= '0;
         exif.regWr_next <= '0;
         exif.regSel_next <= '0;
         exif.regDst_next <= '0;
         exif.halt_next <= '0;
         alusrc <= 2'd0;//rt
         aluop <= ALU_SLL;
         rsdat <= '0;
         shamt <= '0;
         imm <= '0;
         exif.lui_next <= '0;
         exif.dmemstore_next <= '0;
         instru_ex_next <= '0;
      end
      else if (exif.exen) begin
         exif.nPC_next <= exif.nPC;
         exif.dREN_next <= exif.dREN;
         exif.dWEN_next <= exif.dWEN;
         exif.regWr_next <= exif.regWr;
         exif.regSel_next <= exif.regSel;
         exif.regDst_next <= exif.regDst;
         exif.dmemstore_next <= exif.rdat2;
         exif.halt_next <= exif.halt;
         alusrc <= exif.ALUSrc;
         aluop <= exif.ALUOp;
         rsdat <= exif.rdat1;
         shamt <= exif.shamt;
         imm <= exif.imm;
         exif.lui_next <= exif.lui;
         instru_ex_next <= instru_ex;
      end
   end

   always_comb begin
      casez(alusrc)
         2'd0: begin
            aif.portB = exif.dmemstore_next;//rt
         end
         2'd1: begin
            aif.portB = imm;//imm
         end
         2'd2: begin
            aif.portB = shamt;//shamt
         end
      endcase
   end

   assign aif.portA = rsdat;
   assign aif.ALUOP = aluop;
   assign exif.ALUOut_next = aif.portO;
   assign exif.equal = aif.zero;
   alu ALU (aif);
endmodule
