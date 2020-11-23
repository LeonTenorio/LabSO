module saida_display(
input clk,
input[25:0] dado,
input enter_out,
output[6:0] display1,
output[6:0] display2,
output[6:0] display3,
output[6:0] display4,
output[6:0] display5,
output[6:0] display6,
output[6:0] display7,
output[6:0] display8);

reg[25:0] temp_dado;

wire[3:0] zero, um, dois, tres, quatro, cinco, seis, sete;

dado_bcd dado_bcd(.dado(temp_dado), 
.zero(zero), 
.um(um), 
.dois(dois),
.tres(tres),
.quatro(quatro),
.cinco(cinco),
.seis(seis),
.sete(sete));

display disp1(.numero(zero),.display(display1));
display disp2(.numero(um),.display(display2));
display disp3(.numero(dois),.display(display3));
display disp4(.numero(tres),.display(display4));
display disp5(.numero(quatro),.display(display5));
display disp6(.numero(cinco),.display(display6));
display disp7(.numero(seis),.display(display7));
display disp8(.numero(sete),.display(display8));

always @(posedge clk)
begin
	if(enter_out==1)
		temp_dado = dado;
end

endmodule 