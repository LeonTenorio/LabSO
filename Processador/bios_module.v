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
registers[0] = {32'b01000000000000000000000001100101};
registers[1] = {32'b1010XXXX1110000000XXXX0000000000};
registers[2] = {32'b1010XXXX1110100000XXXX0000000000};
registers[3] = {32'b1000000011100XXXXX00010XXXXXXXXX};
registers[4] = {32'b1000000000000XXXXX00011XXXXXXXXX};
registers[5] = {32'b01000011000111110100000000001011};
registers[6] = {32'b0110XXXX00010XXXXX01100000000000};
registers[7] = {32'b010100010001101100XXXXX000000000};
registers[8] = {32'b00010101000100001000000000000001};
registers[9] = {32'b00010101000110001100000000000001};
registers[10] = {32'b01000000000000000000000000000101};
registers[11] = {32'b0100001011111XXXXXXXXXXXXXXXXXXX};
registers[12] = {32'b1010XXXX0000100000XXXX0000000000};
registers[13] = {32'b010100000000100010XXXXX000000000};
registers[14] = {32'b010100000000100011XXXXX000000001};
registers[15] = {32'b010100000000100100XXXXX000000010};
registers[16] = {32'b010100000000100101XXXXX000000011};
registers[17] = {32'b010100000000100110XXXXX000000100};
registers[18] = {32'b010100000000100111XXXXX000000101};
registers[19] = {32'b010100000000101000XXXXX000000110};
registers[20] = {32'b010100000000101001XXXXX000000111};
registers[21] = {32'b010100000000101010XXXXX000001000};
registers[22] = {32'b010100000000101011XXXXX000001001};
registers[23] = {32'b010100000000101100XXXXX000001010};
registers[24] = {32'b010100000000101101XXXXX000001011};
registers[25] = {32'b010100000000101110XXXXX000001100};
registers[26] = {32'b010100000000101111XXXXX000001101};
registers[27] = {32'b010100000000110000XXXXX000001110};
registers[28] = {32'b010100000000110001XXXXX000001111};
registers[29] = {32'b010100000000110010XXXXX000010000};
registers[30] = {32'b010100000000110011XXXXX000010001};
registers[31] = {32'b010100000000110100XXXXX000010010};
registers[32] = {32'b010100000000110101XXXXX000010011};
registers[33] = {32'b010100000000110110XXXXX000010100};
registers[34] = {32'b010100000000110111XXXXX000010101};
registers[35] = {32'b010100000000111000XXXXX000010110};
registers[36] = {32'b010100000000111001XXXXX000010111};
registers[37] = {32'b010100000000111010XXXXX000011000};
registers[38] = {32'b010100000000111011XXXXX000011001};
registers[39] = {32'b010100000000111111XXXXX000011010};
registers[40] = {32'b00000010000000000001100XXXXXXXXX};
registers[41] = {32'b010100000000101100XXXXX000011011};
registers[42] = {32'b10000001XXXXXXXXXX01100XXXXXXXXX};
registers[43] = {32'b010100000000101100XXXXX000011100};
registers[44] = {32'b10000010XXXXXXXXXX01100XXXXXXXXX};
registers[45] = {32'b010100000000101100XXXXX000011101};
registers[46] = {32'b010100000000111110XXXXX000011110};
registers[47] = {32'b01000000000000000000000001110010};
registers[48] = {32'b1010XXXX0000100000XXXX0000000000};
registers[49] = {32'b0110XXXX00001XXXXX01100000011011};
registers[50] = {32'b0000001101100XXXXXXXXXXXXXXXXXXX};
registers[51] = {32'b0110XXXX00001XXXXX01100000011100};
registers[52] = {32'b1000001101100XXXXXXXXXXXXXXXXXXX};
registers[53] = {32'b0110XXXX00001XXXXX01100000011101};
registers[54] = {32'b1000010001100XXXXXXXXXXXXXXXXXXX};
registers[55] = {32'b0110XXXX00001XXXXX00010000000000};
registers[56] = {32'b0110XXXX00001XXXXX00011000000001};
registers[57] = {32'b0110XXXX00001XXXXX00100000000010};
registers[58] = {32'b0110XXXX00001XXXXX00101000000011};
registers[59] = {32'b0110XXXX00001XXXXX00110000000100};
registers[60] = {32'b0110XXXX00001XXXXX00111000000101};
registers[61] = {32'b0110XXXX00001XXXXX01000000000110};
registers[62] = {32'b0110XXXX00001XXXXX01001000000111};
registers[63] = {32'b0110XXXX00001XXXXX01010000001000};
registers[64] = {32'b0110XXXX00001XXXXX01011000001001};
registers[65] = {32'b0110XXXX00001XXXXX01100000001010};
registers[66] = {32'b0110XXXX00001XXXXX01101000001011};
registers[67] = {32'b0110XXXX00001XXXXX01110000001100};
registers[68] = {32'b0110XXXX00001XXXXX01111000001101};
registers[69] = {32'b0110XXXX00001XXXXX10000000001110};
registers[70] = {32'b0110XXXX00001XXXXX10001000001111};
registers[71] = {32'b0110XXXX00001XXXXX10010000010000};
registers[72] = {32'b0110XXXX00001XXXXX10011000010001};
registers[73] = {32'b0110XXXX00001XXXXX10100000010010};
registers[74] = {32'b0110XXXX00001XXXXX10101000010011};
registers[75] = {32'b0110XXXX00001XXXXX10110000010100};
registers[76] = {32'b0110XXXX00001XXXXX10111000010101};
registers[77] = {32'b0110XXXX00001XXXXX11000000010110};
registers[78] = {32'b0110XXXX00001XXXXX11001000010111};
registers[79] = {32'b0110XXXX00001XXXXX11010000011000};
registers[80] = {32'b0110XXXX00001XXXXX11011000011001};
registers[81] = {32'b0110XXXX00001XXXXX11111000011010};
registers[82] = {32'b0110XXXX00001XXXXX11110000011110};
registers[83] = {32'b01000000000000000000000001110000};
registers[84] = {32'b1000000011111XXXXX01010XXXXXXXXX};
registers[85] = {32'b01111100000000000000000000000001};
registers[86] = {32'b1000000000000XXXXX00101XXXXXXXXX};
registers[87] = {32'b01110111111111111111111111111111};
registers[88] = {32'b01110110100000000000000100000000};
registers[89] = {32'b1001XXXX0110011000XXXX0010000000};
registers[90] = {32'b010100000000001100XXXXX000000000};
registers[91] = {32'b1010XXXX0110000000XXXX0000000000};
registers[92] = {32'b00010101110001100000000000000001};
registers[93] = {32'b1001XXXX0110011000XXXX0010000000};
registers[94] = {32'b01000011011000111100000001100011};
registers[95] = {32'b010100000010101100XXXXX000000010};
registers[96] = {32'b00010101001010010100000000000001};
registers[97] = {32'b00010101110001100000000000000001};
registers[98] = {32'b01000000000000000000000001011101};
registers[99] = {32'b010100000000000101XXXXX000000001};
registers[100] = {32'b0100001001010XXXXXXXXXXXXXXXXXXX};
registers[101] = {32'b01000001000000000000000001010100};
registers[102] = {32'b0110XXXX00000XXXXX01100000000000};
registers[103] = {32'b1011010001100XXXXXXXXXXXXXXXXXXX};
registers[104] = {32'b01110000000000000000000000000000};
registers[105] = {32'b01111110000000000000000000000010};
registers[106] = {32'b0110XXXX00000XXXXX11101000000001};
registers[107] = {32'b0000001100000XXXXXXXXXXXXXXXXXXX};
registers[108] = {32'b01000001000000000000000000000001};
registers[109] = {32'b10110101XXXXXXXXXXXXXXXXXXXXXXXX};
registers[110] = {32'b01000001000000000000000000000001};
registers[111] = {32'b01000000000000000000000000110000};
registers[112] = {32'b10110101XXXXXXXXXXXXXXXXXXXXXXXX};
registers[113] = {32'b01000000000000000000000000001100};
registers[114] = {32'b01000000000000000000000001101000};
end

endmodule 