`include "cache_pkg.vh"
`include "cpu_types_pkg.vh"

module dcache(
	input logic CLK, nRST,
	datapath_cache_if.dcache dcif,
	caches_if.dcache cif
);
	import cache_pkg::*;
	import cpu_types_pkg::*;

	dcache_t dcache [7:0];
	dcache_t next_dcache [7:0];
	dstate_t state, nxtstate;
	dcachef_t addr;
	word_t count, nxtcount;
	logic [3:0] flushed_frame, nxt_flushed_frame;
	logic dirty_blk, nxt_dirty_blk;
	
	assign addr = dcif.dmemaddr;
	//assign dcif.flushed = dcif.halt;   //hex Mar18 17:52
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			dcache <= '{default : '0};
			state <= DCHECK_HIT;
			count <= 0;
			flushed_frame <= 0;
			dirty_blk <= 0;
		end
		else begin
			dcache <= next_dcache;
			state <= nxtstate;
			count <= nxtcount;
			flushed_frame <= nxt_flushed_frame;
			dirty_blk <= nxt_dirty_blk;
		end
	end

	always_comb
	begin
        nxtcount = count; // hex Mar18 17:52
		nxt_dirty_blk = dirty_blk;
		nxt_flushed_frame = flushed_frame;
		next_dcache = dcache;
		nxtstate = state;
        dcif.flushed = 0;
    	cif.daddr = 0;
    	cif.dREN = 0;
    	cif.dWEN = 0;
    	cif.dstore = 0;
    	cif.ccwrite = 0;
    	cif.cctrans = 0;
    	dcif.dmemload = 0;
    	dcif.dhit = 0;
		case (state)
			DCHECK_HIT : begin
				if (dcif.halt) begin
					nxtstate = FLUSH;
				end else if (dcif.dmemREN) begin
					if (dcache[addr.idx].dblk[0].valid && dcache[addr.idx].dblk[0].dtag == addr.tag) begin
						nxtcount = count + 1;
						next_dcache[addr.idx].lru = 1;
						dcif.dhit = 1;
						dcif.dmemload = dcache[addr.idx].dblk[0].dword[addr.blkoff];
					end else if (dcache[addr.idx].dblk[1].valid && dcache[addr.idx].dblk[1].dtag == addr.tag) begin
						nxtcount = count + 1;
						next_dcache[addr.idx].lru = 0;
						dcif.dhit = 1;
						dcif.dmemload = dcache[addr.idx].dblk[1].dword[addr.blkoff];
					end else begin
						if (dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty) begin
							nxtstate = MISS_DIRTY1;
						end else begin
							nxtstate = MISS1;
						end
					end
				end else if (dcif.dmemWEN) begin
					if (dcache[addr.idx].dblk[0].valid && dcache[addr.idx].dblk[0].dtag == addr.tag) begin
						nxtcount = count + 1;
						next_dcache[addr.idx].lru = 1;
						next_dcache[addr.idx].dblk[0].dirty = 1;
						dcif.dhit = 1;  //change Mar18 5:25
						next_dcache[addr.idx].dblk[0].dword[addr.blkoff] = dcif.dmemstore;
					end else if (dcache[addr.idx].dblk[1].valid && dcache[addr.idx].dblk[1].dtag == addr.tag) begin
						nxtcount = count + 1;
				                dcif.dhit = 1;	//change Mar18 5:25				
                                                next_dcache[addr.idx].lru = 0;
						next_dcache[addr.idx].dblk[1].dirty = 1;
						next_dcache[addr.idx].dblk[1].dword[addr.blkoff] = dcif.dmemstore;
					end else begin
						if (dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty) begin
							nxtstate = MISS_DIRTY1;
						end else begin
							nxtstate = MISS1;
						end
					end
				end
			end
			MISS_DIRTY1 : begin
				cif.dWEN = 1;
				cif.daddr = {dcache[addr.idx].dblk[dcache[addr.idx].lru].dtag, addr.idx, 1'b0, 2'b00};
				cif.dstore = dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[0];
				if (~cif.dwait) begin
					nxtstate = MISS_DIRTY2;
				end
			end
			MISS_DIRTY2 : begin
				cif.dWEN = 1;
				cif.daddr = {dcache[addr.idx].dblk[dcache[addr.idx].lru].dtag, addr.idx, 1'b1, 2'b00};
				cif.dstore = dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[1];
				if (~cif.dwait) begin
					next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty = 0;
					nxtstate = MISS1;
				end
			end
			MISS1 : begin
				cif.dREN = 1;
				cif.daddr = {addr.tag, addr.idx, 1'b0, 2'b00};
				if (~cif.dwait) begin
					if (addr == {addr.tag, addr.idx, 1'b0, 2'b00} && dcif.dmemWEN) begin
						next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty = 1;
						next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[0] = dcif.dmemstore;
					end else begin
						next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[0] = cif.dload;
					end
					nxtstate = MISS2;
				end
			end
			MISS2 : begin
				cif.dREN = 1;
				cif.daddr = {addr.tag, addr.idx, 1'b1, 2'b00};
				if (~cif.dwait) begin
					next_dcache[addr.idx].dblk[dcache[addr.idx].lru].valid = 1;
					if (addr == {addr.tag, addr.idx, 1'b1, 2'b00} && dcif.dmemWEN) begin
						next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty = 1;
						next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[1] = dcif.dmemstore;
					end else begin
						next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[1] = cif.dload;
					end
					nxtstate = MISS_HIT;
					next_dcache[addr.idx].dblk[dcache[addr.idx].lru].dtag = addr.tag;
				end
			end
			MISS_HIT : begin
				dcif.dhit = 1;				
				if (dcif.dmemREN) begin
					dcif.dmemload = dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[addr.blkoff];
				end
				nxtstate = DCHECK_HIT;
				next_dcache[addr.idx].lru = ~dcache[addr.idx].lru;
			end
			FLUSH : begin
				if (flushed_frame < 8) begin
					if (dcache[flushed_frame].dblk[0].dirty) begin
						nxtstate = FLUSH1;
						nxt_dirty_blk = 0;
					end else if (dcache[flushed_frame].dblk[1].dirty) begin
						nxtstate = FLUSH1;
						nxt_dirty_blk = 1;
					end else begin
						next_dcache[flushed_frame].dblk[0].valid = 0;
						next_dcache[flushed_frame].dblk[1].valid = 0;
						nxt_flushed_frame = flushed_frame + 1;
					end
				end else begin
					nxtstate = SAVE_COUNT;
				end
			end
			FLUSH1 : begin
				cif.dWEN = 1;
				cif.dstore = dcache[flushed_frame].dblk[dirty_blk].dword[0];
				cif.daddr = {dcache[flushed_frame].dblk[dirty_blk].dtag, flushed_frame[2:0], 3'b000};
				if (~cif.dwait) begin
					nxtstate = FLUSH2;
				end
			end
			FLUSH2 : begin
				cif.dWEN = 1;
				cif.dstore = dcache[flushed_frame].dblk[dirty_blk].dword[1];
				cif.daddr = {dcache[flushed_frame].dblk[dirty_blk].dtag, flushed_frame[2:0], 3'b100};
				if (~cif.dwait) begin
					next_dcache[flushed_frame].dblk[dirty_blk].dirty = 0;
					nxtstate = FLUSH;
				end
			end
			SAVE_COUNT : begin
				cif.daddr = 32'h3100;
				cif.dWEN = 1;
				cif.dstore = count;
				if (~cif.dwait) begin
					nxtstate = FLUSHED;
				end
			end
			FLUSHED : begin
				if(~dcif.halt) begin 
  					nxtstate = DCHECK_HIT;
				end else begin
       				 	dcif.flushed = 1;  //hex Mar18 17:52
				end
			end	
		endcase
	end
endmodule
