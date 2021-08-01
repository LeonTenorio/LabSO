//Esse driver vai implementar a espera ociosa do processador ate que um determinado tempo em milliseconds tenha se passado
//sleep(ms)
.sleep
LOAD $t0 $sa 1
ADDI $sa $sa 1
GETTIME $t1
.sleep_loop
GETTIME $t2
SUB $t2 $t2 $t1
BGE $t2 $t0 .sleep_out
B .sleep_loop
.sleep_out
BR $ra