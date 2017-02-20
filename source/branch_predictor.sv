module branch_predictor(
	input logic CLK, nRST,
	branch_predictor_if.bp bpif
);

	logic [60:0] buffer [3:0], nxt [3:0];
	logic [1:0] state, nxtstate; //0:not taken1 1:not taken2 2:taken1 3:taken2
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			buffer[0] <= 0;
			buffer[1] <= 0;
			buffer[2] <= 0;
			buffer[3] <= 0;
			state <= 0;
		end
		else begin
			buffer[0] <= nxt[0];
			buffer[1] <= nxt[1];
			buffer[2] <= nxt[2];
			buffer[3] <= nxt[3];
			state <= nxtstate;
		end
	end
	
	always_comb
	begin
		bpif.select = 0;
		bpif.nxtPC = 0;
		nxtstate = state;
		bpif.taken = 0;
		if(bpif.br)
		begin
			if(bpif.br_result)
			begin
				if(buffer[bpif.brPC[3:2]][59:32] == bpif.brPC[31:4])
				begin
					nxt[bpif.brPC[3:2]][31:0] = bpif.braddr;
				end
			end
			casez(state)
			begin
				2'd0: begin
					bpif.taken = 0;
					if(bpif.br_result) nxtstate = 2'd1;
				end
				2'd1: begin
					bpif.taken = 0;
					if(bpif.br_result) nxtstate = 2'd2;
					else nxtstate = 2'd0;
				end
				2'd2: begin
					bpif.taken = 1;
					if(~bpif.br_result) nxtstate = 2'd3;
				end
				2'd3: begin
					bpif.taken = 1;
					if(~bpif.br_result) nxtstate = 2'd0;
					else nxtstate = 2'd2;
				end
			endcase
		end
		if(state > 1)
		begin
			casez(bpif.PC[3:2])
			begin
				2'd0: begin
					if(bpif.PC[31:4] == buffer[0][59:32])
					begin
						bpif.select = 1;
						bpif.nxtPC = buffer[0][31:0];
					end
				end
				2'd1: begin
					if(bpif.PC[31:4] == buffer[1][59:32])
					begin
						bpif.select = 1;
						bpif.nxtPC = buffer[1][31:0];
					end
				end
				2'd2: begin
					if(bpif.PC[31:4] == buffer[2][59:32])
					begin
						bpif.select = 1;
						bpif.nxtPC = buffer[2][31:0];
					end
				end
				2'd3: begin
					if(bpif.PC[31:4] == buffer[3][59:32])
					begin
						bpif.select = 1;
						bpif.nxtPC = buffer[3][31:0];
					end
				end
			endcase
		end
	end
endmodule
