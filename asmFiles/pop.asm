   org 0x0000
   addi $29, $0, 0x1000
   addi $1, $1, 0x100
   addi $2, $0, 0x200
   addi $3, $0, 0x300
   push $1
   push $2
   push $3
   pop  $5
   pop  $6
   pop  $7
   push $1
   pop  $3

   halt
