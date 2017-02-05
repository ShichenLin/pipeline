	org 0x0000
	addi $29, $0, 0xfffc
	addi $1, $1, 0x100
	lw $10, 0($1)
	lw $11, 4($1)
	lw $12, 8($1)
	addi $11, $11, -1
	addi $12, $12, -2000
	addi $13, $0, 30
	push $11
	push $13
	jal mult
	pop $11
	addi $13, $0, 365
	push $12
	push $13
	jal mult
	pop $12
	add $9, $10, $11
	add $9, $9, $12
	halt
	
mult:
	and $4, $0, $0
	pop $2
	pop $3
	beq $2, $0, done
	beq $3, $0, done
loop:
	andi $5, $2, 1
	srl $2, $2, 1
	add $6, $3, $0
	sll $3, $3, 1
	beq $5, $0, loop
	add $4, $4, $6
	bne $2, $0, loop
done:
	push $4
	jr $31
	
date:
	org 0x0100
	cfw 6//day
	cfw 1//month
	cfw 2017//year
