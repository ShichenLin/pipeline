`include "cache_pkg.vh"
`include "cpu_types_pkg.vh"

module icache(
	input logic CLK, nRST,
	datapath_cache_if.icache dcif,
	caches_if.icache cif
);
	import cpu_types_pkg::*;
	import cache_pkg::*;

	icache_t icache [15:0];
	icache_t next_icache [15:0];
	istate_t state, nxtstate;

	icachef_t addr;
	assign addr = dcif.imemaddr;

	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			icache <= '{default : '0};
			state <= ICHECK_HIT;
		end
		else begin
			icache <= next_icache;
			state <= nxtstate;
		end
	end

	always_comb
	begin
		nxtstate = state;
		cif.iREN = 0;
		cif.iaddr = 0;
		dcif.ihit = 0;
		dcif.imemload = 0;
		next_icache = icache;
		if (dcif.imemREN) begin			
			casez(state)
				ICHECK_HIT :  begin
					if (icache[addr.idx].valid && icache[addr.idx].itag == addr.tag) begin
						dcif.ihit = 1;
						dcif.imemload = icache[addr.idx].iword;
					end else begin
						nxtstate = MISS;
					end
				end
				MISS : begin
					dcif.ihit = 0;
					cif.iaddr = dcif.imemaddr;
					cif.iREN = 1;
					if (~cif.iwait) begin
						next_icache[addr.idx].valid = 1;
						next_icache[addr.idx].itag = addr.tag;
						next_icache[addr.idx].iword = cif.iload;
						nxtstate = ICHECK_HIT;
					end
				end
			endcase
		end
	end
endmodule
