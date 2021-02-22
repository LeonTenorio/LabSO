
def convert_to_inst(number, params):
	ret = ""
	for param in params:
		param_str = ""
		if(isinstance(param, str)):
			if("'" not in param):
				param_str = str(len(param))+"'b"+param
			else:
				param_str = param
		else:
			param_str = str(param)+"'b" +("0"*param)
		if(len(ret)==0):
			ret = param_str
		else:
			ret = ret + ", " + param_str
	return "registers["+str(number)+"] = {" + ret+ "};"
	
def get_register(fonte):
	if(fonte=="zero"):
		return "00000"
	elif(fonte=="re"):
		return "00001"
	elif(fonte=="s0"):
   		return "00010"
	elif(fonte=="s1"):
		return "00011"
	elif(fonte=="s2"):
		return "00100"
	elif(fonte=="s3"):
		return "00101"
	elif(fonte=="s4"):
		return "00110"
	elif(fonte=="s5"):
		return "00111"
	elif(fonte=="s6"):
		return "01000"
	elif(fonte=="s7"):
		return "01001"
	elif(fonte=="s8"):
		return "01010"
	elif(fonte=="s9"):
		return "01011"
	elif(fonte=="t0"):
		return "01100"
	elif(fonte=="t1"):
		return "01101"
	elif(fonte=="t2"):
		return "01110"
	elif(fonte=="t3"):
		return "01111"
	elif(fonte=="t4"):
		return "10000"
	elif(fonte=="t5"):
		return "10001"
	elif(fonte=="t6"):
		return "10010"
	elif(fonte=="t7"):
		return "10011"
	elif(fonte=="t8"):
		return "10100"
	elif(fonte=="t9"):
		return "10101"
	elif(fonte=="t10"):
		return "10110"
	elif(fonte=="t11"):
		return "10111"
	elif(fonte=="v0"):
		return "11000"
	elif(fonte=="sp"):
		return "11001"
	elif(fonte=="gp"):
		return "11010"
	elif(fonte=="sa"):
		return "11011"
	elif(fonte=="k0"):
		return "11100"
	elif(fonte=="k1"):
		return "11101"
	elif(fonte=="fp"):
		return "11110"
	elif(fonte=="ra"):
		return "11111"
	
def get_line_label(line, label_number):
	line_bits = 0
	for i in range(0, len(line)-1):
		line_bits = line_bits + len(line[i])
	return str(32-line_bits)+"'d"+str(label_number)

def check_bin_bits(line_string, line_number):
	fields = line_string[:-1].split("{")[1]
	fields = fields.split(", ")
	bits = 0
	for field in fields:
		bits = bits + int(field.split("'")[0])
	if(bits!=32):
		raise Exception("ERROR BITS "+str(line_number))

#bios program
assembly_lines = [
	["0100", "0000", ".main"],#B .main
	".after_interrupt",
	["0100", "0100", get_register("fp"), get_register("zero"), ".after_interrupt_safe_reg"],#BNE $fp $zero .after_interrupt_safe_reg
	["0100", "0000", ".store_registers"],#B .store_registers
	".after_interrupt_safe_reg",
	["0100", "0001", ".load_program"],#BL .load_program
	["0100", "0011", get_register("fp"), get_register("zero"), ".after_interrupt_load_reg"],#BEQ $fp $zero .after_interrupt_load_reg
	["0100", "0000", ".load_registers"],#B .load_registers
	".after_interrupt_load_reg",
	["0100", "0011", get_register("fp"), get_register("zero"), ".work_loop_after_interrupt_program"],#BEQ $zero $fp .work_loop_after_interrupt_program
	["0100", "0000", ".work_loop_after_interrupt_system"],#B .work_loop_after_interrupt_system
	".store_registers",
	["0101", 4, get_register("re"), get_register("s0"), 5, "000000000"],#STORE $re $s0 0
	["0101", 4, get_register("re"), get_register("s1"), 5, "000000001"],#STORE $re $s1 1
	["0101", 4, get_register("re"), get_register("s2"), 5, "000000010"],#STORE $re $s2 2
	["0101", 4, get_register("re"), get_register("s3"), 5, "000000011"],#STORE $re $s3 3
	["0101", 4, get_register("re"), get_register("s4"), 5, "000000100"],#STORE $re $s4 4
	["0101", 4, get_register("re"), get_register("s5"), 5, "000000101"],#STORE $re $s5 5
	["0101", 4, get_register("re"), get_register("s6"), 5, "000000110"],#STORE $re $s6 6
	["0101", 4, get_register("re"), get_register("s7"), 5, "000000111"],#STORE $re $s7 7
	["0101", 4, get_register("re"), get_register("s8"), 5, "000001000"],#STORE $re $s8 8
	["0101", 4, get_register("re"), get_register("s9"), 5, "000001001"],#STORE $re $s9 9
	["0101", 4, get_register("re"), get_register("t0"), 5, "000001010"],#STORE $re $t0 10
	["0101", 4, get_register("re"), get_register("t1"), 5, "000001011"],#STORE $re $t1 11
	["0101", 4, get_register("re"), get_register("t2"), 5, "000001100"],#STORE $re $t2 12
	["0101", 4, get_register("re"), get_register("t3"), 5, "000001101"],#STORE $re $t3 13
	["0101", 4, get_register("re"), get_register("t4"), 5, "000001110"],#STORE $re $t4 14
	["0101", 4, get_register("re"), get_register("t5"), 5, "000001111"],#STORE $re $t5 15
	["0101", 4, get_register("re"), get_register("t6"), 5, "000010000"],#STORE $re $t6 16
	["0101", 4, get_register("re"), get_register("t7"), 5, "000010001"],#STORE $re $t7 17
	["0101", 4, get_register("re"), get_register("t8"), 5, "000010010"],#STORE $re $t8 18
	["0101", 4, get_register("re"), get_register("t9"), 5, "000010011"],#STORE $re $t9 19
	["0101", 4, get_register("re"), get_register("t10"), 5, "000010100"],#STORE $re $t10 20
	["0101", 4, get_register("re"), get_register("t11"), 5, "000010101"],#STORE $re $t11 21
	["0101", 4, get_register("re"), get_register("v0"), 5, "000010110"],#STORE $re $v0 22
	["0101", 4, get_register("re"), get_register("sp"), 5, "000010111"],#STORE $re $sp 23
	["0101", 4, get_register("re"), get_register("gp"), 5, "000011000"],#STORE $re $gp 24
	["0101", 4, get_register("re"), get_register("sa"), 5, "000011001"],#STORE $re $sa 25
	["0101", 4, get_register("re"), get_register("ra"), 5, "000011010"],#STORE $re $ra 26
	["0000", "0010", 10, get_register("t0"), 9],#GETPC $t0
	["0101", 4, get_register("re"), get_register("t0"), 5, "000011011"],#STORE $re $t0 27
	["1000", "0001", 10, get_register("t0"), 9],#MFHI $t0
	["0101", 4, get_register("re"), get_register("t0"), 5, "000011100"],#STORE $re $t0 28
	["1000", "0010", 10, get_register("t0"), 9],#MFLO $t0
	["0101", 4, get_register("re"), get_register("t0"), 5, "000011101"],#STORE $re $t0 29
	["0101", 4, get_register("re"), get_register("fp"), 5, "000011110"],#STORE $re $fp 30
	["0100", "0000", ".after_interrupt_safe_reg"],#B .after_interrupt_safe_reg
	".load_registers",
	["0110", 4, get_register("re"), 5, get_register("fp"), "000011101"],#LOAD $re $fp 30
	["0110", 4, get_register("re"), 5, get_register("t0"), "000011011"],#LOAD $re $t0 27
	["0000", "0011", get_register("t0"), 10, 9],#SETPC $t0
	["0110", 4, get_register("re"), 5, get_register("t0"), "000011100"],#LOAD $re $t0 28
	["1000", "0011", get_register("t0"), 10, 9],#SETHI $t0
	["0110", 4, get_register("re"), 5, get_register("t0"), "000011101"],#LOAD $re $t0 29
	["1000", "0100", get_register("t0"), 10, 9],#SETLO $t0
	["0110", 4, get_register("re"), 5, get_register("s0"), "000000000"],#LOAD $re $s0 0
	["0110", 4, get_register("re"), 5, get_register("s1"), "000000001"],#LOAD $re $s1 1
	["0110", 4, get_register("re"), 5, get_register("s2"), "000000010"],#LOAD $re $s2 2
	["0110", 4, get_register("re"), 5, get_register("s3"), "000000011"],#LOAD $re $s3 3
	["0110", 4, get_register("re"), 5, get_register("s4"), "000000100"],#LOAD $re $s4 4
	["0110", 4, get_register("re"), 5, get_register("s5"), "000000101"],#LOAD $re $s5 5
	["0110", 4, get_register("re"), 5, get_register("s6"), "000000110"],#LOAD $re $s6 6
	["0110", 4, get_register("re"), 5, get_register("s7"), "000000111"],#LOAD $re $s7 7
	["0110", 4, get_register("re"), 5, get_register("s8"), "000001000"],#LOAD $re $s8 8
	["0110", 4, get_register("re"), 5, get_register("s9"), "000001001"],#LOAD $re $s9 9
	["0110", 4, get_register("re"), 5, get_register("t0"), "000001010"],#LOAD $re $t0 10
	["0110", 4, get_register("re"), 5, get_register("t1"), "000001011"],#LOAD $re $t1 11
	["0110", 4, get_register("re"), 5, get_register("t2"), "000001100"],#LOAD $re $t2 12
	["0110", 4, get_register("re"), 5, get_register("t3"), "000001101"],#LOAD $re $t3 13
	["0110", 4, get_register("re"), 5, get_register("t4"), "000001110"],#LOAD $re $t4 14
	["0110", 4, get_register("re"), 5, get_register("t5"), "000001111"],#LOAD $re $t5 15
	["0110", 4, get_register("re"), 5, get_register("t6"), "000010000"],#LOAD $re $t6 16
	["0110", 4, get_register("re"), 5, get_register("t7"), "000010001"],#LOAD $re $t7 17
	["0110", 4, get_register("re"), 5, get_register("t8"), "000010010"],#LOAD $re $t8 18
	["0110", 4, get_register("re"), 5, get_register("t9"), "000010011"],#LOAD $re $t9 19
	["0110", 4, get_register("re"), 5, get_register("t10"), "000010100"],#LOAD $re $t10 20
	["0110", 4, get_register("re"), 5, get_register("t11"), "000010101"],#LOAD $re $t11 21
	["0110", 4, get_register("re"), 5, get_register("v0"), "000010110"],#LOAD $re $v0 22
	["0110", 4, get_register("re"), 5, get_register("sp"), "000010111"],#LOAD $re $sp 23
	["0110", 4, get_register("re"), 5, get_register("gp"), "000011000"],#LOAD $re $gp 24
	["0110", 4, get_register("re"), 5, get_register("sa"), "000011001"],#LOAD $re $sa 25
	["0110", 4, get_register("re"), 5, get_register("ra"), "000011010"],#LOAD $re $ra 26
	["0100", "0000", ".after_interrupt_load_reg"],#B .after_interrupt_load_reg
	".load_program",
	["1000", "0000", get_register("zero"), 5, get_register("t0"), 9],#MOV $zero $t0
	["1000", "0000", get_register("k0"), 5, get_register("t1"), 9],#MOV $k0 $t1
	".load_program_loop",
		["0100", "1000", get_register("t0"), get_register("k1"), ".load_program_done"],#BGE $t0 $k1 .load_program_done
			["0110", 4, get_register("t1"), 5, get_register("t2"), 9],#LOAD $t1 $t2 0
			["0101", "0001", get_register("t0"), get_register("t2"), 5, 9],#STOREINST $t0 $t2 0
			["0001", "0101", get_register("t0"), get_register("t0"), "00000000000001"],#ADDI $t0 $t0 1
			["0001", "0101", get_register("t1"), get_register("t1"), "00000000000001"],#ADDI $t1 $t1 1
			["0100", "0000", ".load_program_loop"],#B .load_program_loop
	".load_program_done",
	["0100", "0010", get_register("ra"), 19],#BR $ra
	".concat_disk_access",
	["1000", "0000", get_register("s0"), 5, get_register("v0"), 9],#MOV $s0 $v0
	["0001", "1000", get_register("v0"), "01000", get_register("v0"), 9],#SL $v0 8 $v0
	["0001", "0100", get_register("v0"), get_register("s1"), get_register("v0"), 9],#ADD $v0 $v0 $s1
	["0001", "1000", get_register("v0"), "01000", get_register("v0"), 9],#SL $v0 8 $v0
	["0001", "0100", get_register("v0"), get_register("s2"), get_register("v0"), 9],#ADD $v0 $v0 $s2
	["0100", "0010", get_register("ra"), 19],#BR $ra
	".load_system_main_program",
	["1000", "0000", get_register("ra"), 5, get_register("s8"), 9],#MOV $ra $s8
	["1000", "0000", get_register("zero"), 5, get_register("s0"), 9],#MOV $zero $s0
	["1000", "0000", get_register("zero"), 5, get_register("s1"), 9],#MOV $zero $s1
	["1000", "0000", get_register("zero"), 5, get_register("s3"), 9],#MOV $zero $s3
	["0111", get_register("s2"), "00000000000000000000001"],#LI $s2 1
	["0111", get_register("t3"), "11111111111111111111111"],#LI $t3 -1
	["0111", get_register("t1"), "00000000000000100000000"],#LI $t1 256
	["0111", get_register("t2"), "00000000000000001111111"],#LI $t2 127
	
	["0100", "0001", ".concat_disk_access"],#BL .concat_disk_access
	["1001", 4, get_register("t0"), get_register("v0"), 5, "010000000"],#IN $t0 $v0 128
	["0101", 4, get_register("zero"), get_register("t0"), 5, 9],#STORE $zero $t0 0
	["0001", "0101", get_register("s2"), get_register("s2"), "00000000000001"],#ADDI $s2 $s2 1

	".load_system_main_program_loop",
		".load_system_main_loop_sector",
			["0100", "0001", ".concat_disk_access"],#BL .concat_disk_access
			["1001", 4, get_register("t0"), get_register("v0"), 5, "010000000"],#IN $t0 $v0 128
			["0100", "0011", get_register("t0"), get_register("t3"), ".load_system_main_program_loop_out"],#BEQ $t0 $t3 .load_system_main_program_loop_out
			["0100", "0100", get_register("s2"), get_register("t2"), ".load_system_main_program_loop_sector_continue"],#BNE $s2 $t2 .load_system_main_program_loop_sector_continue
			["0011", 4, get_register("t0"), get_register("t1"), 5, 9],#DIV $t0 $t1
			["1000", "0001", 10, get_register("s1"), 9],#MFHI $s1
			["1000", "0010", 10, get_register("t0"), 9],#MFLO $t0
			["0011", 4, get_register("t0"), get_register("t1"), 5, 9],#DIV $t0 $t1
			["1000", "0001", 10, get_register("s0"), 9],#MFHI $s0
			["1000", "0000", get_register("zero"), 5, get_register("s2"), 9],#MOV $zero $s2
			["0100", "0000", ".load_system_main_program_loop"],#B .load_system_main_program_loop
			".load_system_main_program_loop_sector_continue",
			["0101", 4, get_register("s3"), get_register("t0"), 5, "000000010"],#STORE $s3 $t0 2
			["0001", "0101", get_register("s3"), get_register("s3"), "00000000000001"],#ADDI $s3 $s3 1
			["0001", "0101", get_register("s2"), get_register("s2"), "00000000000001"],#ADDI $s2 $s2 1
			["0100", "0000", ".load_system_main_loop_sector"],#B .load_system_main_loop_sector
	".load_system_main_program_loop_out",
	["0101", 4, get_register("zero"), get_register("s3"), 5, "000000001"],#STORE $zero $s3 1
	#for see informations in simulation
	["1010", 4, get_register("s3"), 5, 5, 9],#OUT $s3 $zero 0
	#
	["0100", "0010", get_register("s8"), 10, 9],#BR $s8
	".main",
	#for see informations in simulation
	["0111", get_register("k0"), "00000000000000001100100"],#LI $k0 100
	["1010", 4, get_register("k0"), 5, 5, 9],#OUT $k0 $zero 0
	#
	["0100", "0001", ".load_system_main_program"],#BL .load_system_main_program
	["0110", 4, get_register("zero"), 5, get_register("t0"), 9],#LOAD $zero $t0 0
	["1011", "0100", get_register("t0"), 10, 9],#SETQUANTUM $t0
	["0111", get_register("k0"), "00000000000000000000010"],#LI $k0 2
	["0110", 4, get_register("zero"), 5, get_register("k1"), "000000001"],#LOAD $zero $k1 1
	["1000", "0000", get_register("zero"), 5, get_register("fp"), 9],#MOV $zero $fp
	["0100", "0001", ".load_program"],#BL .load_program
	["0000", "0011", get_register("zero"), 10, 9],#SETPC $zero
	["1011", "0101", 24],#BIOSINT
	".work_loop",
		["0111", get_register("k0"), "00000000000000000000010"],#LI $k0 2
		["0110", 4, get_register("zero"), 5, get_register("k1"), "000000001"],#LOAD $zero $k1 1
		["1000", "0000", get_register("zero"), 5, get_register("fp"), 9],#MOV $zero $fp
		["0100", "0000", ".after_interrupt"],#B .after_interrupt
		".work_loop_after_interrupt_program",
		["1011", "0101", 24],#BIOSINT
		["0100", "0000", ".after_interrupt"],#B .after_interrupt
		".work_loop_after_interrupt_system",
		["1011", "0101", 24],#BIOSINT
		["0100", "0000", ".work_loop"]#B .work_loop
]

#first program in hd
'''
assembly_lines = [
	["1", "0", "0", "0", "000000000000", "00000001", ".done"],
	["32'd300"],
	#for see informations in simulation
	["0111", get_register("k0"), "00000000000000001100101"],
	["1010", 4, get_register("k0"), 5, 5, 9],
	#
	["1000", "0000", get_register("zero"), 5, get_register("k0"), 9],
	["0111", get_register("k1"), ".done"],
	["0000", "0001", 24],
	['1'*32],
	".done"
]
'''

dict_labels = {}

line = 0
for assembly in assembly_lines:
	if(isinstance(assembly, list)):
		line = line + 1
	else:
		dict_labels[assembly] = line

lines_params = []
for assembly in assembly_lines:
	if(isinstance(assembly, list)):
		if(isinstance(assembly[-1], str) and "." in assembly[-1]):
			assembly[len(assembly)-1] = get_line_label(assembly, dict_labels[assembly[-1]])
	lines_params.append(assembly)

quartus_binnary = ""
line = 0
for line_params in lines_params:
	if(isinstance(line_params, list)):
		line_string = convert_to_inst(line, line_params)
		check_bin_bits(line_string, line)
		quartus_binnary = quartus_binnary + line_string + "\n"
		line = line + 1
	else:
		quartus_binnary = quartus_binnary + "//" +line_params+ "\n"

print(quartus_binnary)

