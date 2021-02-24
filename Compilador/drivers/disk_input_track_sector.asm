//Esse driver vai dividir um registrador que tem track, sector em dois registradores para acesso a um arquivo. Vai receber como parametros um valor e um vetor para jogar o retorno
//inputdisktracksector(val, buffer)
.inputdisktracksector
LOAD $t0 $sa 2
LOAD $t1 $sa 1
ADDI $sa $sa 2
LI $t2 256
DIV $t0 $t2
MFHI $t3
STORE $t1 $t3 1
MFLO $t0
DIV $t0 $t2
MFHI $t3
STORE $t1 $t3 0
BR $ra