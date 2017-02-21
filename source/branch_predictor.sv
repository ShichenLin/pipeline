`include "branch_predictor_if.vh"

module branch_predictor(
	input logic CLK, nRST,
	branch_predictor_if.bp bpif
);

	logic [60:0] buffer [3:0], nxt [3:0];
	logic [1:0] state [3:0], nxtstate[3:0]; //0:not taken1 1:not taken2 2:taken1 3:taken2
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			buffer[0] <= 0;
			buffer[1] <= 0;
			buffer[2] <= 0;
			buffer[3] <= 0;
			state[0] <= 0;
			state[1] <= 0;
			state[2] <= 0;
			state[3] <= 0;
		end
		else begin
			buffer[0] <= nxt[0];
			buffer[1] <= nxt[1];
			buffer[2] <= nxt[2];
			buffer[3] <= nxt[3];
			state[0] <= nxtstate[0];
			state[1] <= nxtstate[1];
			state[2] <= nxtstate[2];
			state[3] <= nxtstate[3];
		end
	end
	
	always_comb
	begin
		bpif.select = 0;
		bpif.nxtPC = 0;
		nxt[0] = buffer[0];
		nxt[1] = buffer[1];
		nxt[2] = buffer[2];
		nxt[3] = buffer[3];
		nxtstate[0] = state[0];
		nxtstate[1] = state[1];
		nxtstate[2] = state[2];
		nxtstate[3] = state[3];
		bpif.taken = 0;
		if(bpif.br)
		begin
			if(bpif.br_result)
			begin
				if(buffer[bpif.brPC[3:2]][59:32] != bpif.brPC[31:4])
				begin
					nxt[bpif.brPC[3:2]] = {1'b1, bpif.brPC[31:4], bpif.braddr};
				end
			end
			casez(state[bpif.brPC[3:2]])
				2'd0: begin
					if(bpif.br_result) nxtstate[bpif.brPC[3:2]] = 2'd1;
				end
				2'd1: begin
					if(bpif.br_result) nxtstate[bpif.brPC[3:2]] = 2'd2;
					else nxtstate[bpif.brPC[3:2]] = 2'd0;
				end
				2'd2: begin;
					if(~bpif.br_result) nxtstate[bpif.brPC[3:2]] = 2'd3;
				end
				2'd3: begin
					if(~bpif.br_result) nxtstate[bpif.brPC[3:2]] = 2'd0;
					else nxtstate[bpif.brPC[3:2]] = 2'd2;
				end
			endcase
		end
		if(state[bpif.PC[3:2]] > 1)
		begin
			if(bpif.PC[31:4] == buffer[bpif.PC[3:2]][59:32] && buffer[bpif.PC[3:2]][60])
			begin
				bpif.taken = 1;
				bpif.select = 1;
				bpif.nxtPC = buffer[bpif.PC[3:2]][31:0];
			end
		end
	end
endmodule
