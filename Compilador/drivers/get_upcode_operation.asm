//Essa funcao vai pegar um dado de 32 bits e desloca-lo a direita para isolar os 8 bits de opcode_operation
//getupcodeoperation(instruction)
.getupcodeoperation
LOAD $v0 $sa 1
ADDI $sa $sa 1
SR $v0 24 $v0
BR $ra