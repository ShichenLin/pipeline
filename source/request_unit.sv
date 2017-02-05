`include "request_unit_if.vh"

module request_unit(
	input logic CLK, nRST,
	request_unit_if.ru ruif
);

	logic nxtren, nxtwen;
	
	always_ff @ (posedge CLK, negedge nRST)
	begin
		if(~nRST)
		begin
			ruif.dREN_r <= 0;
			ruif.dWEN_r <= 0;
		end
		else begin
			ruif.dREN_r <= nxtren;
			ruif.dWEN_r <= nxtwen;
		end
	end
	
	always_comb
	begin
		if(ruif.dhit)
		begin
			nxtren = 0;
			nxtwen = 0;
		end
		else if(ruif.ihit)
		begin
			if(ruif.dREN_c)
			begin
				nxtren = 1;
				nxtwen = 0;
			end
			else if(ruif.dWEN_c)
			begin
				nxtren = 0;
				nxtwen = 1;
			end
			else begin
				nxtren = 0;
				nxtwen = 0;
			end
		end
		else begin
			nxtren = ruif.dREN_r;
			nxtwen = ruif.dWEN_r;
		end
	end
endmodule
