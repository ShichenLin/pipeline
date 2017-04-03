`ifndef CACHE_PKG_VH
`define CACHE_PKG_VH

`include "cpu_types_pkg.vh"

package cache_pkg;
import cpu_types_pkg::*;

typedef struct packed {
	logic valid;
	logic [ITAG_W-1:0] itag;
	word_t iword;
} icache_t;

typedef enum logic [1:0] {
	ICHECK_HIT,
	MISS
} istate_t;

typedef struct packed{
	logic valid;
	logic dirty;
	logic [DTAG_W-1:0] dtag;
	word_t [1:0] dword;
}dcache_blk_t;

typedef struct packed {
	logic lru;
	dcache_blk_t [1:0] dblk;
} dcache_t;

typedef enum logic [4:0] {
	DCHECK_HIT,
	MISS_DIRTY1,
	MISS_DIRTY2,
	MISS1,
	MISS2,
	MISS_HIT,
	FLUSH,
	FLUSH1,
	FLUSH2,
	SAVE_COUNT,
	FLUSHED,
	SNOOPING,
	DATA_XFER1,
	DATA_XFER2,
        YF
} dstate_t;

endpackage
`endif
