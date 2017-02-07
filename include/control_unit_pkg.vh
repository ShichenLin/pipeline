`ifndef CONTROL_UNIT_PKG_VH
`define CONTROL_UNIT_PKG_VH

package control_unit_pkg;
	typedef enum logic [1:0] {
		ALUr = 2'b00,
		DLoad = 2'b01,
		Jal = 2'b10,
		Lui = 2'b11
	} regsel_t;
	typedef enum logic [1:0] {
		Norm = 2'b00,
		Bran = 2'b01,
		PCJr = 2'b10,
		PCJ = 2'b11
	} pcsrc_t;
	typedef enum logic [1:0] {
		ALURT = 2'b00,
		Imm = 2'b01,
		Shamt = 2'b10
	} alusrc_t;
endpackage

`endif
