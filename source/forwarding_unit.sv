`include "forwarding_unit_if.vh"

module forwarding_unit(
   forwarding_unit_if.fu fuif
);
import cpu_types_pkg::*;
  // Jr
   always_comb begin
      fuif.jrForwarding_fe = 0;
      fuif.jraddr_fe = '0;
      if (fuif.instru_de[31:26] == '0 && fuif.instru_de[6:0] == JR) begin
          fuif.jraddr_fe = 1;
         if (fuif.instru_de[25:21] == fuif.regDst_ex && fuif.regWr_ex == 1) begin
            fuif.jrForwarding_fe = 1;
            casez(fuif.regSel_ex)
               2'b00: fuif.jraddr_fe = fuif.ALUOut_ex;
               2'b01: fuif.jraddr_fe = fuif.npc_ex;
               2'b10: fuif.jraddr_fe = fuif.lui_ex;
            endcase
          end
          if (fuif.instru_de[25:21] == fuif.regDst_me && fuif.regWr_me == 1) begin
             fuif.jrForwarding_fe = 1;
             casez(fuif.regSel_me)
               2'b00: fuif.jraddr_fe = fuif.ALUOut_me;
               2'b01: fuif.jraddr_fe = fuif.npc_me;
               2'b10: fuif.jraddr_fe = fuif.lui_me;
               2'b11: fuif.jraddr_fe = fuif.dmemload_me;
             endcase
           end
           /*if (fuif.instru_de[25:20] == fuif.regDst_wb && fuif.regWr == 1) begin
              fuif.jrForwarding = 1;
           end*/
      end
   end
   //ALU
   always_comb begin
      fuif.forA_ex = '0;
      fuif.forB_ex = '0;
      fuif.srcA_ex = 0;
      fuif.srcB_ex = 0;
      fuif.forDmemstore_ex = '0;
      fuif.srcDmemstore_ex = 0;
       //write_back
      if (fuif.regWr_wb == 1 && fuif.dWEN_ex == 0) begin
         if (fuif.rs_ex == fuif.regDst_wb) begin
             fuif.forA_ex = fuif.wdat_wb;
             fuif.srcA_ex = 1;
         end
         if (fuif.rt_ex == fuif.regDst_wb && fuif.ALUSrc_ex == 2'b00) begin
             fuif.forB_ex = fuif.wdat_wb;
             fuif.srcB_ex = 1;
         end
      end
      //mem
      if (fuif.regWr_me == 1) begin//change
         if (fuif.rs_ex == fuif.regDst_me) begin
            casez(fuif.regSel_me)
               2'b00: fuif.forA_ex = fuif.ALUOut_me;
               2'b01: fuif.forA_ex = fuif.npc_me;
               2'b10: fuif.forA_ex = fuif.lui_me;
               2'b11: fuif.forA_ex = fuif.dmemload_me;
            endcase
            fuif.srcA_ex = 1;
         end
         if (fuif.rt_ex == fuif.regDst_me && fuif.ALUSrc_ex == 2'b00) begin
             casez(fuif.regSel_me)
               2'b00: fuif.forB_ex = fuif.ALUOut_me;
               2'b01: fuif.forB_ex = fuif.npc_me;
               2'b10: fuif.forB_ex = fuif.lui_me;
               2'b11: fuif.forB_ex = fuif.dmemload_me;
            endcase
            fuif.srcB_ex = 1;
         end
      end
     
      //imemload
       if (fuif.regWr_wb == 1) begin
         if (fuif.rt_ex == fuif.regDst_wb) begin
             fuif.forDmemstore_ex = fuif.wdat_wb;
             fuif.srcDmemstore_ex = 1;
         end
      end
      if (fuif.regWr_me == 1) begin
         if (fuif.rt_ex == fuif.regDst_me) begin
            casez(fuif.regSel_me)
               2'b00: fuif.forDmemstore_ex = fuif.ALUOut_me;
               2'b01: fuif.forDmemstore_ex = fuif.npc_me;
               2'b10: fuif.forDmemstore_ex = fuif.lui_me;
               2'b11: fuif.forDmemstore_ex = fuif.dmemload_me;
            endcase
             fuif.srcDmemstore_ex = 1;
          end
       end
   end
endmodule
