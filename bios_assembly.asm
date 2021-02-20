B .main

.after_interrupt
BNE $fp $zero .after_interrupt_safe_reg
B .store_registers
.after_interrupt_safe_reg
BL .load_program
BEQ $fp $zero .after_interrupt_load_reg
B .load_registers
.after_interrupt_load_reg
BEQ $zero $fp .work_loop_after_interrupt_program
B .work_loop_after_interrupt_system

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
//$t0 - Contador de quantidade de dados carregados para memoria de programa
//$t1 - Posicao de carregamento atual de instrucoes da memoria principal
//$t2 - Local de carregamento do dado da memoria principal
MOV $zero $t0
MOV $k0 $t1
.load_program_loop
	BGE $t0 $k1 .load_program_done
		LOAD $t1 $t2 0
		STOREINST $t0 $t2 0
		ADDI $t0 $t0 1
		ADDI $t1 $t1 1
		B .load_program_loop
.load_program_done
BR $ra

.concat_disk_access
MOV $s0 $v0
SL $v0 8 $v0
ADD $v0 $v0 $s1
SL $v0 8 $v0
ADD $v0 $v0 $s2
BR $ra


.load_system_main_program						//Nosso caso, programa que controla toda a logica de execucao - Agendador
									//PRIMEIROS DADOS DO HD TEM QUE SER DO AGENDADOR
//Registrador para posicionar esse programa na memoria principal - $fp
//Registrador track - $s0
//Registrador sector - $s1
//Registrador address_in_sector - $s2
//Registrador para acesso no disco - $v0
//Registrador de contagem do tamanho do programa - $s3
//$t0 - Registrador usado para leitura e extracao de informacoes no disco
//$t1 - 256 - Usado para achar os proximos valores de Track e Sector
//$t2 - 127 - Maximo que um setor suporta no HD
//$t3 - EOF
//$s8 - $ra
MOV $ra $s8
MOV $zero $s0
MOV $zero $s1
MOV $zero $s3
LI $s2 1
LI $t3 -1
LI $t1 256
LI $t2 127

BL .concat_disk_access
IN $t0 $v0 128
STORE $zero $t0 0
ADDI $s2 $s2 1

.load_system_main_program_loop
	.load_system_main_loop_sector
		BL .concat_disk_access
		IN $t0 $v0 128
		BEQ $t0 $t3 .load_system_main_program_loop_out
		BNE $s2 $t2 .load_system_main_program_loop_sector_continue
		
		DIV $t0 $t1
		MFHI $s1
		MFLO $t0
		DIV $t0 $t1
		MFHI $s0
		MOV $zero $s2
		
		B .load_system_main_program_loop
		
		.load_system_main_program_loop_sector_continue
		STORE $s3 $t0 2
		ADDI $s3 $s3 1
		ADDI $s2 $s2 1
		B .load_system_main_loop_sector
.load_system_main_program_loop_out
STORE $zero $s3 1
OUT $s3 $zero 0
BR $s8

.main
LI $k0 100
OUT $k0 $zero 0
BL .load_system_main_program
LOAD $zero $t0 0
SETQUANTUM $t0
LI $k0 2								//AGENDADOR DE PROCESSOS
LOAD $zero $k1 1
MOV $zero $fp
BL .load_program
SETPC $zero
BIOSINT
.work_loop
									//UM PROGRAMA FOI INTERROMPIDO
	LI $k0 2							//PARA CARREGAR O AGENDADOR DE PROGRAMAS
	LOAD $zero $k1 1
	MOV $zero $fp
	B .after_interrupt
	.work_loop_after_interrupt_program					
	BIOSINT								//DEIXAR O ESCALONADOR EXECUTAR
									//$k0 e $k1 estaram com os valores certos
	B .after_interrupt
	.work_loop_after_interrupt_system
	BIOSINT
	B .work_loop
