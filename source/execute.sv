`include "cpu_types_pkg.vh"
`include "alu_if.vh"
`include "execute_if.vh"


module execute(
   logic CLK,
   logic nRST,
   execute_if.ex exif
);
   word_t portb;
   always_ff@(posedge CLK, negedge nRST) begin
      if (nRST == 1'b0) begin
         exif.nPC_next <= '0;
         exif.dREN_next <= '0;
         exif.dWEN_next <= '0;
         exif.regWr_next <= '0;
         exif.regSel_next <= '0;
         exif.regDst_next <= '0;
      end else if (exif.flush == 1'b1) begin
         exif.nPC_next <= '0;
         exif.dREN_next <= '0;
         exif.dWEN_next <= '0;
         exif.regWr_next <= '0;
         exif.regSel_next <= '0;
         exif.regDst_next <= '0;
      end else if (exif.ihit == 1'b1) begin
         exif.nPC_next <= exif.nPC;
         exif.dREN_next <= exif.dREN;
         exif.dWEN_next <= exif.dWEN;
         exif.regWr_next <= exif.regWr;
         exif.regSel_next <= exif.regSel;
         exif.regDst_next <= exif.regDst;
      end
   end

   always_comb begin
      casez(exif.ALUSrc)
         ALURT : begin
            portb = exif.rdat2;
         end
         Imm : begin
            portb = exif.imm;
         end
         Shamt: begin
             portb = {25'b0, exif.Shamt};
         end
      endcase
   end
   alu_if aif();

   assign aif.portA = exif.rdat1;
   assign aif.portB = portb;
   assign aif.ALUOP = exif.ALUOp;
   assign exif.ALUOut = aif.portO;
   assign exif.equal = aif.zero;
   alu ALU (aif);
endmodule
