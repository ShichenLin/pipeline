	org 0x0000
	addi $29, $0, 0xfffc
	addi $1, $1, 0x0100
	lw $7, 0($1)
	push $7
	lw $8, 4($1)
	push $8
	jal mult
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
	cfw 8
	cfw 3
