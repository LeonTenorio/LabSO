B .main

.after_interrupt
BNE $fp $zero .store_registers
.after_store_registers
BL .load_program
BEQ $fp $zero .load_registers
.after_load_registers
BEQ $fp $zero .after_interrupt_scheduler
B .after_interrupt_program

.load_program
MOV $k0 $s0
MOV $zero $s1
.load_program_loop
BEQ $s1 $k1 .load_program_done
LOAD $t0 $s0 0
STOREINST $s1 $t0 0
ADDI $s0 $s0 1
ADDI $s1 $s1 1
B .load_program_loop
.load_program_done
BR $ra

.store_registers
STORE $re $s0 0
STORE $re $s1 1
STORE $re $s2 2
STORE $re $s3 3
STORE $re $s4 4
STORE $re $s5 5
STORE $re $s6 6
STORE $re $s7 7
STORE $re $s8 8
STORE $re $s9 9
STORE $re $t0 10
STORE $re $t1 11
STORE $re $t2 12
STORE $re $t3 13
STORE $re $t4 14
STORE $re $t5 15
STORE $re $t6 16
STORE $re $t7 17
STORE $re $t8 18
STORE $re $t9 19
STORE $re $t10 20
STORE $re $t11 21
STORE $re $v0 22
STORE $re $sp 23
STORE $re $gp 24
STORE $re $sa 25
STORE $re $ra 26
GETPC $t0
STORE $re $t0 27
MFHI $t0
STORE $re $t0 28
MFLO $t0
STORE $re $t0 29
STORE $re $fp 30
B .after_store_registers

.load_registers
LOAD $t0 $re 27
SETPC $t0
LOAD $t0 $re 28
SETHI $t0
LOAD $t0 $re 29
SETLO $t0
LOAD $s0 $re 0
LOAD $s1 $re 1
LOAD $s2 $re 2
LOAD $s3 $re 3
LOAD $s4 $re 4
LOAD $s5 $re 5
LOAD $s6 $re 6
LOAD $s7 $re 7
LOAD $s8 $re 8
LOAD $s9 $re 9
LOAD $t0 $re 10
LOAD $t1 $re 11
LOAD $t2 $re 12
LOAD $t3 $re 13
LOAD $t4 $re 14
LOAD $t5 $re 15
LOAD $t6 $re 16
LOAD $t7 $re 17
LOAD $t8 $re 18
LOAD $t9 $re 19
LOAD $t10 $re 20
LOAD $t11 $re 21
LOAD $v0 $re 22
LOAD $sp $re 23
LOAD $gp $re 24
LOAD $sa $re 25
LOAD $ra $re 26
B .after_load_registers

.load_system_main_program
MOV $ra $s8
LI $v0 1
MOV $zero $s3
LI $t3 -1
LI $t1 256
IN $t0 $v0 128
STORE $zero $t0 0
ADDI $v0 $v0 1
.load_system_main_program_loop
IN $t0 $v0 128
BEQ $t0 $t3 .load_system_main_program_out
STORE $s3 $t0 2
ADDI $s3 $s3 1
ADDI $v0 $v0 1
B .load_system_main_program_loop
.load_system_main_program_out
STORE $zero $s3 1
BR $s8

.main
BL .load_system_main_program
LOAD $t0 $zero 0
SETQUANTUM $t0
LI $k0 2
LOAD $k1 $zero 1
MOV $zero $fp
BL .load_program
SETPC $zero
BIOSINT
.work_loop
B .after_interrupt
.after_interrupt_scheduler
BIOSINT
LI $k0 2
LOAD $k1 $zero 1
B .after_interrupt
.after_interrupt_program
SETPC $zero
BIOSINT
B .work_loop