B .main

.after_interrupt
B .store_registers
.after_interrupt_safe_reg
BL .load_program
B .load_registers
.after_interrupt_load_reg
B .work_loop_after_interrupt

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
B .after_interrupt_safe_reg


.load_registers
LOAD $re $t0 27
SETPC $t0
LOAD $re $t0 28
SETHI $t0
LOAD $re $t0 29
SETLO $t0
LOAD $re $s0 0
LOAD $re $s1 1
LOAD $re $s2 2
LOAD $re $s3 3
LOAD $re $s4 4
LOAD $re $s5 5
LOAD $re $s6 6
LOAD $re $s7 7
LOAD $re $s8 8
LOAD $re $s9 9
LOAD $re $t0 10
LOAD $re $t1 11
LOAD $re $t2 12
LOAD $re $t3 13
LOAD $re $t4 14
LOAD $re $t5 15
LOAD $re $t6 16
LOAD $re $t7 17
LOAD $re $t8 18
LOAD $re $t9 19
LOAD $re $t10 20
LOAD $re $t11 21
LOAD $re $v0 22
LOAD $re $sp 23
LOAD $re $gp 24
LOAD $re $sa 25
LOAD $re $ra 26
B .after_interrupt_load_reg

.load_program 								//O ENDERECO BASE PARA CARREGAMENTO ESTA EM $k0
									//A QUANTIDADE DE INSTRUCOES A SEREM CARREGADAS ESTARA EM $k1
LI $t0 0
MOV $k0 $t1
.load_program_loop
	BGE $t0 $k1 .load_program_done
		LOAD $k0 $t2 0
		STOREINST $t0 $t2 0
		ADDI $t0 1
		ADDI $t1 1
.load_program_done
BR $ra

.main
	//A primeira posicao da pilha tem que ser a quantidade de instrucoes do agendador de programa
LI $k0 1								//PRIMEIRO PROGRAMA DO SO
LI $k1 SO_TAM 								//QUANTIDADE DE LINHAS DA MEMORIA DE PROGRAMA PROGRAMA DO SO
BL .load_program
BIOSINT
.work_loop
	MOV $zero $k0							//PARA CARREGAR O AGENDADOR DE PROGRAMAS
	LOAD $zero $k1 0
	B .after_interrupt
	.work_loop_after_interrupt					
	BIOSINT								//DEIXAR O ESCALONADOR EXECUTAR
									//$k0 e $k1 estaram com os valores certos
	B .after_interrupt
