//Essa funcao recebera com argumento: track, sector, aonde colocar na memoria principal os valores
.concat_disk_access
MOV $s0 $v0
SL $v0 8 $v0
ADD $v0 $v0 $s1
SL $v0 8 $v0
ADD $v0 $v0 $s2
BR $ra

.disk_input
MOV $ra $s8
ADDI $sa $sa 3
LOAD $s3 $sa 0
LOAD $s1 $sa 1
LOAD $s0 $sa 2
LI $s2 1
LI $t3 -1
LI $t1 256
LI $t2 127
MOV $zero $s4
MOV $s3 $s5

.load_disk_program
    .load_disk_program_loop
        BL .concat_disk_access
        IN $t0 $v0 128
        BEQ $t0 $t3 .load_disk_loop_out
        BNE $s2 $t2 .load_disk_loop_continue

        DIV $t0 $t1
        MFHI $s1
        MFLO $t0
        DIV $t0 $t1
        MFHI $s0
        MOV $zero $s2
        B load_disk_program_loop

        .load_disk_loop_continue
        STORE $s3 $t0 1
        ADDI $s3 $s3 1
        ADDI $s2 $s2 1
        ADDI $s4 $s4 1
        B .load_disk_program_loop
.load_disk_loop_out
STORE $s5 $s4 0
BR $s8