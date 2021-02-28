module disk_controller(
input[2:0] track,
input[4:0] sector,
input[6:0] address_in_sector,
input read,
input write,
input[31:0] write_value,
output reg[31:0] read_value,
output reg read_done,
output reg write_done,
input clk
);

reg[31:0] values[32768:0];
wire[31:0] registers[32768:0];
reg not_initial[32768:0];

reg not_first_clk = 0;

always @(posedge clk)
begin
	write_done = 0;
	if(write)
	begin
		values[{track, sector, address_in_sector}] = write_value;
		not_initial[{track, sector, address_in_sector}] = 1;
		write_done = 1;
	end
end

always @(negedge clk)
begin
	read_done = 0;
	if(read)
	begin
		if(not_initial[{track, sector, address_in_sector}])
		begin
			read_value = values[{track, sector, address_in_sector}];
		end
		else
		begin
			read_value = registers[{track, sector, address_in_sector}];
		end
		read_done = 1;
	end
end

assign registers[0] = {16'd0, 16'd84};
assign registers[1] = {32'd300};
assign registers[2] = {32'b01110000000000000000000000000000};
assign registers[3] = {32'b10110001XXXXXXXXXXXXXXXXXXXXXXXX};
assign registers[4] = {32'b01111111000000000000000000000000};
assign registers[5] = {32'b01111101100000000000111111111111};
assign registers[6] = {32'b0110XXXX00000XXXXX11010000000001};
assign registers[7] = {32'b00010101110101101000000000000010};
assign registers[8] = {32'b1000000011010XXXXX11001XXXXXXXXX};
assign registers[9] = {32'b01000000000000000000000000101010};
assign registers[10] = {32'b0110XXXX11010XXXXX11001111111110};
assign registers[11] = {32'b0110XXXX11010XXXXX10100111111111};
assign registers[12] = {32'b0100001010100XXXXXXXXXXXXXXXXXXX};
assign registers[13] = {32'b00010101110111101100000000000001};
assign registers[14] = {32'b0110XXXX11011XXXXX01101000000000};
assign registers[15] = {32'b1010XXXX0110100000XXXX0000000000};
assign registers[16] = {32'b0100001011111XXXXXXXXXXXXXXXXXXX};
assign registers[17] = {32'b1000000000010XXXXX11000XXXXXXXXX};
assign registers[18] = {32'b00011000110000010111000XXXXXXXXX};
assign registers[19] = {32'b00010100110000001111000XXXXXXXXX};
assign registers[20] = {32'b00011000110000011111000XXXXXXXXX};
assign registers[21] = {32'b00010100110000010011000XXXXXXXXX};
assign registers[22] = {32'b0100001011111XXXXXXXXXXXXXXXXXXX};
assign registers[23] = {32'b1000000011111XXXXX01010XXXXXXXXX};
assign registers[24] = {32'b0110XXXX11011XXXXX00010000000011};
assign registers[25] = {32'b0110XXXX11011XXXXX00011000000010};
assign registers[26] = {32'b0110XXXX11011XXXXX00101000000001};
assign registers[27] = {32'b00010101110111101100000000000011};
assign registers[28] = {32'b01110010000000000000000000000001};
assign registers[29] = {32'b1000000000000XXXXX00110XXXXXXXXX};
assign registers[30] = {32'b1000000000101XXXXX00111XXXXXXXXX};
assign registers[31] = {32'b01110110100000000000000100000000};
assign registers[32] = {32'b01110111111111111111111111111111};
assign registers[33] = {32'b01000001000000000000000000001111};
assign registers[34] = {32'b1001XXXX0110011000XXXX0010000000};
assign registers[35] = {32'b01000011011000111100000000100111};
assign registers[36] = {32'b010100000011101100XXXXX000000001};
assign registers[37] = {32'b00010101001110011100000000000001};
assign registers[38] = {32'b00010101001100011000000000000001};
assign registers[39] = {32'b00010101110001100000000000000001};
assign registers[40] = {32'b01000000000000000000000000100000};
assign registers[41] = {32'b010100000010100110XXXXX000000000};
assign registers[42] = {32'b1000000000110XXXXX11000XXXXXXXXX};
assign registers[43] = {32'b0100001001010XXXXXXXXXXXXXXXXXXX};
assign registers[44] = {32'b1000000011001XXXXX11010XXXXXXXXX};
assign registers[45] = {32'b00010101110011100100000000010101};
assign registers[46] = {32'b01111010000000000000000001101110};
assign registers[47] = {32'b010100001101110100XXXXX000000000};
assign registers[48] = {32'b00010101110111101111111111111111};
assign registers[49] = {32'b010100001100111010XXXXX000000000};
assign registers[50] = {32'b00010101110011100100000000000001};
assign registers[51] = {32'b01000001000000000000000000001011};
assign registers[52] = {32'b00010101110011100111111111111111};
assign registers[53] = {32'b0110XXXX11001XXXXX11010000000000};
assign registers[54] = {32'b01111010000000000000000000000001};
assign registers[55] = {32'b010100001101110100XXXXX000000000};
assign registers[56] = {32'b00010101110111101111111111111111};
assign registers[57] = {32'b01111010000000000000000000000000};
assign registers[58] = {32'b010100001101110100XXXXX000000000};
assign registers[59] = {32'b00010101110111101111111111111111};
assign registers[60] = {32'b01111010000000000000000000000000};
assign registers[61] = {32'b00010100101001101010100XXXXXXXXX};
assign registers[62] = {32'b010100001101110100XXXXX000000000};
assign registers[63] = {32'b00010101110111101111111111111111};
assign registers[64] = {32'b010100001100111010XXXXX000000000};
assign registers[65] = {32'b00010101110011100100000000000001};
assign registers[66] = {32'b01000001000000000000000000010101};
assign registers[67] = {32'b00010101110011100111111111111111};
assign registers[68] = {32'b0110XXXX11001XXXXX11010000000000};
assign registers[69] = {32'b01111010000000000000000000000000};
assign registers[70] = {32'b01111010100000000000000000000000};
assign registers[71] = {32'b00010100101011101010101XXXXXXXXX};
assign registers[72] = {32'b00010100101011010010101XXXXXXXXX};
assign registers[73] = {32'b0110XXXX10101XXXXX10101000000000};
assign registers[74] = {32'b010100001101110101XXXXX000000000};
assign registers[75] = {32'b00010101110111101111111111111111};
assign registers[76] = {32'b010100001100111010XXXXX000000000};
assign registers[77] = {32'b00010101110011100100000000000001};
assign registers[78] = {32'b01000001000000000000000000001011};
assign registers[79] = {32'b00010101110011100111111111111111};
assign registers[80] = {32'b0110XXXX11001XXXXX11010000000000};
assign registers[81] = {32'b10110010XXXXXXXXXXXXXXXXXXXXXXXX};
assign registers[82] = {32'b00000001000000000000000000000000};
assign registers[83] = {32'b11111111111111111111111111111111};


//Meus arquivos de programas que serao executados
assign registers[4096] = {16'd0, 16'd4};
//Programa 1 estara na track 2 no setor 0
assign registers[4097] = {16'd0, 8'd2, 8'd0};
//Programa 2 estara na track 2 no setor 1
assign registers[4098] = {16'd0, 8'd2, 8'd1};
assign registers[4099] = {32'b11111111111111111111111111111111};
//Fim dos arquivos de programas

//Programa teste 1 
assign registers[8192] = {16'd0, 16'd26};
assign registers[8193] = {32'b01110000000000000000000000000000};
assign registers[8194] = {32'b01000000000000000000000000001001};
assign registers[8195] = {32'b0110XXXX11010XXXXX11001111111110};
assign registers[8196] = {32'b0110XXXX11010XXXXX10100111111111};
assign registers[8197] = {32'b0100001010100XXXXXXXXXXXXXXXXXXX};
assign registers[8198] = {32'b00010101110111101100000000000001};
assign registers[8199] = {32'b0110XXXX11011XXXXX01101000000000};
assign registers[8200] = {32'b1010XXXX0110100000XXXX0000000000};
assign registers[8201] = {32'b0100001011111XXXXXXXXXXXXXXXXXXX};
assign registers[8202] = {32'b1000000011001XXXXX11010XXXXXXXXX};
assign registers[8203] = {32'b01111010000000000000000000000001};
assign registers[8204] = {32'b01111010100000000000000000000001};
assign registers[8205] = {32'b01000011101001010100000000001110};
assign registers[8206] = {32'b01000000000000000000000000010111};
assign registers[8207] = {32'b01111010000000000000000000001010};
assign registers[8208] = {32'b010100001101110100XXXXX000000000};
assign registers[8209] = {32'b00010101110111101111111111111111};
assign registers[8210] = {32'b010100001100111010XXXXX000000000};
assign registers[8211] = {32'b00010101110011100100000000000001};
assign registers[8212] = {32'b01000001000000000000000000000101};
assign registers[8213] = {32'b00010101110011100111111111111111};
assign registers[8214] = {32'b0110XXXX11001XXXXX11010000000000};
assign registers[8215] = {32'b01000000000000000000000000001010};
assign registers[8216] = {32'b00000001000000000000000000000000};
assign registers[8217] = {32'b11111111111111111111111111111111};

//Programa teste 2
assign registers[8320] = {16'd0, 16'd26};
assign registers[8321] = {32'b01110000000000000000000000000000};
assign registers[8322] = {32'b01000000000000000000000000001001};
assign registers[8323] = {32'b0110XXXX11010XXXXX11001111111110};
assign registers[8324] = {32'b0110XXXX11010XXXXX10100111111111};
assign registers[8325] = {32'b0100001010100XXXXXXXXXXXXXXXXXXX};
assign registers[8326] = {32'b00010101110111101100000000000001};
assign registers[8327] = {32'b0110XXXX11011XXXXX01101000000000};
assign registers[8328] = {32'b1010XXXX0110100000XXXX0000000000};
assign registers[8329] = {32'b0100001011111XXXXXXXXXXXXXXXXXXX};
assign registers[8330] = {32'b1000000011001XXXXX11010XXXXXXXXX};
assign registers[8331] = {32'b01111010000000000000000000000001};
assign registers[8332] = {32'b01111010100000000000000000000001};
assign registers[8333] = {32'b01000011101001010100000000001110};
assign registers[8334] = {32'b01000000000000000000000000010111};
assign registers[8335] = {32'b01111010000000000000000000010100};
assign registers[8336] = {32'b010100001101110100XXXXX000000000};
assign registers[8337] = {32'b00010101110111101111111111111111};
assign registers[8338] = {32'b010100001100111010XXXXX000000000};
assign registers[8339] = {32'b00010101110011100100000000000001};
assign registers[8340] = {32'b01000001000000000000000000000101};
assign registers[8341] = {32'b00010101110011100111111111111111};
assign registers[8342] = {32'b0110XXXX11001XXXXX11010000000000};
assign registers[8343] = {32'b01000000000000000000000000001010};
assign registers[8344] = {32'b00000001000000000000000000000000};
assign registers[8345] = {32'b11111111111111111111111111111111};

endmodule 