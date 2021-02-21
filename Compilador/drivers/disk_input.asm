//Essa funcao recebera com argumento: track, sector, aonde colocar na memoria principal os valores
.concat_disk_access
MOV $t4 $v0
SL $v0 8 $v0
ADD $v0 $v0 $t5
SL $v0 8 $v0
ADD $v0 $v0 $t6
BR $ra
.disk_input
MOV $ra $t8
LOAD $t7 $sa 3
LOAD $t5 $sa 2
LOAD $t4 $sa 1
ADDI $sa $sa 3
LI $t6 1
LI $t3 -1
LI $t1 256
LI $t2 127
MOV $zero $t9
MOV $t7 $t10
.load_disk_program
.load_disk_program_loop
BL .concat_disk_access
IN $t0 $v0 128
BEQ $t0 $t3 .load_disk_loop_out
BNE $t6 $t2 .load_disk_loop_continue
DIV $t0 $t1
MFHI $t5
MFLO $t0
DIV $t0 $t1
MFHI $t4
MOV $zero $t6
B load_disk_program_loop
.load_disk_loop_continue
STORE $t7 $t0 1
ADDI $t7 $t7 1
ADDI $t6 $t6 1
ADDI $t9 $t9 1
B .load_disk_program_loop
.load_disk_loop_out
STORE $t10 $t9 0
BR $t8