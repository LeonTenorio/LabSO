module bios_module(
input clk,
input done_inst,
input[31:0] pc,
input[31:0] processor_info,
input[0:7] processor_opcode_operation,
output reg[0:31] instruction,
output reg controll,
output reg[31:0] bios_info,
output reg[1:0] state
);

parameter MILLIS_PARAM = 16'd50000;
parameter MAX_VALUE = 33'd4294967296;

parameter INV=2'd0, BIOSEXEC=2'd1, PROCESSEXEC=2'd2, PROCESSINT=2'd3;//Declaracao dos estados da BIOS

//reg[1:0] state = INV;

reg[0:31] registers[255:0];//As instrucoes armazenadas tambem estao em BIG ENDIAN

reg lock_quantum = 0;
reg release_exec = 0;
reg program_done = 0;

reg[31:0] quantum = 32'd0;
reg[31:0] reg_quantum = 32'd0;

reg[31:0] millis_time = 32'd0;
reg[31:0] reg_millis_time = 32'd0;

always @(posedge clk)
begin
	//Carregamento da minha memoria de programa para a BIOS
end

always @(negedge clk)
begin
	instruction = registers[pc];
end

always @(posedge clk)//No meio do clock posso avaliar o que fazer com as instrucoes e dados do processador
begin
	release_exec = 0;
	program_done = 0;
	case(processor_opcode_operation)
		8'b10110001: //LOCK
		begin
			lock_quantum = 1;
		end
		8'b10110010: //RELEASE
		begin	
			lock_quantum = 0;
		end
		8'b10110101: //BIOSINT
		begin
			release_exec = 1;
		end
		8'b10110100: //SETQUANTUM
		begin
			quantum = processor_info;
		end
		8'b10110000: //GETTIME
		begin
			bios_info = millis_time;
		end
		8'b10110011: //GETQUANTUM
		begin
			bios_info = reg_quantum;
		end
		8'b00000001: //HALT
		begin
			program_done = 1;
		end
		default:
		begin
			
		end
	endcase
end

always @(negedge clk)//Troca de estados da BIOS
begin
	case(state)
		INV:
		begin
			state = BIOSEXEC;
		end
		BIOSEXEC:
		begin
			if(release_exec && done_inst)
			begin
				state = PROCESSEXEC;
			end
		end
		PROCESSEXEC:
		begin
			if(program_done)
			begin
				state = PROCESSINT;
			end
			else if(reg_quantum >= quantum)
			begin
				if(lock_quantum==0)
				begin
					state = PROCESSINT;
				end
			end
		end
		PROCESSINT:
		begin
			if(done_inst)
			begin
				state = BIOSEXEC;
			end
		end
	endcase
	
	case(state)
		BIOSEXEC:
		begin
			controll = 1;
		end
		default:
		begin
			controll = 0;
		end
	endcase
end

always @(posedge clk)//Contadores de quantum e tempo de execucao
begin
	if(state==INV)
	begin
		reg_quantum = 32'd0;
		millis_time = 32'd0;
		reg_millis_time = 32'd0;
	end
	else
	begin
		reg_millis_time = reg_millis_time + 32'd1;
		if(reg_millis_time >= MILLIS_PARAM)
		begin
			millis_time = millis_time + 32'd1;
			reg_millis_time = 32'd0;
		end
		
		case(state)
			BIOSEXEC:
			begin
				reg_quantum = 32'd0;
			end
			PROCESSEXEC:
			begin
				if(reg_quantum < MAX_VALUE)
				begin
					reg_quantum = reg_quantum + 32'd1;
				end
			end
			PROCESSINT:
			begin
				if(reg_quantum < MAX_VALUE)
				begin
					reg_quantum = reg_quantum + 32'd1;
				end
			end
			default:
			begin
				reg_quantum = 32'd0;
			end
		endcase
	end
end

always @(posedge clk)
begin
/*Segunda versao de BIOS*/
registers[0] = {32'b01000000000000000000000001101010};
registers[1] = {32'b1010XXXX1111000000XXXX0000000000};
registers[2] = {32'b01000100111100000000000000010010};
registers[3] = {32'b01000001000000000000000000000111};
registers[4] = {32'b01000011111100000000000000110101};
registers[5] = {32'b01000011111100000000000001110100};
registers[6] = {32'b01000000000000000000000001111000};
registers[7] = {32'b1010XXXX1110000000XXXX0000000000};
registers[8] = {32'b1010XXXX1110100000XXXX0000000000};
registers[9] = {32'b1000000011100XXXXX00010XXXXXXXXX};
registers[10] = {32'b1000000000000XXXXX00011XXXXXXXXX};
registers[11] = {32'b01000011000111110100000000010001};
registers[12] = {32'b0110XXXX00010XXXXX01100000000000};
registers[13] = {32'b010100010001101100XXXXX000000000};
registers[14] = {32'b00010101000100001000000000000001};
registers[15] = {32'b00010101000110001100000000000001};
registers[16] = {32'b01000000000000000000000000001011};
registers[17] = {32'b0100001011111XXXXXXXXXXXXXXXXXXX};
registers[18] = {32'b010100000000100010XXXXX000000000};
registers[19] = {32'b010100000000100011XXXXX000000001};
registers[20] = {32'b010100000000100100XXXXX000000010};
registers[21] = {32'b010100000000100101XXXXX000000011};
registers[22] = {32'b010100000000100110XXXXX000000100};
registers[23] = {32'b010100000000100111XXXXX000000101};
registers[24] = {32'b010100000000101000XXXXX000000110};
registers[25] = {32'b010100000000101001XXXXX000000111};
registers[26] = {32'b010100000000101010XXXXX000001000};
registers[27] = {32'b010100000000101011XXXXX000001001};
registers[28] = {32'b010100000000101100XXXXX000001010};
registers[29] = {32'b010100000000101101XXXXX000001011};
registers[30] = {32'b010100000000101110XXXXX000001100};
registers[31] = {32'b010100000000101111XXXXX000001101};
registers[32] = {32'b010100000000110000XXXXX000001110};
registers[33] = {32'b010100000000110001XXXXX000001111};
registers[34] = {32'b010100000000110010XXXXX000010000};
registers[35] = {32'b010100000000110011XXXXX000010001};
registers[36] = {32'b010100000000110100XXXXX000010010};
registers[37] = {32'b010100000000110101XXXXX000010011};
registers[38] = {32'b010100000000110110XXXXX000010100};
registers[39] = {32'b010100000000110111XXXXX000010101};
registers[40] = {32'b010100000000111000XXXXX000010110};
registers[41] = {32'b010100000000111001XXXXX000010111};
registers[42] = {32'b010100000000111010XXXXX000011000};
registers[43] = {32'b010100000000111011XXXXX000011001};
registers[44] = {32'b010100000000111111XXXXX000011010};
registers[45] = {32'b00000010XXXXXXXXXXXXXXXXXXXXXXXX};
registers[46] = {32'b010100000000101100XXXXX000011011};
registers[47] = {32'b10000001XXXXXXXXXX01100XXXXXXXXX};
registers[48] = {32'b010100000000101100XXXXX000011100};
registers[49] = {32'b10000010XXXXXXXXXX01100XXXXXXXXX};
registers[50] = {32'b010100000000101100XXXXX000011101};
registers[51] = {32'b010100000000111110XXXXX000011110};
registers[52] = {32'b01000000000000000000000000000011};
registers[53] = {32'b0110XXXX00001XXXXX01100000011011};
registers[54] = {32'b0000001101100XXXXXXXXXXXXXXXXXXX};
registers[55] = {32'b0110XXXX00001XXXXX01100000011100};
registers[56] = {32'b1000001101100XXXXXXXXXXXXXXXXXXX};
registers[57] = {32'b0110XXXX00001XXXXX01100000011101};
registers[58] = {32'b1000010001100XXXXXXXXXXXXXXXXXXX};
registers[59] = {32'b0110XXXX00001XXXXX00010000000000};
registers[60] = {32'b0110XXXX00001XXXXX00011000000001};
registers[61] = {32'b0110XXXX00001XXXXX00100000000010};
registers[62] = {32'b0110XXXX00001XXXXX00101000000011};
registers[63] = {32'b0110XXXX00001XXXXX00110000000100};
registers[64] = {32'b0110XXXX00001XXXXX00111000000101};
registers[65] = {32'b0110XXXX00001XXXXX01000000000110};
registers[66] = {32'b0110XXXX00001XXXXX01001000000111};
registers[67] = {32'b0110XXXX00001XXXXX01010000001000};
registers[68] = {32'b0110XXXX00001XXXXX01011000001001};
registers[69] = {32'b0110XXXX00001XXXXX01100000001010};
registers[70] = {32'b0110XXXX00001XXXXX01101000001011};
registers[71] = {32'b0110XXXX00001XXXXX01110000001100};
registers[72] = {32'b0110XXXX00001XXXXX01111000001101};
registers[73] = {32'b0110XXXX00001XXXXX10000000001110};
registers[74] = {32'b0110XXXX00001XXXXX10001000001111};
registers[75] = {32'b0110XXXX00001XXXXX10010000010000};
registers[76] = {32'b0110XXXX00001XXXXX10011000010001};
registers[77] = {32'b0110XXXX00001XXXXX10100000010010};
registers[78] = {32'b0110XXXX00001XXXXX10101000010011};
registers[79] = {32'b0110XXXX00001XXXXX10110000010100};
registers[80] = {32'b0110XXXX00001XXXXX10111000010101};
registers[81] = {32'b0110XXXX00001XXXXX11000000010110};
registers[82] = {32'b0110XXXX00001XXXXX11001000010111};
registers[83] = {32'b0110XXXX00001XXXXX11010000011000};
registers[84] = {32'b0110XXXX00001XXXXX11011000011001};
registers[85] = {32'b0110XXXX00001XXXXX11111000011010};
registers[86] = {32'b0110XXXX00001XXXXX11110000011110};
registers[87] = {32'b01000000000000000000000000000101};
registers[88] = {32'b1000000011111XXXXX01010XXXXXXXXX};
registers[89] = {32'b01111100000000000000000000000001};
registers[90] = {32'b1000000000000XXXXX00101XXXXXXXXX};
registers[91] = {32'b01110111111111111111111111111111};
registers[92] = {32'b01110110100000000000000100000000};
registers[93] = {32'b1001XXXX0110011000XXXX0010000000};
registers[94] = {32'b010100000000001100XXXXX000000000};
registers[95] = {32'b1010XXXX0110000000XXXX0000000000};
registers[96] = {32'b00010101110001100000000000000001};
registers[97] = {32'b1001XXXX0110011000XXXX0010000000};
registers[98] = {32'b01000011011000111100000001100111};
registers[99] = {32'b010100000010101100XXXXX000000010};
registers[100] = {32'b00010101001010010100000000000001};
registers[101] = {32'b00010101110001100000000000000001};
registers[102] = {32'b01000000000000000000000001100001};
registers[103] = {32'b1010XXXX0010100000XXXX0000000000};
registers[104] = {32'b010100000000000101XXXXX000000001};
registers[105] = {32'b0100001001010XXXXXXXXXXXXXXXXXXX};
registers[106] = {32'b01000001000000000000000001011000};
registers[107] = {32'b0110XXXX00000XXXXX01100000000000};
registers[108] = {32'b1011010001100XXXXXXXXXXXXXXXXXXX};
registers[109] = {32'b01111110000000000000000000000010};
registers[110] = {32'b0110XXXX00000XXXXX11101000000001};
registers[111] = {32'b1000000000000XXXXX11110XXXXXXXXX};
registers[112] = {32'b01000001000000000000000000000111};
registers[113] = {32'b0000001100000XXXXXXXXXXXXXXXXXXX};
registers[114] = {32'b10110101XXXXXXXXXXXXXXXXXXXXXXXX};
registers[115] = {32'b01000000000000000000000000000001};
registers[116] = {32'b10110101XXXXXXXXXXXXXXXXXXXXXXXX};
registers[117] = {32'b01111110000000000000000000000010};
registers[118] = {32'b0110XXXX00000XXXXX11101000000001};
registers[119] = {32'b01000000000000000000000000000001};
registers[120] = {32'b0000001100000XXXXXXXXXXXXXXXXXXX};
registers[121] = {32'b10110101XXXXXXXXXXXXXXXXXXXXXXXX};
registers[122] = {32'b01000000000000000000000001110011};
/* Primeira versao de BIOS
registers[0] = {4'b0100, 4'b0000, 24'd121};
//.after_interrupt
registers[1] = {4'b0100, 4'b0100, 5'b11110, 5'b00000, 14'd3};
registers[2] = {4'b0100, 4'b0000, 24'd8};
//.after_interrupt_safe_reg
registers[3] = {4'b0100, 4'b0001, 24'd76};
registers[4] = {4'b0100, 4'b0011, 5'b11110, 5'b00000, 14'd6};
registers[5] = {4'b0100, 4'b0000, 24'd42};
//.after_interrupt_load_reg
registers[6] = {4'b0100, 4'b0011, 5'b11110, 5'b00000, 14'd136};
registers[7] = {4'b0100, 4'b0000, 24'd138};
//.store_registers
registers[8] = {4'b0101, 4'b0000, 5'b00001, 5'b00010, 5'b00000, 9'b000000000};
registers[9] = {4'b0101, 4'b0000, 5'b00001, 5'b00011, 5'b00000, 9'b000000001};
registers[10] = {4'b0101, 4'b0000, 5'b00001, 5'b00100, 5'b00000, 9'b000000010};
registers[11] = {4'b0101, 4'b0000, 5'b00001, 5'b00101, 5'b00000, 9'b000000011};
registers[12] = {4'b0101, 4'b0000, 5'b00001, 5'b00110, 5'b00000, 9'b000000100};
registers[13] = {4'b0101, 4'b0000, 5'b00001, 5'b00111, 5'b00000, 9'b000000101};
registers[14] = {4'b0101, 4'b0000, 5'b00001, 5'b01000, 5'b00000, 9'b000000110};
registers[15] = {4'b0101, 4'b0000, 5'b00001, 5'b01001, 5'b00000, 9'b000000111};
registers[16] = {4'b0101, 4'b0000, 5'b00001, 5'b01010, 5'b00000, 9'b000001000};
registers[17] = {4'b0101, 4'b0000, 5'b00001, 5'b01011, 5'b00000, 9'b000001001};
registers[18] = {4'b0101, 4'b0000, 5'b00001, 5'b01100, 5'b00000, 9'b000001010};
registers[19] = {4'b0101, 4'b0000, 5'b00001, 5'b01101, 5'b00000, 9'b000001011};
registers[20] = {4'b0101, 4'b0000, 5'b00001, 5'b01110, 5'b00000, 9'b000001100};
registers[21] = {4'b0101, 4'b0000, 5'b00001, 5'b01111, 5'b00000, 9'b000001101};
registers[22] = {4'b0101, 4'b0000, 5'b00001, 5'b10000, 5'b00000, 9'b000001110};
registers[23] = {4'b0101, 4'b0000, 5'b00001, 5'b10001, 5'b00000, 9'b000001111};
registers[24] = {4'b0101, 4'b0000, 5'b00001, 5'b10010, 5'b00000, 9'b000010000};
registers[25] = {4'b0101, 4'b0000, 5'b00001, 5'b10011, 5'b00000, 9'b000010001};
registers[26] = {4'b0101, 4'b0000, 5'b00001, 5'b10100, 5'b00000, 9'b000010010};
registers[27] = {4'b0101, 4'b0000, 5'b00001, 5'b10101, 5'b00000, 9'b000010011};
registers[28] = {4'b0101, 4'b0000, 5'b00001, 5'b10110, 5'b00000, 9'b000010100};
registers[29] = {4'b0101, 4'b0000, 5'b00001, 5'b10111, 5'b00000, 9'b000010101};
registers[30] = {4'b0101, 4'b0000, 5'b00001, 5'b11000, 5'b00000, 9'b000010110};
registers[31] = {4'b0101, 4'b0000, 5'b00001, 5'b11001, 5'b00000, 9'b000010111};
registers[32] = {4'b0101, 4'b0000, 5'b00001, 5'b11010, 5'b00000, 9'b000011000};
registers[33] = {4'b0101, 4'b0000, 5'b00001, 5'b11011, 5'b00000, 9'b000011001};
registers[34] = {4'b0101, 4'b0000, 5'b00001, 5'b11111, 5'b00000, 9'b000011010};
registers[35] = {4'b0000, 4'b0010, 10'b0000000000, 5'b01100, 9'b000000000};
registers[36] = {4'b0101, 4'b0000, 5'b00001, 5'b01100, 5'b00000, 9'b000011011};
registers[37] = {4'b1000, 4'b0001, 10'b0000000000, 5'b01100, 9'b000000000};
registers[38] = {4'b0101, 4'b0000, 5'b00001, 5'b01100, 5'b00000, 9'b000011100};
registers[39] = {4'b1000, 4'b0010, 10'b0000000000, 5'b01100, 9'b000000000};
registers[40] = {4'b0101, 4'b0000, 5'b00001, 5'b01100, 5'b00000, 9'b000011101};
registers[41] = {4'b0100, 4'b0000, 24'd3};
//.load_registers
registers[42] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01100, 9'b000011011};
registers[43] = {4'b0000, 4'b0011, 5'b01100, 10'b0000000000, 9'b000000000};
registers[44] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01100, 9'b000011100};
registers[45] = {4'b1000, 4'b0011, 5'b01100, 10'b0000000000, 9'b000000000};
registers[46] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01100, 9'b000011101};
registers[47] = {4'b1000, 4'b0100, 5'b01100, 10'b0000000000, 9'b000000000};
registers[48] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b00010, 9'b000000000};
registers[49] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b00011, 9'b000000001};
registers[50] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b00100, 9'b000000010};
registers[51] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b00101, 9'b000000011};
registers[52] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b00110, 9'b000000100};
registers[53] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b00111, 9'b000000101};
registers[54] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01000, 9'b000000110};
registers[55] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01001, 9'b000000111};
registers[56] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01010, 9'b000001000};
registers[57] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01011, 9'b000001001};
registers[58] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01100, 9'b000001010};
registers[59] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01101, 9'b000001011};
registers[60] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01110, 9'b000001100};
registers[61] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b01111, 9'b000001101};
registers[62] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10000, 9'b000001110};
registers[63] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10001, 9'b000001111};
registers[64] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10010, 9'b000010000};
registers[65] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10011, 9'b000010001};
registers[66] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10100, 9'b000010010};
registers[67] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10101, 9'b000010011};
registers[68] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10110, 9'b000010100};
registers[69] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b10111, 9'b000010101};
registers[70] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b11000, 9'b000010110};
registers[71] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b11001, 9'b000010111};
registers[72] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b11010, 9'b000011000};
registers[73] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b11011, 9'b000011001};
registers[74] = {4'b0110, 4'b0000, 5'b00001, 5'b00000, 5'b11111, 9'b000011010};
registers[75] = {4'b0100, 4'b0000, 24'd6};
//.load_program
registers[76] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b01100, 9'b000000000};
registers[77] = {4'b1000, 4'b0000, 5'b11100, 5'b00000, 5'b01101, 9'b000000000};
//.load_program_loop
registers[78] = {4'b0100, 4'b1000, 5'b01100, 5'b11101, 14'd84};
registers[79] = {4'b0110, 4'b0000, 5'b01101, 5'b00000, 5'b01110, 9'b000000000};
registers[80] = {4'b0101, 4'b0001, 5'b01100, 5'b01110, 5'b00000, 9'b000000000};
registers[81] = {4'b0001, 4'b0101, 5'b01100, 5'b01100, 14'b00000000000001};
registers[82] = {4'b0001, 4'b0101, 5'b01101, 5'b01101, 14'b00000000000001};
registers[83] = {4'b0100, 4'b0000, 24'd78};
//.load_program_done
registers[84] = {4'b0100, 4'b0010, 5'b11111, 19'b0000000000000000000};
//.concat_disk_access
registers[85] = {4'b1000, 4'b0000, 5'b00010, 5'b00000, 5'b11000, 9'b000000000};
registers[86] = {4'b0001, 4'b1000, 5'b11000, 5'b01000, 5'b11000, 9'b000000000};
registers[87] = {4'b0001, 4'b0100, 5'b11000, 5'b00011, 5'b11000, 9'b000000000};
registers[88] = {4'b0001, 4'b1000, 5'b11000, 5'b01000, 5'b11000, 9'b000000000};
registers[89] = {4'b0001, 4'b0100, 5'b11000, 5'b00100, 5'b11000, 9'b000000000};
registers[90] = {4'b0100, 4'b0010, 5'b11111, 19'b0000000000000000000};
//.load_system_main_program
registers[91] = {4'b1000, 4'b0000, 5'b11111, 5'b00000, 5'b01010, 9'b000000000};
registers[92] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b00010, 9'b000000000};
registers[93] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b00011, 9'b000000000};
registers[94] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b00101, 9'b000000000};
registers[95] = {4'b0111, 5'b00100, 23'b00000000000000000000001};
registers[96] = {4'b0111, 5'b01111, 23'b11111111111111111111111};
registers[97] = {4'b0111, 5'b01101, 23'b00000000000000100000000};
registers[98] = {4'b0111, 5'b01110, 23'b00000000000000001111111};
registers[99] = {4'b0100, 4'b0001, 24'd85};
registers[100] = {4'b1001, 4'b0000, 5'b01100, 5'b11000, 5'b00000, 9'b010000000};
registers[101] = {4'b0101, 4'b0000, 5'b00000, 5'b01100, 5'b00000, 9'b000000000};
registers[102] = {4'b0001, 4'b0101, 5'b00100, 5'b00100, 14'b00000000000001};
//.load_system_main_program_loop
//.load_system_main_loop_sector
registers[103] = {4'b0100, 4'b0001, 24'd85};
registers[104] = {4'b1001, 4'b0000, 5'b01100, 5'b11000, 5'b00000, 9'b010000000};
registers[105] = {4'b0100, 4'b0011, 5'b01100, 5'b01111, 14'd118};
registers[106] = {4'b0100, 4'b0100, 5'b00100, 5'b01110, 14'd114};
registers[107] = {4'b0011, 4'b0000, 5'b01100, 5'b01101, 5'b00000, 9'b000000000};
registers[108] = {4'b1000, 4'b0001, 10'b0000000000, 5'b00011, 9'b000000000};
registers[109] = {4'b1000, 4'b0010, 10'b0000000000, 5'b01100, 9'b000000000};
registers[110] = {4'b0011, 4'b0000, 5'b01100, 5'b01101, 5'b00000, 9'b000000000};
registers[111] = {4'b1000, 4'b0001, 10'b0000000000, 5'b00010, 9'b000000000};
registers[112] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b00100, 9'b000000000};
registers[113] = {4'b0100, 4'b0000, 24'd103};
//.load_system_main_program_loop_sector_continue
registers[114] = {4'b0101, 4'b0000, 5'b00101, 5'b01100, 5'b00000, 9'b000000010};
registers[115] = {4'b0001, 4'b0101, 5'b00101, 5'b00101, 14'b00000000000001};
registers[116] = {4'b0001, 4'b0101, 5'b00100, 5'b00100, 14'b00000000000001};
registers[117] = {4'b0100, 4'b0000, 24'd103};
//.load_system_main_program_loop_out
registers[118] = {4'b0101, 4'b0000, 5'b00000, 5'b00101, 5'b00000, 9'b000000001};
registers[119] = {4'b1010, 4'b0000, 5'b00101, 5'b00000, 5'b00000, 9'b000000000};
registers[120] = {4'b0100, 4'b0010, 5'b01010, 10'b0000000000, 9'b000000000};
//.main
registers[121] = {4'b0111, 5'b11100, 23'b00000000000000001100100};
registers[122] = {4'b1010, 4'b0000, 5'b11100, 5'b00000, 5'b00000, 9'b000000000};
registers[123] = {4'b0100, 4'b0001, 24'd91};
registers[124] = {4'b0110, 4'b0000, 5'b00000, 5'b00000, 5'b01100, 9'b000000000};
registers[125] = {4'b1011, 4'b0100, 5'b01100, 10'b0000000000, 9'b000000000};
registers[126] = {4'b0111, 5'b11100, 23'b00000000000000000000010};
registers[127] = {4'b0110, 4'b0000, 5'b00000, 5'b00000, 5'b11101, 9'b000000001};
registers[128] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b11110, 9'b000000000};
registers[129] = {4'b0100, 4'b0001, 24'd76};
registers[130] = {4'b0000, 4'b0011, 5'b00000, 10'b0000000000, 9'b000000000};
registers[131] = {4'b1011, 4'b0101, 24'b000000000000000000000000};
//.work_loop
registers[132] = {4'b0111, 5'b11100, 23'b00000000000000000000010};
registers[133] = {4'b0110, 4'b0000, 5'b00000, 5'b00000, 5'b11101, 9'b000000001};
registers[134] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b11110, 9'b000000000};
registers[135] = {4'b0100, 4'b0000, 24'd1};
//.work_loop_after_interrupt_program
registers[136] = {4'b1011, 4'b0101, 24'b000000000000000000000000};
registers[137] = {4'b0100, 4'b0000, 24'd1};
//.work_loop_after_interrupt_system
registers[138] = {4'b1011, 4'b0101, 24'b000000000000000000000000};
registers[139] = {4'b0100, 4'b0000, 24'd132};
*/
end

endmodule 