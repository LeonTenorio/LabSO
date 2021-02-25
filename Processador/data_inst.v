module data_inst(address, write_data, write, instruction, clk);

input clk;

input write;

input[31:0] write_data;

input[31:0] address;

output reg[0:31] instruction;//DATA INST sera a unica em EM BIG ENDIAN

reg[0:31] registers[1000:0];//As instrucoes armazenadas tambem estao em BIG ENDIAN

always @(posedge clk)
begin	
	if(write)
	begin
		registers[address] <= write_data;
	end
	/*ALGORITMO DE TESTE*/
	//FIBONNACI
	//REG[0] terah o valor da entrada
	//REG[1] terah o contador do termo que esta sendo calculado da sequencia
	//REG[2] assumira a cada iteracao do loop o valor de Fn
	//REG[2] terah o termo Fn-1
	//REG[3] terah o termo Fn-2
	/*registers[0] = {4'b1001, 4'd0, 5'd0, 10'd0, 9'd0};				//ENTRADA:	IN 0
	registers[1] = {4'b0111, 5'd10, 23'd0};							//				LI 10, 0
	registers[2] = {4'b0100, 4'b0011, 5'd0, 5'd10, 14'd11};		//				BEQ 0, 10, ZERO_UM
	registers[3] = {4'b0111, 5'd10, 23'd1};							//				LI 10, 1
	registers[4] = {4'b0100, 4'b0011, 5'd0, 5'd10, 14'd11};		//				BEQ 0, 10, ZERO_UM
	registers[5] = {4'b0111, 5'd10, 23'd2};							//				LI 10, 2
	registers[6] = {4'b0100, 4'b0011, 5'd0, 5'd10, 14'd14};		//				BEQ 0, 10, DOIS
	registers[7] = {4'b0111, 5'd1, 23'd2};								//				LI 1, 2
	registers[8] = {4'b0111, 5'd2, 23'd1};								//				LI 2, 1
	registers[9] = {4'b0111, 5'd3, 23'd1};								//				LI 3, 1
	registers[10] = {4'b0100, 4'd0, 24'd17};							//				B LOOP

	registers[11] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};			//ZERO_UM:	OUT 10
	registers[12] = {4'b0100, 4'd0, 24'd0};							//				B ENTRADA
	
	registers[13] = {32'd0};	
	
	registers[14] = {4'b0111, 5'd10, 23'd1};							//DOIS:	LI 10, 1
	registers[15] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};			//			OUT 10
	registers[16] = {4'b0100, 4'd0, 24'd0};							//			B ENTRADA

	registers[17] = {4'b0100, 4'b0011, 5'd0, 5'd1, 14'd23};		//LOOP:	BEQ 0, 1, SAIDA		//Aqui REG[2] eh Fn
	registers[18] = {4'b0001, 4'b0101, 5'd1, 5'd1, 14'd1};		//			ADDI 1, 1, 1			//A partir daqui REG[2] eh Fn-1 e REG[3] eh Fn-2
	registers[19] = {4'b1000, 4'b0000, 5'd2, 5'd0, 5'd9, 9'd0};	//			MOV 2, 9 				//Salva o valor de Fn-1
	registers[20] = {4'b0001, 4'b0100, 5'd2, 5'd3, 5'd2, 9'd0};	//			ADD 2, 3, 2				//Fn = Fn-1 + Fn-2
	registers[21] = {4'b1000, 4'b0000, 5'd9, 5'd0, 5'd3, 9'd0};	//			MOV 9, 3					//Busca de volta o valor de Fn-1
	registers[22] = {4'b0100, 4'd0, 24'd17};							//			B LOOP
								
	registers[23] = {4'b1010, 4'd0, 5'd2, 10'd0, 9'd0};			//SAIDA: OUT 2
	registers[24] = {4'b0100, 4'd0, 24'd0};							//			B ENTRADA
	
	registers[25] = {32'd0};*/
	
	/*ALGORITMO DE TESTE*/
	//Teste das instrucoes ainda nao utilizadas
	/*registers[0] = {4'b0111, 5'd0, 23'd10};						//		LI 0,10
	registers[1] = {4'b0111, 5'd1, 23'd9};							//		LI 1, 9
	registers[2] = {4'b0100, 4'b0100, 5'd0, 5'd1, 14'd4};		//		BNE 0, 1, OUT_BNE_CERTO
	registers[3] = {4'b0100, 4'b0000, 24'd9};						//		B OUT_BNE_ERRADO

																				//OUT_BNE_CERTO: //saida 100
	registers[4] = {4'b0111, 5'd10, 23'd100};						//		LI 10, 100
	registers[5] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[6] = {4'b0000, 4'b0001, 24'd0};						//		HALT
	registers[7] = {4'b0100, 4'b0111, 5'd0, 5'd1, 14'd13};	//		BMT 0, 1, OUT_BMT_CERTO
	registers[8] = {4'b0100, 4'b0000, 24'd18};					//		B OUT_BMT_ERRADO
							
																				//OUT_BNE_ERRADO:	//saida 101 -- nunca sair
	registers[9] = {4'b0111, 5'd10, 23'd101};						//		LI 10, 101
	registers[10] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[11] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[12] = {4'b0100, 4'b0000, 24'd138};					//		B SAIDA
							
																				//OUT_BMT_CERTO: //saida 104
	registers[13] = {4'b0111, 5'd10, 23'd104};					//		LI 10, 104
	registers[14] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[15] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[16] = {4'b0100, 4'b0110, 5'd1, 5'd0, 14'd22};	//		BLE 1, 0, OUT_BLE_CERTO1
	registers[17] = {4'b0100, 4'b0000, 24'd27};					//		B OUT_BLE_ERRADO1
										
																				//OUT_BMT_ERRADO: //saida 105 -- nunca sair
	registers[18] = {4'b0111, 5'd10, 23'd105};					//		LI 10, 105
	registers[19] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[20] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[21] = {4'b0100, 4'b0000, 24'd138};					//		B SAIDA
							
																				//OUT_BLE_CERTO1: //saida 106
	registers[22] = {4'b0111, 5'd10, 23'd106};					//		LI 10, 106
	registers[23] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[24] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[25] = {4'b0100, 4'b1000, 5'd0, 5'd1, 14'd31};	//		BME 0, 1, OUT_BME_CERTO1
	registers[26] = {4'b0100, 4'b0000, 24'd37};					//		B OUT_BME_ERRADO1
							
																				//OUT_BLE_ERRADO1: //saida 107 -- nunca sair
	registers[27] = {4'b0111, 5'd10, 23'd107};					//		LI 10, 107
	registers[28] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[29] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[30] = {4'b0100, 4'b0000, 24'd138};					//		B SAIDA

																				//OUT_BME_CERTO1: //saida 108
	registers[31] = {4'b0111, 5'd10, 23'd108};					//		LI 10, 108
	registers[32] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[33] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[34] = {4'b0001, 4'b0101, 5'd1, 5'd1, 14'd1};	//		ADDI 1, 1, 1
	registers[35] = {4'b0100, 4'b0110, 5'd0, 5'd1, 14'd41};	//		BLE 0, 1, OUT_BLE_CERTO2
	registers[36] = {4'b0100, 4'b0000, 24'd46};					//		B OUT_BLE_ERRADO2
							
																				//OUT_BME_ERRADO1: //saida 109 -- nunca sair
	registers[37] = {4'b0111, 5'd10, 23'd109};					//		LI 10, 109
	registers[38] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[39] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[40] = {4'b0100, 4'b0000, 24'd138};					//		B SAIDA

																				//OUT_BLE_CERTO2: //saida 110
	registers[41] = {4'b0111, 5'd10, 23'd110};					//		LI 10, 110
	registers[42] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[43] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[44] = {4'b0100, 4'b1000, 5'd0, 5'd1, 14'd50};	//		BME 0, 1, OUT_BME_CERTO2
	registers[45] = {4'b0100, 4'b0000, 24'd55};					//		B OUT_BME_ERRADO2
							
																				//OUT_BLE_ERRADO2: //saida 111 -- nunca sair
	registers[46] = {4'b0111, 5'd10, 23'd111};					//		LI 10, 111
	registers[47] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[48] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[49] = {4'b0100, 4'b0000, 24'd138};					//		B SAIDA

																				//OUT_BME_CERTO2: //saida 112
	registers[50] = {4'b0111, 5'd10, 23'd112};					//		LI 10, 112
	registers[51] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[52] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[53] = {4'b0100, 4'b0001, 24'd59};					//		BL OUT_BL
	registers[54] = {4'b0100, 4'b0000, 24'd63};					//		B OUT_MULT_DIV_SLT
							
																				//OUT_BME_ERRADO2: //saida 113 -- nunca sair
	registers[55] = {4'b0111, 5'd10, 23'd113};					//		LI 10, 113
	registers[56] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[57] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[58] = {4'b0100, 4'b0000, 24'd138};					//		B SAIDA

																				//OUT_BL:	//saida 120
	registers[59] = {4'b0111, 5'd10, 23'd120};					//		LI 10, 120
	registers[60] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[61] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[62] = {4'b0100, 4'b0010, 5'd31, 19'd0};			//		BR 31
							
																				//OUT_MULT_DIV_SLT:
	registers[63] = {4'b0111, 5'd0, 23'd3};						//		LI 0, 3
	registers[64] = {4'b0111, 5'd1, 23'd5};						//		LI 1, 5
	registers[65] = {4'b0010, 4'd0, 5'd0, 5'd1, 14'd0};		//		MULT 0, 1
	registers[66] = {4'b1000, 4'b0010, 10'd0, 5'd10, 9'd0};	//		MFLO 10
	registers[67] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10				//saida tera que ser 15
	registers[68] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[69] = {4'b1000, 4'b0001, 10'd0, 5'd10, 9'd0};	//		MFHI 10
	registers[70] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10				//saida tera que ser 0
	registers[71] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[72] = {4'b0011, 4'd0, 5'd1, 5'd0, 14'd0};		//		DIV 1, 0
	registers[73] = {4'b1000, 4'b0010, 10'd0, 5'd10, 9'd0};	//		MFLO 10
	registers[74] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10				//saida tera que ser 1
	registers[75] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[76] = {4'b1000, 4'b0001, 10'd0, 5'd10, 9'd0};	//		MFHI 10				//saida tera que ser 2
	registers[77] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10
	registers[78] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[79] = {4'b0001, 4'b1101, 5'd0, 5'd1, 5'd10, 9'd0};//		SLT 0, 1, 10
	registers[80] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10				//saida tera que ser 1
	registers[81] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[82] = {4'b0001, 4'b1101, 5'd1, 5'd0, 5'd10, 9'd0};//		SLT 1, 0, 10
	registers[83] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};		//		OUT 10				//saida tera que ser 0
	registers[84] = {4'b0000, 4'b0001, 24'd0};					//		HALT
	registers[85] = {4'b0100, 4'b0000, 24'd86};					//		B RESTANTE

																						//RESTANTE:	
	registers[86] = {4'b0111, 5'd0, 23'd9};								//		LI 0, 9
	registers[87] = {4'b0111, 5'd1, 23'd5};								//		LI 1, 5
	registers[88] = {4'b0001, 4'b0111, 5'd0, 5'd0, 5'd2, 9'd0};		//		NOT 0, 2
	registers[89] = {4'b0001, 4'b0111, 5'd1, 5'd0, 5'd3, 9'd0};		//		NOT 1, 3
	registers[90] = {4'b0001, 4'b0010, 5'd2, 5'd1, 5'd5, 9'd0};		//		AND 2, 1, 5
	registers[91] = {4'b0001, 4'b0010, 5'd3, 5'd0, 5'd6, 9'd0};		//		AND 3, 0, 6
	registers[92] = {4'b0001, 4'b0000, 5'd5, 5'd6, 5'd10, 9'd0};	//		OR 5, 6, 10
	registers[93] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 12
	registers[94] = {4'b0000, 4'b0001, 24'd0};							//		HALT 
	registers[95] = {4'b0001, 4'b0001, 5'd0, 5'd1, 5'd10, 9'd0};	//		XOR 0, 1, 10
	registers[96] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 12
	registers[97] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[98] = {4'b0001, 4'b0000, 5'd0, 5'd3, 5'd5, 9'd0};		//		OR 0, 3, 5
	registers[99] = {4'b0001, 4'b0000, 5'd1, 5'd2, 5'd6, 9'd0};		//		OR 1, 2, 6
	registers[100] = {4'b0001, 4'b0011, 5'd5, 5'd6, 5'd10, 9'd0};	//		NAND 5, 6, 10
	registers[101] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 12
	registers[102] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[103] = {4'b0111, 5'd0, 23'd10};								//		LI 0, 10
	registers[104] = {4'b0111, 5'd1, 23'd2};								//		LI 1, 2
	registers[105] = {4'b0001, 4'b0110, 5'd0, 5'd1, 5'd10, 9'd0};	//		SUB 0, 1, 10
	registers[106] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 8
	registers[107] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[108] = {4'b0001, 4'b1000, 5'd10, 5'd1, 5'd10, 9'd0};	//		SL 10, 1, 10
	registers[109] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 16
	registers[110] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[111] = {4'b0001, 4'b1001, 5'd10, 5'd1, 5'd10, 9'd0};	//		SR 10, 1, 10	//saida tera que ser 8
	registers[112] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10
	registers[113] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[114] = {4'b0001, 4'b1010, 5'd10, 5'd0, 5'd10, 9'd0};	//		ROT 10, 10
	registers[115] = {4'b0001, 4'b1001, 5'd10, 5'd26, 5'd10, 9'd0};//		SR 10, 26, 10
	registers[116] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 4
	registers[117] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[118] = {4'b0111, 5'd0, 23'd10};								//		LI 0, 10
	registers[119] = {4'b0111, 5'd1, 23'd9};								//		LI 1, 9
	registers[120] = {4'b0001, 4'b1011, 5'd0, 5'd1, 5'd10, 9'd0};	//		CMP 0, 1, 10
	registers[121] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 0	
	registers[122] = {4'b0000, 4'b0001, 24'd0}; 							//		HALT
	registers[123] = {4'b0111, 5'd1, 23'd10};								//		LI 1, 10
	registers[124] = {4'b0001, 4'b1011, 5'd0, 5'd1, 5'd10, 9'd0};	//		CMP 0, 1, 10
	registers[125] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 1
	registers[126] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[127] = {4'b0111, 5'd2, 23'd0};								//		LI 2, 0
	registers[128] = {4'b0101, 4'd0, 5'd2, 5'd1, 5'd0, 9'd2};		//		STORE 2, 1, 2
	registers[129] = {4'b0110, 4'd0, 5'd2, 5'd0, 5'd10, 9'd2};		//		LOAD 2, 10, 2
	registers[130] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 10
	registers[131] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[132] = {4'b0111, 5'd0, 23'd10};								//		LI 0, 10
	registers[133] = {4'b0111, 5'd1, 23'd0};								//		LI 1, 0
	registers[134] = {4'b0001, 4'b0110, 5'd1, 5'd0, 5'd1, 9'd0};	//		SUB 1, 0, 1		//reg[1]=-10
	registers[135] = {4'b0001, 4'b1100, 5'd0, 5'd1, 5'd10, 9'd0};	//		CMN 0, 1, 10
	registers[136] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10			//saida tera que ser 1
	registers[137] = {4'b0000, 4'b0001, 24'd0};							//		HALT
										
																						//SAIDA:
	registers[138] = {4'b0111, 5'd10, 23'd999};							//		LI 10, 999
	registers[139] = {4'b1010, 4'd0, 5'd10, 10'd0, 9'd0};				//		OUT 10
	registers[140] = {4'b0000, 4'b0001, 24'd0};							//		HALT
	registers[141] = {4'b0100, 4'b0000, 24'd0};*/						//		B INICIO
	//Sequencia resultante: 
	//100 - 104 - 106 - 108 - 110 - 112 - 120 - 15 - 0 - 1 - 2 - 1 - 0 - 12 - 12 - 12 - 8 - 16 - 8 - 4 - 0 - 1 - 10 - 1 - 999
end

always @(negedge clk)
begin
	if(address<32'd256)
		instruction <= registers[address];
end
endmodule 