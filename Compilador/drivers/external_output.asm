//A principio essa output levara na saida no dispositivo 0
//output(val)
.output
ADDI $sa $sa 1
LOAD $t1 $sa 0
OUT $t1 $zero 0
BR $ra