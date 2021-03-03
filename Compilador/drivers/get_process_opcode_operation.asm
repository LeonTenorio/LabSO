//
//.getprocessopcodeoperation(k0, re)
.getprocessopcodeoperation
LOAD $s0 $sa 2
LOAD $s1 $sa 1
ADDI $sa $sa 2
ADDI $t0 $s1 27
LOAD $t0 $t0 0
ADD $t0 $t0 $s0
LOAD $v0 $t0 0
SR $v0 24 $v0
BR $ra