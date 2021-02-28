//Essa funcao deixara prontos os registradores usados pela BIOS para deixar o processo selecionado pelo agendador em execucao
//selectprocesstorun(k0, k1, re)
.selectprocesstorun
LOAD $k0 $sa 3
OUT $k0 $zero 0
LOAD $k1 $sa 2
OUT $k1 $zero 0
LOAD $re $sa 1
OUT $re $zero 0
ADDI $sa $sa 3
BR $ra