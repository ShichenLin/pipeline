`include "cache_pkg.vh"
`include "cpu_types_pkg.vh"

module dcache(
	input logic CLK, nRST,
	datapath_cache_if.dcache dcif,
	caches_if.dcache cif
);
	import cache_pkg::*;
	import cpu_types_pkg::*;
	
	word_t link_reg, nxt_link_reg;
	dcache_t dcache [7:0];
	dcache_t nxt_dcache [7:0];
	dstate_t state, nxtstate, pause_state, nxt_pause_state;
	dcachef_t addr, snoopaddr;
	logic [3:0] flushed_frame, nxt_flushed_frame;
	logic dirty_blk, nxt_dirty_blk, xfer_blk, nxt_xfer_blk;

	assign addr = dcif.dmemaddr;
	assign snoopaddr = cif.ccsnoopaddr;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			dcache <= '{default : '0};
			state <= DCHECK_HIT;
			pause_state <= DCHECK_HIT;
			flushed_frame <= 0;
			dirty_blk <= 0;
			xfer_blk <= 0;
			link_reg <= 0;
		end
		else begin
			dcache <= nxt_dcache;
			state <= nxtstate;
			pause_state = nxt_pause_state;
			flushed_frame <= nxt_flushed_frame;
			dirty_blk <= nxt_dirty_blk;
			xfer_blk <= nxt_xfer_blk;
			link_reg <= nxt_link_reg;
		end
	end

	always_comb
	begin
		nxt_link_reg = dcif.datomic && dcif.dmemREN ? dcif.dmemaddr : link_reg;
        nxt_dirty_blk = dirty_blk;
        nxt_flushed_frame = flushed_frame;
		nxt_dcache = dcache;
		nxtstate = state;
		nxt_pause_state = pause_state;
		nxt_xfer_blk = xfer_blk;
        dcif.flushed = 0;
    	cif.daddr = 0;
    	cif.dREN = 0;
    	cif.dWEN = 0;
   		cif.dstore = 0;
		//change the ccwrite to another block
    	dcif.dmemload = 0;
    	dcif.dhit = 0;
		case (state)
			DCHECK_HIT : begin
				if (dcif.halt) begin
					nxtstate = FLUSH;
				end else if (dcif.dmemREN) begin
					if (dcache[addr.idx].dblk[0].valid && dcache[addr.idx].dblk[0].dtag == addr.tag) begin
						nxt_dcache[addr.idx].lru = 1;
						dcif.dhit = 1;
						dcif.dmemload = dcache[addr.idx].dblk[0].dword[addr.blkoff];
					end else if (dcache[addr.idx].dblk[1].valid && dcache[addr.idx].dblk[1].dtag == addr.tag) begin
						nxt_dcache[addr.idx].lru = 0;
						dcif.dhit = 1;
						dcif.dmemload = dcache[addr.idx].dblk[1].dword[addr.blkoff];
					end else begin
						if (dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty) begin
							nxtstate = MISS_DIRTY1;
						end else begin
							nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].valid = 0;//change
							nxtstate = MISS1;
						end
					end
				end else if (dcif.dmemWEN) begin
					if (dcache[addr.idx].dblk[0].valid && dcache[addr.idx].dblk[0].dtag == addr.tag && dcache[addr.idx].dblk[0].dirty) begin //write hit and current state is modified
						nxt_dcache[addr.idx].lru = 1;
						dcif.dhit = 1;  //change Mar18 5:25
						nxt_dcache[addr.idx].dblk[0].dword[addr.blkoff] = dcif.dmemstore;
					end else if (dcache[addr.idx].dblk[1].valid && dcache[addr.idx].dblk[1].dtag == addr.tag && dcache[addr.idx].dblk[1].dirty) begin //write hit and current state is modified
						dcif.dhit = 1;	//change Mar18 5:25
						nxt_dcache[addr.idx].lru = 0;
						nxt_dcache[addr.idx].dblk[1].dword[addr.blkoff] = dcif.dmemstore;
					end else begin
						if (dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty) begin
							nxtstate = MISS_DIRTY1;
						end else begin
							nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].valid = 0;//change
							nxtstate = MISS1;
						end
					end
				end
  				if (cif.ccwait) begin //change{
					nxt_pause_state = DCHECK_HIT;
					nxtstate = SNOOPING;
				end//change }
			end
			MISS_DIRTY1 : begin
				cif.dWEN = 1;
				cif.daddr = {dcache[addr.idx].dblk[dcache[addr.idx].lru].dtag, addr.idx, 1'b0, 2'b00};
				cif.dstore = dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[0];
				if (~cif.dwait) begin
					nxtstate = MISS_DIRTY2;
				end
				//change{
				if (cif.ccwait) begin
					nxt_pause_state = MISS_DIRTY1;
					nxtstate = SNOOPING;
				end
				//change }
			end
			MISS_DIRTY2 : begin
				cif.dWEN = 1;
				cif.daddr = {dcache[addr.idx].dblk[dcache[addr.idx].lru].dtag, addr.idx, 1'b1, 2'b00};
				cif.dstore = dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[1];
				if (~cif.dwait) begin
					nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty = 0;
					nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].valid = 0;//change
					nxtstate = MISS1;
				end// change {
				if (cif.ccwait) begin
					nxt_pause_state = MISS_DIRTY2;
					nxtstate = SNOOPING;
				end//change }
			end
			MISS1 : begin
				cif.dREN = 1;
				cif.daddr = {addr.tag, addr.idx, 1'b0, 2'b00};
				if (~cif.dwait) begin
					if (addr == {addr.tag, addr.idx, 1'b0, 2'b00} && dcif.dmemWEN) begin
						nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty = 1;
						nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[0] = dcif.dmemstore;
					end else begin
						nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[0] = cif.dload;
					end
					nxtstate = MISS2;
				end
			end
			MISS2 : begin
				cif.dREN = 1;
				cif.daddr = {addr.tag, addr.idx, 1'b1, 2'b00};
				if (~cif.dwait) begin
					nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].valid = 1;
					if (addr == {addr.tag, addr.idx, 1'b1, 2'b00} && dcif.dmemWEN) begin
						nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dirty = 1;
						nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[1] = dcif.dmemstore;
					end else begin
						nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dword[1] = cif.dload;
					end
					nxtstate = DCHECK_HIT;
					nxt_dcache[addr.idx].dblk[dcache[addr.idx].lru].dtag = addr.tag;
				end
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
						nxt_dcache[flushed_frame].dblk[0].valid = 0;
						nxt_dcache[flushed_frame].dblk[1].valid = 0;
						nxt_flushed_frame = flushed_frame + 1;
					end
				end else begin
					nxtstate = FLUSHED;
				end
				if (cif.ccwait) begin
					nxt_pause_state = FLUSH;
					nxtstate = SNOOPING;
				end
			end
			FLUSH1 : begin
				cif.dWEN = 1;
				cif.dstore = dcache[flushed_frame].dblk[dirty_blk].dword[0];
				cif.daddr = {dcache[flushed_frame].dblk[dirty_blk].dtag, flushed_frame[2:0], 3'b000};
				if (~cif.dwait) begin
					nxtstate = FLUSH2;
				end
				if (cif.ccwait) begin
					nxt_pause_state = FLUSH1;
					nxtstate = SNOOPING;
				end
			end
			FLUSH2 : begin
				cif.dWEN = 1;
				cif.dstore = dcache[flushed_frame].dblk[dirty_blk].dword[1];
				cif.daddr = {dcache[flushed_frame].dblk[dirty_blk].dtag, flushed_frame[2:0], 3'b100};
				if (~cif.dwait) begin
					nxt_dcache[flushed_frame].dblk[dirty_blk].dirty = 0;
					nxtstate = FLUSH;
				end
				if (cif.ccwait) begin
					nxt_pause_state = FLUSH2;
					nxtstate = SNOOPING;
				end
			end
			FLUSHED : begin
				if (~dcif.halt) begin
  					nxtstate = DCHECK_HIT;
				end else begin
       				dcif.flushed = 1;  //hex Mar18 17:52
				end
			end
			SNOOPING : begin
				if (dcache[snoopaddr.idx].dblk[0].valid && snoopaddr.tag == dcache[snoopaddr.idx].dblk[0].dtag) begin
					nxtstate = DATA_XFER1;
					nxt_xfer_blk = 0;
				end else if (dcache[snoopaddr.idx].dblk[1].valid && snoopaddr.tag == dcache[snoopaddr.idx].dblk[1].dtag) begin
					nxtstate = DATA_XFER1;
					nxt_xfer_blk = 1;
				end else begin
					if (~cif.ccwait) nxtstate = pause_state;
				end
			end
			DATA_XFER1 : begin
				cif.dstore = dcache[snoopaddr.idx].dblk[xfer_blk].dword[0];//change 
				cif.dWEN = 1;
				if (~cif.dwait) begin
					nxtstate = DATA_XFER2;
				end
			end
			DATA_XFER2 : begin
				cif.dstore = dcache[snoopaddr.idx].dblk[xfer_blk].dword[1];
				cif.dWEN = 1;
				if (~cif.dwait) begin
					if (cif.ccinv) begin
						nxt_dcache[snoopaddr.idx].dblk[xfer_blk].valid = 0;
						if(link_reg[31:3] == {snoopaddr.tag, snoopaddr.idx}) nxt_link_reg = 0;
					end
					nxtstate = WAIT;
				end
			end
			WAIT : begin 
				if(~cif.ccwait) nxtstate = pause_state;         
			end
		endcase
	end // change {
	always_comb begin
		cif.ccwrite = 0;
		cif.cctrans = 0;
		//request is deasserted at MISS_HIT state
		if (dcif.dmemWEN) begin
			if ((!dcache[addr.idx].dblk[1].dirty || dcache[addr.idx].dblk[1].dtag != addr.tag || !dcache[addr.idx].dblk[1].valid) && (!dcache[addr.idx].dblk[0].dirty || dcache[addr.idx].dblk[0].dtag != addr.tag || !dcache[addr.idx].dblk[0].valid)) begin //busRdx request when write is not hit or current state is not M
				cif.ccwrite = 1;
				cif.cctrans = 1;
			end
		end else if (dcif.dmemREN) begin
			if ((!dcache[addr.idx].dblk[1].valid || dcache[addr.idx].dblk[1].dtag != addr.tag) && (!dcache[addr.idx].dblk[0].valid || dcache[addr.idx].dblk[0].dtag != addr.tag)) begin //busRd request when read is not hit
				cif.cctrans = 1;
			end
		end
		if (state == SNOOPING && cif.ccwait) begin
			if (dcache[snoopaddr.idx].dblk[0].valid && snoopaddr.tag == dcache[snoopaddr.idx].dblk[0].dtag) begin
				cif.ccwrite = 1;
			end else if (dcache[snoopaddr.idx].dblk[1].valid && snoopaddr.tag == dcache[snoopaddr.idx].dblk[1].dtag) begin
				cif.ccwrite = 1;
			end
		end
	end
       //} change
endmodule
