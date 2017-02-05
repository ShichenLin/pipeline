	org 0x0000
	addi $29, $0, 0xfffc
	addi $10, $10, 0xfff8
	addi $1, $1, 0x0100
	lw $7, 0($1)
read_data:	
	addi $1, $1, 4
	lw $8, 0($1)
	push $8
	addi $7, $7, -1
	bne $7, $0, read_data
multiply:
	jal mult
	bne $29, $10, multiply
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
	
test_data:
	org 0x0100
	cfw 4
	cfw 1 
	cfw 2
	cfw 3
	cfw 4
