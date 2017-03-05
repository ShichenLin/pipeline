typedef struct packed {
	logic valid;
	logic dirty;
	logic LRU;
	logic [DTAG_W-1:0]] dtag;
	wort_t dword1;
	wort_t dword2;
} dcache_t;

typedef enum logic [] {

} dstate_t;

module dcache(
	input logic CLK, nRST,
	datapath_cache_if.dcache dcif,
	cache_if.dcache cif
);
	dcache_t dcache [15:0];
	dstate_t state, nxtstate;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			dcache <= ;
			state <= ;
		end
		else begin
			state <= nxtstate;
		end
	end
	
	always_comb
	begin
		state
	end
endmodule
