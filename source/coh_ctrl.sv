/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module coh_ctrl (

  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;


  logic req, next_req;
  logic ilru, next_ilru;

  typedef enum logic [2:0] {
    idle,
    snooping,
    data_cache_xfer,
    data_ram_xfer
  } state_t;
  state_t state, next_state;

  always_ff @(posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      state <= idle;
    end else begin
      state <= next_state;
    end
  end

  always_ff @(posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      req <= 0;
      ilru <= 0;
    end else begin
      req <= next_req;
      ilru <= next_ilru;
    end
  end
  
  //next state logic
  always_comb begin
    next_state = state;
    casez(state)
      idle : begin
        if (ccif.cctrans) begin
          next_state = snooping;
        end
      end
      snooping : begin
        if (!ccif.cctrans) begin
          next_state = idle;
        end else begin
          next_state = ccif.ccwrite[!req] ? data_cache_xfer : data_ram_xfer;  //update from another cache if it returns write back; otherwise update from RAM
        end
      end
      data_cache_xfer : begin //update from the other cache
        if (!ccif.cctrans) begin
           next_state = idle;
        end
      end
      data_ram_xfer : begin //update from RAM
         if (!ccif.cctrans) begin
           next_state = idle;
         end
      end
    endcase
  end

  //output logic
  always_comb begin
    next_ilru = ilru;
    next_req = req;
    ccif.ccwait = 2'b00;
    ccif.ccinv = 2'b00;
    ccif.ccsnoopaddr = '0;
    ccif.iwait = 2'b11;
    ccif.dwait = 2'b11;
    ccif.iload = '0;
    ccif.dload = '0;
    ccif.ramREN = 0;
    ccif.ramWEN = 0;
    ccif.ramstore = 0;
    ccif.ramaddr = 0;
    casez(state)
      idle : begin
        if (!ccif.cctrans) begin
          if (ccif.dWEN == 2'b11) begin
            ccif.ramWEN = 1;
            ccif.ramaddr = ccif.daddr[0];
            ccif.ramstore = ccif.dstore[0];
            ccif.dwait[0] = ccif.ramstate != ACCESS;
          end else if (ccif.dWEN == 2'b01) begin
            ccif.ramWEN = 1;
            ccif.ramaddr = ccif.daddr[0];
            ccif.ramstore = ccif.dstore[0];
            ccif.dwait[0] = ccif.ramstate != ACCESS;
          end else if (ccif.dREN == 2'b10) begin
            ccif.ramWEN = 1;
            ccif.ramaddr = ccif.daddr[1];
            ccif.ramstore = ccif.dstore[1];
            ccif.dwait[1] = ccif.ramstate != ACCESS;
          end else if (ccif.iREN == 2'b11) begin
            ccif.ramREN = 1;
            ccif.ramaddr = ccif.iaddr[ilru];
            if (ccif.ramstate != ACCESS) begin
              ccif.iwait[ilru] = 0;
              ccif.iload[ilru] = ccif.ramload;
              next_ilru = ~ilru;
            end
          end else if (ccif.iREN == 2'b01) begin
            ccif.ramREN = 1;
            ccif.ramaddr = ccif.iaddr[0];
            if (ccif.ramstate != ACCESS) begin
              ccif.iwait[0] = 0;
              ccif.iload[0] = ccif.ramload;
              next_ilru = 1;
            end
          end else if (ccif.iREN == 2'b10) begin
            ccif.ramREN = 1;
            ccif.ramaddr = ccif.iaddr[1];
            if (ccif.ramstate != ACCESS) begin
              ccif.iwait[1] = 0;
              ccif.iload[1] = ccif.ramload;
              next_ilru = 1;
            end
          end
        end else begin
          next_req = ~ccif.cctrans[0]; //cctrans[0] == 1 means BusRd or BusRdx from cache 0
          ccif.ccwait = ccif.cctrans[0] ? 2'b10 : 2'b01;
        end
      end
      snooping : begin
        ccif.ccsnoopaddr[!req] = ccif.daddr[req];
        ccif.ccinv[!req] = ccif.ccwrite[req];
        ccif.ccwait[!req] = ccif.cctrans != 0;
      end
      data_cache_xfer : begin //read from the other cache
        ccif.ramWEN = ccif.dWEN[!req];
        ccif.ramaddr = ccif.daddr[req];
        ccif.ramstore = ccif.dstore[!req];
        ccif.dload[req] = ccif.dstore[!req];
        ccif.ccsnoopaddr[!req] = ccif.daddr[req];
        ccif.dwait = (ccif.ramstate != ACCESS) ? 2'b11 : 2'b00;
        ccif.ccinv[!req] = ccif.ccwrite[req];
        ccif.ccwait[!req] = ccif.cctrans != 0;
      end
      data_ram_xfer: begin //read from RAM
        ccif.dload[req] = ccif.ramload;
        ccif.ramWEN = ccif.dWEN[req];
        ccif.ramREN = ccif.dREN[req];
        ccif.ramaddr = ccif.daddr[req];
        ccif.dwait[req] = (ccif.ramstate != ACCESS);
        ccif.ccinv[!req] = ccif.ccwrite[req];
        ccif.ccwait[!req] = ccif.cctrans != 0;
      end
    endcase

  end
endmodule
/*<<<<<<< HEAD
  	input CLK, nRST,
  	cache_control_if.cc ccif
);
  	// type import
  	import cpu_types_pkg::*;

  	// number of cpus for cc
  	parameter CPUS = 2;

	assign	ccif.iwait = ccif.ramstate != ACCESS || ccif.dWEN || ccif.dREN;
	assign	ccif.dwait = ccif.ramstate != ACCESS || ~(ccif.dREN || ccif.dWEN);
	assign	ccif.iload = ccif.ramload;
	assign	ccif.dload = ccif.ramload;
	assign	ccif.ramWEN = ccif.dWEN;
	assign	ccif.ramREN = ccif.iREN && ~ccif.dWEN || ccif.dREN;
	assign	ccif.ramstore = ccif.dstore;
	assign	ccif.ramaddr = (ccif.dREN || ccif.dWEN) ? ccif.daddr : ccif.iaddr;

	//multicore signals
	assign	ccif.ccinv = 0;
	assign	ccif.ccwait = 0;
	assign	ccif.ccsnoopaddr = 0;
*/
