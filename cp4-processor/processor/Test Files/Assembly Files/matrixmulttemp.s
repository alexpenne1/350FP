nop
nop
nop
addi $7, $0, 999
nop
nop
loop:
nop
nop
nop
nop
nop
nop
nop
bne $6, $7, loop
nop
nop
nop # start matrix mult
nop # load first matrix into product
nop # product: mem 1000, $1
nop # temp product: mem 500, $10
addi $10, $0, 500
nop
nop # get gate 1 addr
addi $20, $0, 1 # $20 = 1
addi $21, $0, 100 # $21 = 100
sub $1, $1, $20 # $1 = $1 - 1
mul $1, $1, $21 # $1 = $1 * 100
addi $1, $1, 1000
nop
nop # get gate 2 addr
sub $2, $2, $20
mul $2, $2, $21
addi $2, $2, 1000
nop
nop
nop # get gate 3 addr
sub $3, $3, $20
mul $3, $3, $21
addi $3, $3, 1000
nop
nop
nop # get gate 4 addr
sub $4, $4, $20
mul $4, $4, $21
addi $4, $4, 1000
nop
nop
nop # get gate 5 addr
sub $5, $5, $20
mul $5, $5, $21
addi $5, $5, 1000
nop
addi $8, $0, 21
nop
nop
nop
nop
sw $1, 0($8)
nop
nop
nop