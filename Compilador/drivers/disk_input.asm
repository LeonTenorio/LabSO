//Essa funcao recebera com argumento: track, sector, aonde colocar na memoria principal os valores
//inputdisk(track, sector, buffer_position)
.concat_disk_access
MOV $s0 $v0
SL $v0 8 $v0
ADD $v0 $v0 $s1
SL $v0 8 $v0
ADD $v0 $v0 $s2
BR $ra
.inputdisk
MOV $ra $s8
LOAD $s0 $sa 1
LOAD $s1 $sa 2
LOAD $s3 $sa 3
ADDI $sa $sa 3
LI $s2 1
MOV $zero $s4
MOV $s3 $s5
LI $t1 256
LI $t3 -1
.load_disk_loop
BL .concat_disk_access
IN $t0 $v0 128
BEQ $t0 $t3 .load_disk_loop_out
STORE $s5 $t0 1
ADDI $s5 $s5 1
ADDI $s4 $s4 1
ADDI $s2 $s2 1
STORE $s3 $s4 0
MOV $s4 $v0
BR $s8