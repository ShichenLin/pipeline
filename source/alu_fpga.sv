`include "alu_if.vh"
import cpu_types_pkg::*;

module alu_fpga (
	input logic CLOCK_50,
  	input logic [3:0] KEY,
  	input logic [17:0] SW,
  	output logic [6:0] HEX0,
  	output logic [6:0] HEX1,
  	output logic [6:0] HEX2,
 	output logic [6:0] HEX3,
  	output logic [6:0] HEX4,
  	output logic [6:0] HEX5,
  	output logic [6:0] HEX6,
  	output logic [6:0] HEX7,
  	output logic [6:0] LEDR
);

  	// interface
  	alu_if aluif();
  	alu ALU(aluif);
	
	word_t B_reg;
	
	always_ff @ (posedge CLOCK_50)
	begin
		B_reg <= SW[17] ? {{16{SW[16]}},SW[15:0]} : B_reg; 
	end

	dis(aluif.portO[3:0], HEX0);
	dis(aluif.portO[7:4], HEX1);
	dis(aluif.portO[11:8], HEX2);
	dis(aluif.portO[15:12], HEX3);
	dis(aluif.portO[19:16], HEX4);
	dis(aluif.portO[23:20], HEX5);
	dis(aluif.portO[27:24], HEX6);
	dis(aluif.portO[31:28], HEX7);
	
	assign aluif.portA = {{16{SW[16]}},SW[15:0]};
	assign aluif.portB = B_reg;
	assign aluif.ALUOP = ~KEY[3:0];
	
	//output check
	assign LEDR[3:0] = aluif.ALUOP;
	assign LEDR[4] = aluif.neg;
	assign LEDR[5] = aluif.of;
	assign LEDR[6] = aluif.zero;

endmodule

module dis(
	input logic [3:0] value,
	output logic [6:0] result
);
	always_comb
	begin
		casez(value)
			'h0: result = 7'b1000000;
			'h1: result = 7'b1111001;
			'h2: result = 7'b0100100;
			'h3: result = 7'b0110000;
			'h4: result = 7'b0011001;
			'h5: result = 7'b0010010;
			'h6: result = 7'b0000010;
			'h7: result = 7'b1111000;
			'h8: result = 7'b0000000;
			'h9: result = 7'b0010000;
			'ha: result = 7'b0001000;
			'hb: result = 7'b0000011;
			'hc: result = 7'b0100111;
			'hd: result = 7'b0100001;
			'he: result = 7'b0000110;
			'hf: result = 7'b0001110;
		endcase
	end
endmodule
