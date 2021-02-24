//Esse driver vai inserir os elementos na tabela de simbolos recebida como primeiro argumento
//insertinprocesstab(processtab, process_index, process_id, process_state, inst_adr, inst_amt, reg_adr, begin_mem, end_mem)
.insertinprocesstab
LOAD $t0 $sa 9
LOAD $t1 $sa 8
LI $t2 7
MULT $t1 $t2
MFLO $t2
ADDI $t2 $t2 2
ADD $t2 $t2 $t0
LOAD $t3 $sa 7
STORE $t2 $t3 0
LOAD $t3 $sa 6
STORE $t2 $t3 1
LOAD $t3 $sa 5
STORE $t2 $t3 2
LOAD $t3 $sa 4
STORE $t2 $t3 3
LOAD $t3 $sa 3
STORE $t2 $t3 4
LOAD $t3 $sa 2
STORE $t2 $t3 5
LOAD $t3 $sa 1
STORE $t2 $t3 6
ADDI $sa $sa 9
BR $ra