	org 0x0
	addi $1, $1, 0x100
	addi $2, $2, 0x104
	jr $2
	lw $2, 0($1)
	lw $3, 4($1)
	sltiu $4, $3, 16
	j skip
	addi $5, $5, 0xff
	andi $5, $5, 0x0f
	sw $5, 12($1)
skip:
	sw $4, 8($1)
	halt
	
	org 0x100
	cfw 12
	addi $5, $5, 0xff
	andi $5, $5, 0x0f
	sw $5, 12($1)
	halt
