
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
	["0100", "0000", ".main"],
	".after_interrupt",
	["0100", "0100", get_register("k0"), get_register("zero"), ".after_interrupt_safe_reg"],
	["0100", "0000", ".store_registers"],
	".after_interrupt_safe_reg",
	["0100", "0001", ".load_program"],
	["0100", "0011", get_register("k0"), get_register("zero"), ".after_interrupt_load_reg"],
	["0100", "0000", ".load_registers"],
	".after_interrupt_load_reg",
	["0100", "0011", get_register("k0"), get_register("zero"), ".work_loop_after_interrupt_program"],
	["0100", "0000", ".work_loop_after_interrupt_system"],
	".store_registers",
	["0101", 4, get_register("re"), get_register("s0"), 5, "000000000"],
	["0101", 4, get_register("re"), get_register("s1"), 5, "000000001"],
	["0101", 4, get_register("re"), get_register("s2"), 5, "000000010"],
	["0101", 4, get_register("re"), get_register("s3"), 5, "000000011"],
	["0101", 4, get_register("re"), get_register("s4"), 5, "000000100"],
	["0101", 4, get_register("re"), get_register("s5"), 5, "000000101"],
	["0101", 4, get_register("re"), get_register("s6"), 5, "000000110"],
	["0101", 4, get_register("re"), get_register("s7"), 5, "000000111"],
	["0101", 4, get_register("re"), get_register("s8"), 5, "000001000"],
	["0101", 4, get_register("re"), get_register("s9"), 5, "000001001"],
	["0101", 4, get_register("re"), get_register("t0"), 5, "000001010"],
	["0101", 4, get_register("re"), get_register("t1"), 5, "000001011"],
	["0101", 4, get_register("re"), get_register("t2"), 5, "000001100"],
	["0101", 4, get_register("re"), get_register("t3"), 5, "000001101"],
	["0101", 4, get_register("re"), get_register("t4"), 5, "000001110"],
	["0101", 4, get_register("re"), get_register("t5"), 5, "000001111"],
	["0101", 4, get_register("re"), get_register("t6"), 5, "000010000"],
	["0101", 4, get_register("re"), get_register("t7"), 5, "000010001"],
	["0101", 4, get_register("re"), get_register("t8"), 5, "000010010"],
	["0101", 4, get_register("re"), get_register("t9"), 5, "000010011"],
	["0101", 4, get_register("re"), get_register("t10"), 5, "000010100"],
	["0101", 4, get_register("re"), get_register("t11"), 5, "000010101"],
	["0101", 4, get_register("re"), get_register("v0"), 5, "000010110"],
	["0101", 4, get_register("re"), get_register("sp"), 5, "000010111"],
	["0101", 4, get_register("re"), get_register("gp"), 5, "000011000"],
	["0101", 4, get_register("re"), get_register("sa"), 5, "000011001"],
	["0101", 4, get_register("re"), get_register("ra"), 5, "000011010"],
	["0000", "0010", 10, get_register("t0"), 9],
	["0101", 4, get_register("re"), get_register("t0"), 5, "000011011"],
	["1000", "0001", 10, get_register("t0"), 9],
	["0101", 4, get_register("re"), get_register("t0"), 5, "000011100"],
	["1000", "0010", 10, get_register("t0"), 9],
	["0101", 4, get_register("re"), get_register("t0"), 5, "000011101"],
	["0100", "0000", ".after_interrupt_safe_reg"],
	".load_registers",
	["0110", 4, get_register("re"), 5, get_register("t0"), "000011011"],
	["0000", "0011", get_register("t0"), 10, 9],
	["0110", 4, get_register("re"), 5, get_register("t0"), "000011100"],
	["1000", "0011", get_register("t0"), 10, 9],
	["0110", 4, get_register("re"), 5, get_register("t0"), "000011101"],
	["1000", "0100", get_register("t0"), 10, 9],
	["0110", 4, get_register("re"), 5, get_register("s0"), "000000000"],
	["0110", 4, get_register("re"), 5, get_register("s1"), "000000001"],
	["0110", 4, get_register("re"), 5, get_register("s2"), "000000010"],
	["0110", 4, get_register("re"), 5, get_register("s3"), "000000011"],
	["0110", 4, get_register("re"), 5, get_register("s4"), "000000100"],
	["0110", 4, get_register("re"), 5, get_register("s5"), "000000101"],
	["0110", 4, get_register("re"), 5, get_register("s6"), "000000110"],
	["0110", 4, get_register("re"), 5, get_register("s7"), "000000111"],
	["0110", 4, get_register("re"), 5, get_register("s8"), "000001000"],
	["0110", 4, get_register("re"), 5, get_register("s9"), "000001001"],
	["0110", 4, get_register("re"), 5, get_register("t0"), "000001010"],
	["0110", 4, get_register("re"), 5, get_register("t1"), "000001011"],
	["0110", 4, get_register("re"), 5, get_register("t2"), "000001100"],
	["0110", 4, get_register("re"), 5, get_register("t3"), "000001101"],
	["0110", 4, get_register("re"), 5, get_register("t4"), "000001110"],
	["0110", 4, get_register("re"), 5, get_register("t5"), "000001111"],
	["0110", 4, get_register("re"), 5, get_register("t6"), "000010000"],
	["0110", 4, get_register("re"), 5, get_register("t7"), "000010001"],
	["0110", 4, get_register("re"), 5, get_register("t8"), "000010010"],
	["0110", 4, get_register("re"), 5, get_register("t9"), "000010011"],
	["0110", 4, get_register("re"), 5, get_register("t10"), "000010100"],
	["0110", 4, get_register("re"), 5, get_register("t11"), "000010101"],
	["0110", 4, get_register("re"), 5, get_register("v0"), "000010110"],
	["0110", 4, get_register("re"), 5, get_register("sp"), "000010111"],
	["0110", 4, get_register("re"), 5, get_register("gp"), "000011000"],
	["0110", 4, get_register("re"), 5, get_register("sa"), "000011001"],
	["0110", 4, get_register("re"), 5, get_register("ra"), "000011010"],
	["0100", "0000", ".after_interrupt_load_reg"],
	".load_program",
	["1000", "0000", get_register("zero"), 5, get_register("t0"), 9],
	["1000", "0000", get_register("k0"), 5, get_register("t1"), 9],
	".load_program_loop",
	["0100", "1000", get_register("t0"), get_register("k1"), ".load_program_done"],
	["0110", 4, get_register("t1"), 5, get_register("t2"), 9],
	["0101", "0001", get_register("t0"), get_register("t2"), 5, 9],
	["0001", "0101", get_register("t0"), get_register("t0"), "00000000000001"],
	["0001", "0101", get_register("t1"), get_register("t1"), "00000000000001"],
	["0100", "0000", ".load_program_loop"],
	".load_program_done",
	["0100", "0010", get_register("ra"), 19],
	".concat_disk_access",
	["1000", "0000", get_register("s0"), 5, get_register("v0"), 9],
	["0001", "1000", get_register("v0"), "01000", get_register("v0"), 9],
	["0001", "0100", get_register("v0"), get_register("v0"), get_register("s1"), 9],
	["0001", "1000", get_register("v0"), "01000", get_register("v0"), 9],
	["0001", "0100", get_register("v0"), get_register("v0"), get_register("s2"), 9],
	["0100", "0010", get_register("ra"), 19],
	".load_system_main_program",
	["1000", "0000", get_register("ra"), 5, get_register("s8"), 9],
	["1000", "0000", get_register("zero"), 5, get_register("s0"), 9],
	["1000", "0000", get_register("zero"), 5, get_register("s1"), 9],
	["1000", "0000", get_register("zero"), 5, get_register("s3"), 9],
	["0111", get_register("s2"), "00000000000000000000001"],
	["0111", get_register("t3"), "11111111111111111111111"],
	["0111", get_register("t1"), "00000000000000100000000"],
	["0111", get_register("t2"), "00000000000000001111111"],
	".load_system_main_program_loop",
	".load_system_main_loop_sector",
	["0100", "0001", ".concat_disk_access"],
	["1001", 4, get_register("t0"), get_register("v0"), 5, "010000000"],
	["0100", "0011", get_register("t0"), get_register("t3"), ".load_system_main_program_loop_out"],
	["0100", "0100", get_register("s2"), get_register("t2"), ".load_system_main_program_loop_sector_continue"],
	["0011", 4, get_register("t0"), get_register("t1"), 5, 9],
	["1000", "0001", 10, get_register("s1"), 9],
	["1000", "0010", 10, get_register("t0"), 9],
	["0011", 4, get_register("t0"), get_register("t1"), 5, 9],
	["1000", "0001", 10, get_register("s0"), 9],
	["1000", "0000", get_register("zero"), 5, get_register("s2"), 9],
	["0100", "0000", ".load_system_main_program_loop"],
	".load_system_main_program_loop_sector_continue",
	["0101", 4, get_register("s3"), get_register("t0"), 5, "000000001"],
	["0001", "0101", get_register("s3"), get_register("s3"), "00000000000001"],
	["0001", "0101", get_register("s2"), get_register("s2"), "00000000000001"],
	["0100", "0000", ".load_system_main_loop_sector"],
	".load_system_main_program_loop_out",
	["0101", 4, get_register("zero"), get_register("s3"), 5, 9],
	#for see informations in simulation
	["1010", 4, get_register("s3"), 5, 5, 9],
	#
	["0100", "0010", get_register("s8"), 10, 9],
	".main",
	#for see informations in simulation
	["0111", get_register("k0"), "00000000000000001100100"],
	["1010", 4, get_register("k0"), 5, 5, 9],
	#
	["0100", "0001", ".load_system_main_program"],
	["1000", "0000", get_register("zero"), 5, get_register("k0"), 9],
	["0110", 4, get_register("zero"), 5, get_register("k1"), 9],
	["0100", "0001", ".load_program"],
	["0000", "0011", get_register("zero"), 10, 9],
	["1011", "0101", 24],
	".work_loop",
	["1000", "0000", get_register("zero"), 5, get_register("k0"), 9],
	["0110", 4, get_register("zero"), 5, get_register("k1"), 9],
	["0100", "0000", ".after_interrupt"],
	".work_loop_after_interrupt_program",
	["1011", "0101", 24],
	["0100", "0000", ".after_interrupt"],
	".work_loop_after_interrupt_system",
	["1011", "0101", 24],
	["0100", "0000", ".work_loop"]
]

#first program in hd
'''
assembly_lines = [
	["1", "0", "0", "0", "000000000000", "00000001", ".done"],
	["0100", "0000", ".main"],
	".main",
	#for see informations in simulation
	["0111", get_register("k0"), "00000000000000001100101"],
	["1010", 4, get_register("k0"), 5, 5, 9],
	#
	["1000", "0000", get_register("zero"), 5, get_register("k0"), 9],
	["0111", get_register("k1"), ".done"],
	["0000", "0001", 24],
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

