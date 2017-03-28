`timescale 1 ns / 1 ns

module coh_ctrl_tb;
	parameter PERIOD = 10;
	
	logic nRST, CLK = 1;
	caches_if cif0(), cif1();
	cache_control_if ccif(cif0, cif1);
	
	always #(PERIOD/2) CLK++;
	
	coh_ctrl coc (CLK, nRST, ccif);
	test PROG (CLK, ccif.ramWEN, ccif.ramREN, ccif.iwait, ccif.dwait, ccif.ccwait, ccif.ccinv, ccif.ramstore, ccif.ramaddr, ccif.iload, ccif.dload, ccif.ccsnoopaddr,
	           nRST, ccif.ramstate, ccif.iREN, ccif.dREN, ccif.dWEN, ccif.ccwrite, ccif.cctrans, ccif.dstore, ccif.iaddr, ccif.daddr, ccif.ramload);
endmodule

program test(
	input logic CLK, 
	      logic ramWEN, 
	      logic ramREN,
	      logic [1:0] iwait, 
	      logic [1:0] dwait, 
	      logic [1:0] ccwait, 
	      logic [1:0] ccinv,
	      cpu_types_pkg::word_t ramstore,
	      cpu_types_pkg::word_t ramaddr,
	      cpu_types_pkg::word_t [1:0] iload, 
	      cpu_types_pkg::word_t [1:0] dload, 
	      cpu_types_pkg::word_t [1:0] ccsnoopaddr,
	output logic nRST,
	       cpu_types_pkg::ramstate_t ramstate,
           logic [1:0] iREN, 
           logic [1:0] dREN, 
           logic [1:0] dWEN, 
           logic [1:0] ccwrite, 
           logic [1:0] cctrans,
           cpu_types_pkg::word_t [1:0] dstore, 
           cpu_types_pkg::word_t [1:0] iaddr, 
           cpu_types_pkg::word_t [1:0] daddr,
           cpu_types_pkg::word_t ramload
);
	initial
	begin
		nRST = 0;
		iREN = 0;
		dWEN = 0;
		dREN = 0;
		dstore = 0;
		iaddr = 0;
		daddr = 0;
		ramload = 0;
		ramstate = cpu_types_pkg::FREE;
		ccwrite = 0;
		cctrans = 0;
		
		@(posedge CLK) nRST = 1;
		
		//busRdx invalidate the other cache
		cctrans = 2'b01;
		ccwrite = 2'b01;
		@(negedge CLK) if(~ccwait[1]) //idle
		begin
			$display("sim faild 1");
			$finish;
		end
		@(posedge CLK) cctrans = 0;
		ccwrite = 0;
		@(negedge CLK) if(ccsnoopaddr != 0 || ccinv != 2'b01 || ccwait[1]) //snooping
		begin
			$display("sim faild 2");
			$finish;
		end
		
		//busRd update from the other cache
		@(posedge CLK) daddr[0] = 32'd16;
		cctrans = 2'b01;
		@(negedge CLK) if(~ccwait[1]) //idle
		begin
			$display("sim faild 3");
			$finish;
		end
		@(posedge CLK) ccwrite = 2'b01; //snooping
		@(negedge CLK) if(ccsnoopaddr != 32'd16 || ccinv != 2'b00 || ~ccwait[1])
		begin
			$display("sim faild 4");
			$finish;
		end
		@(posedge CLK) dstore[1] = 32'd12; //data_cache_xfer first word
		ramstate = cpu_types_pkg::ACCESS;
		@(negedge CLK) if(ccsnoopaddr != 32'd16 || ccinv != 2'b00 || ~ccwait[1] || dload[0] != 32'd12 || ramaddr != 32'd16 || ramstore != 32'd12 || dwait != 2'b11)
		begin
			$display("sim faild 5");
			$finish;
		end
		@(posedge CLK) ramstate = cpu_types_pkg::FREE;
		@(posedge CLK) daddr[0] = 32'd20; //data_cache_xfer second word
		ramstate = cpu_types_pkg::ACCESS;
		dstore[1] = 32'd8;
		cctrans = 0;
		@(negedge CLK) if(ccsnoopaddr != 32'd20 || ccinv != 2'b00 || ccwait[1] || dload[0] != 32'd8 || ramaddr != 32'd20 || ramstore != 32'd8 || dwait != 2'b11)
		begin
			$display("sim faild 6");
			$finish;
		end
		ccwrite = 0;
		@(negedge CLK) if(!ccinv || !ccwait) //back to idle
		begin
			$display("sim faild 7");
			$finish;
		end
		
		//busRdx update from the other cache
		@(posedge CLK) daddr[0] = 32'd16;
		cctrans = 2'b01;
		ccwrite = 2'b01;
		@(negedge CLK) if(~ccwait[1]) //idle
		begin
			$display("sim faild 8");
			$finish;
		end
		@(posedge CLK) ccwrite = 2'b11; //snooping
		@(negedge CLK) if(ccsnoopaddr != 32'd16 || ccinv != 2'b01 || ~ccwait[1])
		begin
			$display("sim faild 9");
			$finish;
		end
		@(posedge CLK) dstore[1] = 32'd12; //data_cache_xfer first word
		ramstate = cpu_types_pkg::ACCESS;
		@(negedge CLK) if(ccsnoopaddr != 32'd16 || ccinv != 2'b01 || ~ccwait[1] || dload[0] != 32'd12 || ramaddr != 32'd16 || ramstore != 32'd12  || dwait != 2'b11)
		begin
			$display("sim faild 10");
			$finish;
		end
		@(posedge CLK) ramstate = cpu_types_pkg::FREE;
		@(posedge CLK) daddr[0] = 32'd20; //data_cache_xfer second word
		dstore[1] = 32'd8;
		cctrans = 0;
		@(negedge CLK) if(ccsnoopaddr != 32'd20 || ccinv != 2'b01 || ccwait[1] || dload[0] != 32'd8 || ramaddr != 32'd20 || ramstore != 32'd8  || dwait != 2'b11)
		begin
			$display("sim faild 11");
			$finish;
		end
		ccwrite = 0;
		@(negedge CLK) if(!ccinv || !ccwait) //back to idle
		begin
			$display("sim faild 12");
			$finish;
		end
		
		//update from RAM
		@(posedge CLK) daddr[0] = 32'd16;
		cctrans = 2'b01;
		@(negedge CLK) if(~ccwait[1]) //idle
		begin
			$display("sim faild 13");
			$finish;
		end
		@(negedge CLK) if(ccsnoopaddr != 32'd16 || ccinv != 2'b00 || ~ccwait[1]) //snooping
		begin
			$display("sim faild 14");
			$finish;
		end
		@(posedge CLK) ramload = 32'd32; //data_ram_xfer first word
		ramstate = cpu_types_pkg::ACCESS;
		@(negedge CLK) if(~ccwait[1] || dload[0] != 32'd32 || ramaddr != 32'd16 || dwait != 2'b01)
		begin
			$display("sim faild 15");
			$finish;
		end
		@(posedge CLK) ramstate = cpu_types_pkg::FREE;
		@(posedge CLK) daddr[0] = 32'd20; //data_ram_xfer second word
		ramload = 32'd100;
		cctrans = 0;
		@(negedge CLK) if(ccwait[1] || dload[0] != 32'd100 || ramaddr != 32'd20 || dwait != 2'b01)
		begin
			$display("sim faild 16");
			$finish;
		end
		ccwrite = 0;
		@(negedge CLK) if(!ccinv || !ccwait) //back to idle
		begin
			$display("sim faild 17");
			$finish;
		end
		
		//two simultaneous requests
		@(posedge CLK) daddr[0] = 32'd16;
		cctrans = 2'b11;
		@(negedge CLK) if(~ccwait[1]) //idle
		begin
			$display("sim faild 13");
			$finish;
		end
		@(negedge CLK) if(ccsnoopaddr != 32'd16 || ccinv != 2'b01 || ~ccwait[1]) //snooping
		begin
			$display("sim faild 14");
			$finish;
		end
		@(posedge CLK) ramload = 32'd32; //data_ram_xfer first word
		ramstate = cpu_types_pkg::ACCESS;
		@(negedge CLK) if(~ccwait[1] || dload[0] != 32'd32 || ramaddr != 32'd16 || dwait != 2'b01)
		begin
			$display("sim faild 15");
			$finish;
		end
		@(posedge CLK) ramstate = cpu_types_pkg::FREE;
		@(posedge CLK) daddr[0] = 32'd20; //data_ram_xfer second word
		ramload = 32'd100;
		cctrans = 0;
		@(negedge CLK) if(ccwait[1] || dload[0] != 32'd100 || ramaddr != 32'd20 || dwait != 2'b01)
		begin
			$display("sim faild 16");
			$finish;
		end
		ccwrite = 0;
		@(negedge CLK) if(!ccinv || !ccif.ccwait) //back to idle
		begin
			$display("sim faild 17");
			$finish;
		end
		$display("All pass");
	end
endprogram
