//Esse driver vai dividir um registrador que tem track, sector em dois registradores para acesso a um arquivo
.inputdisktracksector
ADDI $sa $sa 1
LOAD $t0 $sa 0
LI $t1 256
DIV $t0 $t1
MFHI $t3
STORE $t0 $t3 1
MFLO $t0
DIV $t0 $t1
MFHI $t3
STORE $t0 $t3 0
BR $ra