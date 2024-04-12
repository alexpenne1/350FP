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
nop
nop
nop
nop
nop 
nop 
nop 
addi $10, $0, 500 # addr 1
addi $20, $0, 1
addi $21, $0, 100 
addi $8, $0, 21
nop
nop
sub $1, $1, $20 # addr 2
mul $1, $1, $21
addi $1, $1, 1000
nop
nop
sub $2, $2, $20 # addr 3
mul $2, $2, $21
addi $2, $2, 1000
nop
nop
sub $3, $3, $20 # addr 4
mul $3, $3, $21
addi $3, $3, 1000
nop
nop
sub $4, $4, $20 # addr 5
mul $4, $4, $21
addi $4, $4, 1000
nop
nop
sub $5, $5, $20 # addr 6
mul $5, $5, $21
addi $5, $5, 1000
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 1
lw $11, 0($1)
lw $12, 0($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 1($1)
lw $12, 4($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 2($1)
lw $12, 8($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 3($1)
lw $12, 12($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 0($10)
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 2
lw $11, 0($1)
lw $12, 1($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 1($1)
lw $12, 5($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 2($1)
lw $12, 9($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 3($1)
lw $12, 13($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 1($10)
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 3
lw $11, 0($1)
lw $12, 2($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 1($1)
lw $12, 6($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 2($1)
lw $12, 10($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 3($1)
lw $12, 14($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 2($10)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 4
lw $11, 0($1)
lw $12, 3($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 1($1)
lw $12, 7($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 2($1)
lw $12, 11($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 3($1)
lw $12, 15($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 3($10)
nop
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 4
lw $11, 4($1)
lw $12, 0($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 5($1)
lw $12, 4($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 6($1)
lw $12, 8($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 7($1)
lw $12, 12($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 4($10)
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 5
lw $11, 4($1)
lw $12, 1($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 5($1)
lw $12, 5($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 6($1)
lw $12, 9($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 7($1)
lw $12, 13($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 5($10)
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 6
lw $11, 4($1)
lw $12, 2($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 5($1)
lw $12, 6($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 6($1)
lw $12, 10($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 7($1)
lw $12, 14($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 6($10)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 7
lw $11, 4($1)
lw $12, 3($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 5($1)
lw $12, 7($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 6($1)
lw $12, 11($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 7($1)
lw $12, 15($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 7($10)
nop
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 8
lw $11, 8($1)
lw $12, 0($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 9($1)
lw $12, 4($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 10($1)
lw $12, 8($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 11($1)
lw $12, 12($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 8($10)
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 9
lw $11, 8($1)
lw $12, 1($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 9($1)
lw $12, 5($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 10($1)
lw $12, 9($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 11($1)
lw $12, 13($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 9($10)
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 10
lw $11, 8($1)
lw $12, 2($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 9($1)
lw $12, 6($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 10($1)
lw $12, 10($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 11($1)
lw $12, 14($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 10($10)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 11
lw $11, 8($1)
lw $12, 3($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 9($1)
lw $12, 7($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 10($1)
lw $12, 11($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 11($1)
lw $12, 15($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 11($10)
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 12
lw $11, 12($1)
lw $12, 0($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 13($1)
lw $12, 4($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 14($1)
lw $12, 8($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 15($1)
lw $12, 12($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 12($10)
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 13
lw $11, 12($1)
lw $12, 1($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 13($1)
lw $12, 5($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 14($1)
lw $12, 9($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 15($1)
lw $12, 13($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 13($10)
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 14
lw $11, 12($1)
lw $12, 2($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 13($1)
lw $12, 6($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 14($1)
lw $12, 10($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 15($1)
lw $12, 14($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 14($10)
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
addi $14, $0, 0 # element 15
lw $11, 12($1)
lw $12, 3($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 13($1)
lw $12, 7($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 14($1)
lw $12, 11($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
lw $11, 15($1)
lw $12, 15($2)
nop
nop
nop
nop
mul $13, $11, $12
add $14, $14, $13
nop
sw $14, 3($10)
nop
nop
nop
sw $1, 0($8)
nop
nop