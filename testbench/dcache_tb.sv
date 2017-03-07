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
	test PROG (CLK, dcif.dhit, dcif.flushed, cif.dREN, cif.dWEN, dcif.dmemload, cif.dstore, cif.daddr,
			   nRST, dcif.halt, dcif.dmemREN, dcif.dmemWEN, cif.dwait, dcif.dmemaddr, dcif.dmemstore, cif.dload);
endmodule

program test(
	input logic CLK, dhit, flushed, dREN, dWEN,
		  cpu_types_pkg::word_t dmemload, dstore, daddr,
	output logic nRST, halt, dmemREN, dmemWEN, dwait,
		   cpu_types_pkg::word_t dmemaddr, dmemstore, dload
);
	integer i;
	
	initial
	begin
		nRST = 1;
		halt = 0;
		dwait = 1;
		dmemREN = 0;
		dmemWEN = 0;
		dmemaddr = 32'h0;
		dmemstore = 32'd0;
		dload = 32'd0;
		@(posedge CLK) nRST = 0;
		@(posedge CLK) nRST = 1;
		
		//compulsory load miss
		@(posedge CLK) dmemREN = 1;
		@(posedge CLK) if(~dREN || daddr != 32'h0)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		@(posedge CLK) dload = 32'd12;
		dwait = 0;
		@(posedge CLK) if(~dREN || daddr != 32'h1)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		@(posedge CLK) dload = 32'd14;
		dwait = 0;
		@(posedge CLK) dwait = 1;
		if(dREN)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		@(negedge CLK) if(~dhit || dmemload != 32'd12)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		dmemREN = 0;
		dmemaddr = 32'h40;
		@(posedge CLK) dmemREN = 1;
		@(posedge CLK) if(~dREN || daddr != 32'h0)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		@(posedge CLK) dload = 32'd12;
		dwait = 0;
		@(posedge CLK) if(~dREN || daddr != 32'h1)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		@(posedge CLK) dload = 32'd14;
		dwait = 0;
		@(posedge CLK) dwait = 1;
		if(dREN)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		@(negedge CLK) if(~dhit || dmemload != 32'd12)
		begin	
			$display("Wrong Case 1");
			$finish;
		end
		dmemREN = 0;
		
		//load hit
		dmemaddr = 32'h0;
		@(posedge CLK) dmemREN = 1;
		@(negedge CLK) if(~dhit || dmemload != 32'd12)
		begin	
			$display("Wrong Case 2");
			$finish;
		end
		dmemREN = 0;
		
		//store hit
		dmemstore = 32'd20;
		@(posedge CLK) dmemWEN = 1;
		@(posedge CLK) dmemWEN = 0;
		dmemREN = 1;
		@(negedge CLK) if(~dhit || dmemload != 32'd20)
		begin	
			$display("Wrong Case 3\n");
			$finish;
		end
		dmemREN = 0;
		
		//conflict load miss
		dmemaddr = 32'h80;
		@(posedge CLK) dmemREN = 1;
		@(posedge CLK) if(~dWEN || daddr != 32'h0 || dstore != 32'd20)
		begin	
			$display("Wrong Case 4\n");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) if(~dWEN || daddr != 32'h1 || dstore != 32'd14)
		begin	
			$display("Wrong Case 4\n");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) if(~dREN || daddr == 32'h80)
		begin	
			$display("Wrong Case 4\n");
			$finish;
		end
		@(posedge CLK) dload = 32'd21;
		dwait = 0;
		@(posedge CLK) if(~dREN || daddr == 32'h81)
		begin	
			$display("Wrong Case 4\n");
			$finish;
		end
		@(posedge CLK) dload = 32'd23;
		dwait = 0;
		@(posedge CLK) dwait = 1;
		if(dREN)
		begin	
			$display("Wrong Case 4");
			$finish;
		end
		@(negedge CLK) if(~dhit || dmemload != 32'd21)
		begin	
			$display("Wrong Case 4\n");
			$finish;
		end
		dmemREN = 0;
		
		//conflict store miss
		dmemaddr = 32'h0;
		dmemstore = 32'd10;
		@(posedge CLK) dmemWEN = 1;
		@(posedge CLK) if(~dREN || daddr == 32'h0)
		begin	
			$display("Wrong Case 5\n");
			$finish;
		end
		@(posedge CLK) dload = 32'd20;
		dwait = 0;
		@(posedge CLK) if(~dREN || daddr == 32'h1)
		begin	
			$display("Wrong Case 5\n");
			$finish;
		end
		@(posedge CLK) dload = 32'd14;
		dwait = 0;
		@(posedge CLK) dwait = 1;
		dmemWEN = 0;
		dmemREN = 1;
		@(negedge CLK) if(~dhit || dmemload != 32'd10)
		begin	
			$display("Wrong Case 5\n");
			$finish;
		end
		dmemREN = 0;
		
		//halt	
		@(posedge CLK) halt = 1;
		@(posedge CLK);
		@(posedge CLK) if(~dWEN || dstore != 32'd10 || daddr != 32'h0)
		begin	
			$display("Wrong Case 6\n");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1;
		if(~dWEN || dstore != 32'd10 || daddr != 32'h1)
		begin	
			$display("Wrong Case 6\n");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1;
		while(~dWEN && i < 1000)
		begin
			@(posedge CLK) i++;
		end
		if(i == 1000)
		begin	
			$display("Wrong Case 6\n");
			$finish;
		end
		if(dstore != 32'd3 || daddr != 32'h3100)
		begin	
			$display("Wrong Case 6\n");
			$finish;
		end
		@(posedge CLK) dwait = 0;
		@(posedge CLK) dwait = 1;
		if(~dcif.flushed)
		begin	
			$display("Wrong Case 6\n");
			$finish;
		end
		
		$display("All cases pass");
	end
endprogram
