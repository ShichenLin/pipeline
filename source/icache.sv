typdef struct packed {
	logic valid;
	logic dirty;
	logic [ITAG_W-1:0] itag;
	wort_t iword;
} icache_t;

typedef enum logic [1:0] {
	MISS = 2'd0;
	HIT = 2'd1;
	UPDATE = 2'd2;
} istate_t;

module icache(
	input logic CLK, nRST,
	datapath_cache_if.icache dcif,
	cache_if.icache cif
);
	icache_t icache [15:0];
	istate_t state, nxtstate;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			icache <= 
			state <= ;
		end
		else begin
			state <= nxtstate;
		end
	end
	
	always_comb
	begin
		nxtstate = MISS;
		casez(state)

		
		endcase
	end
endmodule
