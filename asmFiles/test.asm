	org 0x0
	addi $2, $0, 23
	addi $5, $0, 30
	addi $1, $0, 0x100
	lw $4, 0($1)
	bne $4, $1, done
	jal loop
done:
	halt
	
	org 0x100
	cfw 23
	addi $5, $5, 0xff
	andi $5, $5, 0x0f
	sw $5, 12($1)
	halt
	
loop:
	addi $2, $2, 1
	beq $2, $5, done
	jr $31
