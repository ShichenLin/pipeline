`include "cpu_types_pkg.vh"
`include "alu_if.vh"
`include "execute_if.vh"


module execute(
   logic CLK,
   logic nRST,
   execute_if.ex exif
);

   alusrc_t alusrc;
   word_t rsdat, shamt, imm;
   alu_if aif();

   always_ff@(posedge CLK, negedge nRST) begin
      if (~nRST || exif.flush) begin
         exif.nPC_next <= '0;
         exif.dREN_next <= '0;
         exif.dWEN_next <= '0;
         exif.regWr_next <= '0;
         exif.regSel_next <= '0;
         exif.regDst_next <= '0;
         exif.rtdat <= '0;
         alusrc <= '0;
         rsdat <= '0;
         shamt <= '0;
         imm <= '0;
      end else if (exif.ihit == 1'b1) begin
         exif.nPC_next <= exif.nPC;
         exif.dREN_next <= exif.dREN;
         exif.dWEN_next <= exif.dWEN;
         exif.regWr_next <= exif.regWr;
         exif.regSel_next <= exif.regSel;
         exif.regDst_next <= exif.regDst;
         exif.rtdat <= exif.rdat2;
         alusrc <= exif.ALUSrc;
         rsdat <= exif.rdat1;
         shamt <= exif.shamt;
         imm <= exif.imm;
      end
   end

   always_comb begin
      casez(alusrc)
         ALURT : begin
            aif.portB = exif.rtdat;
         end
         Imm : begin
            aif.portB = imm;
         end
         Shamt: begin
            aif.portB = shamt;
         end
      endcase
   end
 
   assign aif.portA = rsdat;
   assign aif.ALUOP = exif.ALUOp;
   assign exif.ALUOut = aif.portO;
   assign exif.equal = aif.zero;
   
   alu ALU (aif);
endmodule
