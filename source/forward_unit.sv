`include "forwarding_unit_if.vh"

module forward_unit(
   forwarding_unit_if.fu fuif
);
import cpu_types_pkg::*;
  // Jr
   always_comb begin
      fuif.jrForwarding_fe = 0;
      fuif.jraddr_fe = '0;
      if (fuif.instru_de[31:26] == JR) begin
         if (fuif.instru_de[25:20] == fuif.regDst_ex && fuif.regWr_ex == 1) begin
            fuif.jrForwarding_fe = 1;
            casez(fuif.regSrc_ex) begin
               2b'00: fuif.jraddr_fe = fuif.ALUOut_ex;
               2b'01: fuif.jraddr_fe = fuif.npc_ex;
               2b'10: fuif.jraddr_fe = fuif.lui.ex;
               //2b'11: fuif.jraddr_fe  // dmemload -> harazed unit
            end
          end
          if (fuif.instru_de[25:20] == fuif.regDst_me && fuif.regWr_me == 1) begin
             fuif.jrForwarding = 1;
             casez(fuif.regSrc_me) begin
               2b'00: fuif.jraddr_fe = fuif.ALUOut_me;
               2b'01: fuif.jraddr_fe = fuif.npc_me;
               2b'10: fuif.jraddr_fe = fuif.lui_me;
               2b'11: fuif.jraddr_fe = fuif.dmemload_me;
             end
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
      //mem
      if (fuif.regWr_me == 1) begin
         if (fuif.rs_ex == fuif.regDst_me) begin
            casez(fuif.regSrc_me) begin
               2b'00: fuif.forA_ex = fuif.ALUOut_me;
               2b'01: fuif.forA_ex = fuif.npc_me;
               2b'10: fuif.forA_ex = fuif.lui_me;
               2b'11: fuif.forA_ex = fuif.dmemload_me;
            end
            fuif.srA_ex = 1;
         end
         if (fuif.rt_ex == fuif.regDst_me) begin
             casez(fuif.regSrc_me) begin
               2b'00: fuif.forB_ex = fuif.ALUOut_me;
               2b'01: fuif.forB_ex = fuif.npc_me;
               2b'10: fuif.forB_ex = fuif.lui_me;
               2b'11: fuif.forB_ex = fuif.dmemload_me;
            end
            fuif.srcB_ex = 1;
         end
      end
      //write_back
      if (fuif.regWr_wb == 1) begin
         if (fuif.rs_ex == fuif.regDst_wb) begin
             fuif.forA_ex = fuif.wdat_wb;
             fuif.srcA = 1;
         end
         if (fuif.rt_ex == fuif.regDst_wb) begin
             fuif.forB_ex = fuif.wdat_wb;
             fuif.srcB = 1;
         end
      end
   end
endmodule
