module apresentacao(
input bios_controll,
input clk, 
input[5:0] valor,
input enter,
output done_inst,
output[6:0] display1, 
output[6:0] display2, 
output[6:0] display3,
output[6:0] display4,
output[6:0] display5,
output[6:0] display6,
output[6:0] display7,
output[6:0] display8);

parameter wake_up = 1'd0;//Para o algoritmo sintetico eh necessario comentar essa linha

wire enter_est;//Para o algoritmo sintetico "enter_est" vira um parameter com igualdade 1'd0
wire[3:0] enter_devs;
wire[127:0] out_devs;

processador processador(
.bios_controll(bios_controll),
.clk(clk),
.wake_up(wake_up),
.dev_in({122'd0, valor}),
.dev_out(out_devs),
.enter_in({3'd0, enter_est}),
.enter_out(enter_devs),
.done_inst(done_inst));

saida_display saida_display(
.clk(clk),
.dado(out_devs[25:0]),
.enter_out(enter_devs[0]),
.display1(display1),
.display2(display2),
.display3(display3),
.display4(display4),
.display5(display5),
.display6(display6),
.display7(display7),
.display8(display8));

//Para o algoritmo sintetico, em vez de "enter_est" como saida, temos "wake_up"
press_button press_button(
.button(enter), 
.clk(clk), 
.signal(enter_est));

//Para o teste do algoritmo de FIbonacci foram utilizadas as 6 chaves do kit FPGA
//a memoria de instrucoes esta carregada com as instrucoes necessarias para esse teste

//Para o teste das instrucoes ainda nao utilizadas foi utilizado o algoritmo que esta comentado no arquivo "data_inst.v"
//para a sua utilizacao, eh necessario seguir os comentarios presentes nesse modulo "apresentacao.v"

//Para ambos os testes nesse arquivo, foi considerado que os botoes "push_buttons" do FPGA sao ativios em alta
//de acordo com o que eh disponibilizado no FPGA remoto


//o clock de 50 MHz da placa nao foi dividido, esta sendo usado como 50 MHz
//estao sendo utilizados os 8 displays de 7 segmentos como saidas unicas do processador

endmodule 