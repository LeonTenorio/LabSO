module byte_to_bcd(
//Codigo traduzido de uma fonte
//Codigo original disponivel em: https://pubweb.eng.utah.edu/~nmcdonal/Tutorials/BCDTutorial/BCDConversion.html
input [7:0] dado_byte,
output reg[3:0] centenas,
output reg[3:0] dezenas,
output reg[3:0] unitarios);

integer i;
always @(dado_byte)
begin
	centenas = 4'd0;
	dezenas = 4'd0;
	unitarios = 4'd0;
	
	for(i=7; i>=0; i=i-1)
	begin
		if(centenas>=5)
			centenas = centenas + 4'd3;
		if(dezenas>=5)
			dezenas = dezenas + 4'd3;
		if(unitarios>=5)
			unitarios = unitarios + 4'd3;
		centenas = centenas << 1;
		centenas[0] = dezenas[3];
		dezenas = dezenas << 1;
		dezenas[0] = unitarios[3];
		unitarios = unitarios << 1;
		unitarios[0] = dado_byte[i];
	end
end

endmodule 