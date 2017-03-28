`timescale 1 ns / 1 ns

module coh_ctrl_tb;
	parameter PERIOD = 10;
	
	logic nRST, CLK;
	cache_control_if ccif;
	
	always #(PERIOD/2) CLK++;
	
	coh_ctrl coc (CLK, nRST, ccif);
	test PROG (CLK, ccif.iwait, ccif.dwait, ccif.iload, ccif.dload, ccif.ramstore, ccif.ramaddr, ccif.ramWEN, ccif.ramREN, ccif.ccwait, ccif.ccinv, ccif.ccsnoopaddr,
	           nRST, ccif.iREN, ccif.dREN, ccif.dWEN, ccif.dstore, ccif.iaddr, ccif.daddr, ccif.ramload, ccif.ramstate, ccif.ccwrite, ccif.trans);
endmodule

program test(
	input CLK, ccif.iwait, ccif.dwait, ccif.iload, ccif.dload, ccif.ramstore, ccif.ramaddr, ccif.ramWEN, ccif.ramREN, ccif.ccwait, ccif.ccinv, ccif.ccsnoopaddr,
	output nRST, ccif.iREN, ccif.dREN, ccif.dWEN, ccif.dstore, ccif.iaddr, ccif.daddr, ccif.ramload, ccif.ramstate, ccif.ccwrite, ccif.trans
);
	initial
	begin
		nRST = 0;
		ccif.iREN = 0;
		ccif.dWEN = 0;
		ccif.dREN = 0;
		ccif.dstore = 0;
		ccif.iaddr = 0;
		ccif.daddr = 0;
		ccif.ramload = 0;
		ccif.ramstate = FREE;
		ccif.ccwrite = 0;
		ccif.cctrans = 0;
		
		@(posedge CLK) nRST = 1;
		
		//busRdx invalidate the other cache
		ccif.cctrans = 2'b01;
		ccif.ccwrite = 2'b01;
		@negedge CLK) if(~ccif.ccwait[1]) //idle
		begin
			$display("sim faild 1");
			$finish;
		end
		@(posedge CLK) ccif.cctrans = 0;
		ccif.ccwrite = 0;
		@(negedge CLK) if(ccif.ccsnoopaddr != 0 || ccif.ccinv != 2'b01 || ccif.ccwait[1]) //snooping
		begin
			$display("sim faild 2");
			$finish;
		end
		
		//busRd update from the other cache
		@(posedge CLK) ccif.daddr[0] = 32'd16;
		ccif.cctrans = 2'b01;
		@negedge CLK) if(~ccif.ccwait[1]) //idle
		begin
			$display("sim faild 3");
			$finish;
		end
		@(posedge CLK) ccif.ccwrite = 2'b01; //snooping
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd16 || ccif.ccinv != 2'b00 || ~ccif.ccwait[1])
		begin
			$display("sim faild 4");
			$finish;
		end
		@(posedge CLK) ccif.dstore[1] = 32'd12; //data_cache_xfer first word
		ccif.ramstate = ACCESS;
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd16 || ccif.ccinv != 2'b00 || ~ccif.ccwait[1] || ccif.dload[0] != 32'd12 || ccif.ramaddr != 32'16 || ccif.ramstore != 32'd12 || ccif.dwait != 2'b11)
		begin
			$display("sim faild 5");
			$finish;
		end
		@(posedge CLK) ramstate = FREE;
		@(posedge CLK) ccif.daddr[0] = 32'd20; //data_cache_xfer second word
		ccif.ramstate = ACCESS;
		ccif.dstore[1] = 32'd8;
		ccif.cctrans = 0;
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd20 || ccif.ccinv != 2'b00 || ccif.ccwait[1] || ccif.dload[0] != 32'd8 || ccif.ramaddr != 32'd20 || ccif.ramstore != 32'd8 || ccif.dwait != 2'b11)
		begin
			$display("sim faild 6");
			$finish;
		end
		ccif.ccwrite = 0;
		@(negedge CLK) if(!ccif.ccinv || !ccif.ccwait) //back to idle
		begin
			$display("sim faild 7");
			$finish;
		end
		
		//busRdx update from the other cache
		@(posedge CLK) ccif.daddr[0] = 32'd16;
		ccif.cctrans = 2'b01;
		ccif.ccwrite = 2'b01;
		@negedge CLK) if(~ccif.ccwait[1]) //idle
		begin
			$display("sim faild 8");
			$finish;
		end
		@(posedge CLK) ccif.ccwrite = 2'b11; //snooping
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd16 || ccif.ccinv != 2'b01 || ~ccif.ccwait[1])
		begin
			$display("sim faild 9");
			$finish;
		end
		@(posedge CLK) ccif.dstore[1] = 32'd12; //data_cache_xfer first word
		ccif.ramstate = ACCESS;
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd16 || ccif.ccinv != 2'b01 || ~ccif.ccwait[1] || ccif.dload[0] != 32'd12 || ccif.ramaddr != 32'16 || ccif.ramstore != 32'd12  || ccif.dwait != 2'b11)
		begin
			$display("sim faild 10");
			$finish;
		end
		@(posedge CLK) ramstate = FREE;
		@(posedge CLK) ccif.daddr[0] = 32'd20; //data_cache_xfer second word
		ccif.dstore[1] = 32'd8;
		ccif.cctrans = 0;
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd20 || ccif.ccinv != 2'b01 || ccif.ccwait[1] || ccif.dload[0] != 32'd8 || ccif.ramaddr != 32'd20 || ccif.ramstore != 32'd8  || ccif.dwait != 2'b11)
		begin
			$display("sim faild 11");
			$finish;
		end
		ccif.ccwrite = 0;
		@(negedge CLK) if(!ccif.ccinv || !ccif.ccwait) //back to idle
		begin
			$display("sim faild 12");
			$finish;
		end
		
		//update from RAM
		@(posedge CLK) ccif.daddr[0] = 32'd16;
		ccif.cctrans = 2'b01;
		@negedge CLK) if(~ccif.ccwait[1]) //idle
		begin
			$display("sim faild 13");
			$finish;
		end
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd16 || ccif.ccinv != 2'b00 || ~ccif.ccwait[1]) //snooping
		begin
			$display("sim faild 14");
			$finish;
		end
		@(posedge CLK) ccif.ramload = 32'd32; //data_ram_xfer first word
		ccif.ramstate = ACCESS;
		@(negedge CLK) if(~ccif.ccwait[1] || ccif.dload[0] != 32'd32 || ccif.ramaddr != 32'16 || ccif.dwait != 2'b01)
		begin
			$display("sim faild 15");
			$finish;
		end
		@(posedge CLK) ramstate = FREE;
		@(posedge CLK) ccif.daddr[0] = 32'd20; //data_ram_xfer second word
		ccif.ramload = 32'd100;
		ccif.cctrans = 0;
		@(negedge CLK) if(ccif.ccwait[1] || ccif.dload[0] != 32'd100 || ccif.ramaddr != 32'd20 || ccif.dwait != 2'b01)
		begin
			$display("sim faild 16");
			$finish;
		end
		ccif.ccwrite = 0;
		@(negedge CLK) if(!ccif.ccinv || !ccif.ccwait) //back to idle
		begin
			$display("sim faild 17");
			$finish;
		end
		
		//two simultaneous requests
		@(posedge CLK) ccif.daddr[0] = 32'd16;
		ccif.cctrans = 2'b11;
		@negedge CLK) if(~ccif.ccwait[1]) //idle
		begin
			$display("sim faild 13");
			$finish;
		end
		@(negedge CLK) if(ccif.ccsnoopaddr != 32'd16 || ccif.ccinv != 2'b01 || ~ccif.ccwait[1]) //snooping
		begin
			$display("sim faild 14");
			$finish;
		end
		@(posedge CLK) ccif.ramload = 32'd32; //data_ram_xfer first word
		ccif.ramstate = ACCESS;
		@(negedge CLK) if(~ccif.ccwait[1] || ccif.dload[0] != 32'd32 || ccif.ramaddr != 32'16 || ccif.dwait != 2'b01)
		begin
			$display("sim faild 15");
			$finish;
		end
		@(posedge CLK) ramstate = FREE;
		@(posedge CLK) ccif.daddr[0] = 32'd20; //data_ram_xfer second word
		ccif.ramload = 32'd100;
		ccif.cctrans = 0;
		@(negedge CLK) if(ccif.ccwait[1] || ccif.dload[0] != 32'd100 || ccif.ramaddr != 32'd20 || ccif.dwait != 2'b01)
		begin
			$display("sim faild 16");
			$finish;
		end
		ccif.ccwrite = 0;
		@(negedge CLK) if(!ccif.ccinv || !ccif.ccwait) //back to idle
		begin
			$display("sim faild 17");
			$finish;
		end
	end
endprogram
