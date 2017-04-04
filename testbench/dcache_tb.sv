`timescale 1 ns / 1 ns

module dcache_tb;
	// clock period
	parameter PERIOD = 10;

	// signals
	logic CLK = 1, nRST;

	// clock
	always #(PERIOD/2) CLK++;
	
	//innterfaces
	caches_if cif ();
	datapath_cache_if dcif ();
	
	//DUT	
	dcache dc (CLK, nRST, dcif, cif);
	
	//program
	test PROG (CLK, dcif.dhit, dcif.flushed, cif.dREN, cif.dWEN, dcif.dmemload, cif.dstore, cif.daddr, cif.ccwrite, cif.cctrans,
			   nRST, dcif.halt, dcif.dmemREN, dcif.dmemWEN, cif.dwait, dcif.dmemaddr, dcif.dmemstore, cif.dload, cif.ccsnoopaddr, cif.ccwait, cif.ccinv);
endmodule

program test(
	input logic CLK, dhit, flushed, dREN, dWEN,
		  cpu_types_pkg::word_t dmemload, dstore, daddr,
		  logic ccwrite, cctrans,
	output logic nRST, halt, dmemREN, dmemWEN, dwait,
		   cpu_types_pkg::word_t dmemaddr, dmemstore, dload, ccsnoopaddr,
		   logic ccwait, ccinv
);
	integer i = 0;
	
	initial
	begin
		nRST = 1;
		halt = 0;
		dwait = 1;
		dmemREN = 0;
		dmemWEN = 0;
		ccwait = 0;
		ccinv = 0;
		ccsnoopaddr = 32'h0;
		dmemaddr = 32'h0;
		dmemstore = 32'd0;
		dload = 32'd0;
		@(posedge CLK) nRST = 0;
		@(posedge CLK) nRST = 1;
		/*
		//compulsory load miss
		@(posedge CLK) dmemREN = 1; //DCHECK_HIT
		@(posedge CLK); //MISS1
		@(negedge CLK) if(~dREN || daddr != 32'h0)
		begin
			$display("Wrong Case 1.1");
			$finish;
		end
		@(posedge CLK) dload = 32'd12;
		dwait = 0;
		@(posedge CLK) dwait = 1; //MISS2
		@(negedge CLK)if(~dREN || daddr != 32'h4)
		begin	
			$display("Wrong Case 1.2");
			$finish;
		end
		@(posedge CLK) dload = 32'd14;
		dwait = 0;
		@(posedge CLK) dwait = 1; //MISS_HIT
		if(dREN)
		begin	
			$display("Wrong Case 1.3");
			$finish;
		end
		@(negedge CLK) if(~dhit || dmemload != 32'd12)
		begin	
			$display("Wrong Case 1.4");
			$finish;
		end
		dmemREN = 0;
		dmemaddr = 32'h40;
		@(posedge CLK) dmemREN = 1; //DCHECK_HIT
		@(posedge CLK); //MISS1
		@(negedge CLK) if(~dREN || daddr != 32'h40)
		begin	
			$display("Wrong Case 1.5");
			$finish;
		end
		@(posedge CLK) dload = 32'd12;
		dwait = 0;
		@(posedge CLK) dwait = 1; //MISS2
		@(negedge CLK) if(~dREN || daddr != 32'h44)
		begin	
			$display("Wrong Case 1.6");
			$finish;
		end
		@(posedge CLK) dload = 32'd14;
		dwait = 0;
		@(posedge CLK) dwait = 1; //MISS_HIT
		if(dREN)
		begin	
			$display("Wrong Case 1.7");
			$finish;
		end
		@(negedge CLK) if(~dhit || dmemload != 32'd12)
		begin	
			$display("Wrong Case 1.8");
			$finish;
		end
		dmemREN = 0;
		
		//store hit
		dmemaddr = 32'h0;
		dmemstore = 32'd20;
		@(posedge CLK) dmemWEN = 1;
		@(posedge CLK) dmemWEN = 0;
		dmemREN = 1;
		@(negedge CLK) if(~dhit || dmemload != 32'd20)
		begin	
			$display("Wrong Case 3.1");
			$finish;
		end
		dmemREN = 0;
		
		//load hit
		dmemaddr = 32'h40;
		@(posedge CLK) dmemREN = 1;
		@(negedge CLK) if(~dhit || dmemload != 32'd12)
		begin	
			$display("Wrong Case 2.1");
			$finish;
		end
		@(posedge CLK) dmemREN = 0;		
		
		//conflict load miss
		dmemaddr = 32'h80;
		@(posedge CLK) dmemREN = 1; //CHECK_HIT
		@(posedge CLK) //MISS_DIRTY1
		@(negedge CLK) if(~dWEN || daddr != 32'h0 || dstore != 32'd20)
		begin	
			$display("Wrong Case 4.1");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1; //MISS_DIRTY2
		@(negedge CLK) if(~dWEN || daddr != 32'h4 || dstore != 32'd14)
		begin	
			$display("Wrong Case 4.2");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1; //MISS1
		@(negedge CLK) if(~dREN || daddr != 32'h80)
		begin	
			$display("Wrong Case 4.3");
			$finish;
		end
		@(posedge CLK) dload = 32'd21;
		dwait = 0;
		@(posedge CLK) dwait = 0; //MISS2
		@(negedge CLK) if(~dREN || daddr != 32'h84)
		begin	
			$display("Wrong Case 4.4");
			$finish;
		end
		@(posedge CLK) dload = 32'd23;
		dwait = 0;
		@(posedge CLK) dwait = 1; //MISS_HIT
		if(dREN)
		begin	
			$display("Wrong Case 4.5");
			$finish;
		end
		@(negedge CLK) if(~dhit || dmemload != 32'd21)
		begin	
			$display("Wrong Case 4.6");
			$finish;
		end
		dmemREN = 0;
		
		//conflict store miss
		dmemaddr = 32'h0;
		dmemstore = 32'd10;
		@(posedge CLK) dmemWEN = 1; //DCHECK_HIT
		@(posedge CLK); //MISS1
		@(negedge CLK) if(~dREN || daddr != 32'h0) 
		begin	
			$display("Wrong Case 5.1");
			$finish;
		end
		@(posedge CLK) dload = 32'd20;
		dwait = 0;
		@(posedge CLK) dwait = 1; //MISS2
		@(negedge CLK) if(~dREN || daddr != 32'h4)
		begin	
			$display("Wrong Case 5.2");
			$finish;
		end
		@(posedge CLK) dload = 32'd14;
		dwait = 0;
		@(posedge CLK) dwait = 1; //MISS_HIT
		dmemWEN = 0;
		dmemREN = 1;
		@(negedge CLK) if(~dhit || dmemload != 32'd10)
		begin	
			$display("Wrong Case 5.3");
			$finish;
		end
		dmemREN = 0;
		
		//halt	
		@(posedge CLK) halt = 1;
		@(negedge CLK) if(~dcif.flushed)
		begin	
			$display("Wrong Case 6.1");
			$finish;
		end
		@(posedge CLK); //FLUSH
		@(posedge CLK); //FLUSH1
		@(negedge CLK) if(~dWEN || dstore != 32'd10 || daddr != 32'h0)
		begin	
			$display("Wrong Case 6.2");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1; //FLUSH2
		@(negedge CLK) if(~dWEN || dstore != 32'd14 || daddr != 32'h4)
		begin	
			$display("Wrong Case 6.3");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1;
		@(negedge CLK) while(~dWEN && i < 1000) //wait for SAVE_COUNT
		begin
			@(posedge CLK) i++;
		end
		if(i == 1000)
		begin	
			$display("Wrong Case 6.4");
			$finish;
		end
		@(negedge CLK) if(dstore != 32'd3 || daddr != 32'h3100)
		begin	
			$display("Wrong Case 6.5");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1;
		*/
		
		//send busRd request
		@(posedge CLK) dmemREN = 1;
		@(negedge CLK) if(!cctrans || ccwrite) begin
			$display("Failed 1");
			$finish;
		end
		@(posedge CLK) dload = 32'd12;
		dwait = 0;
		@(posedge CLK) dload = 32'd24;
		dwait = 0;
		@(posedge CLK) if(cctrans || ccwrite) begin
			$display("Failed 2");
			$finish;
		end
		dmemREN = 0;
		
		//send busRdx request
		@(posedge CLK) dmemWEN = 1;
		dmemaddr = 32'h8;
		@(negedge CLK) if(!cctrans) begin
			$display("Failed 3");
			$finish;
		end
		@(posedge CLK) dload = 32'd10;
		dwait = 0;
		@(posedge CLK) dload = 32'd20;
		dwait = 0;
		@(posedge CLK) if(cctrans || ccwrite) begin
			$display("Failed 4");
			$finish;
		end
		dmemWEN = 0;
		
		//receive busRd request and wb
		@(posedge CLK) ccwait = 1;
		@(posedge CLK);
		@(negedge CLK) if(cctrans || !ccwrite) begin
			$display("Failed 5");
			$finish;
		end
		@(negedge CLK) if(dstore != 32'd12) begin
			$display("Failed 6");
			$finish;
		end
		dwait = 0;
		@(negedge CLK) if(dstore != 32'd24) begin
			$display("Failed 7");
			$finish;
		end
		dwait = 0;
		@(posedge CLK) ccwait = 0;
		
		//receive busRdx request and wb
		@(posedge CLK) ccwait = 1;
		ccinv = 1;
		@(posedge CLK);
		@(negedge CLK) if(cctrans || !ccwrite) begin
			$display("Failed 8");
			$finish;
		end
		@(negedge CLK) if(dstore != 32'd12) begin
			$display("Failed 9");
			$finish;
		end
		dwait = 0;
		@(negedge CLK) if(dstore != 32'd24) begin
			$display("Failed 10");
			$finish;
		end
		dwait = 0;
		@(posedge CLK) ccwait = 0;
		
		//receive busRd and have no copy
		@(posedge CLK) ccwait = 1;
		ccinv = 0;
		@(posedge CLK);
		@(negedge CLK) if(cctrans || ccwrite) begin
			$display("Failed 11");
			$finish;
		end
		@(posedge CLK) ccwait = 0;
		
		//receive busRdx and have no copy
		@(posedge CLK) ccwait = 1;
		ccinv = 0;
		@(posedge CLK);
		@(negedge CLK) if(cctrans || ccwrite) begin
			$display("Failed 12");
			$finish;
		end
		@(posedge CLK) ccwait = 0;
		
		$display("All cases pass");
	end
endprogram
