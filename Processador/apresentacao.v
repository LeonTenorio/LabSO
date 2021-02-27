module apresentacao(
input clk,
input enter,
output bios_controll,
output[6:0] display1, 
output[6:0] display2, 
output[6:0] display3,
output[6:0] display4,
output[6:0] display5,
output[6:0] display6,
output[6:0] display7,
output[6:0] display8
);

wire[127:0] dev_out;
wire[3:0] done_out;
wire enter_est;
wire[3:0] enter_out;

reg process_clk = 0;

processador processador(
.bios_controll(0),
.clk(process_clk),
.dev_out(dev_out),
.enter_out(enter_out),
.done_out(done_out)
);


saida_display saida_display(
.clk(process_clk),
.dado(dev_out[25:0]),
.enter_out(enter_out[0]),
.display1(display1),
.display2(display2),
.display3(display3),
.display4(display4),
.display5(display5),
.display6(display6),
.display7(display7),
.display8(display8));

press_button press_button(
.button(~enter), 
.clk(clk), 
.signal(enter_est));

assign done_out = {3'd0, enter_est};

always @(posedge clk)
begin
	process_clk = ~process_clk;
end

endmodule 


/*module apresentacao(
input clk,
input enter,
output bios_controll,
output bios_state_led2,
output bios_state_led1,
output[6:0] display1, 
output[6:0] display2, 
output[6:0] display3,
output[6:0] display4,
output[6:0] display5,
output[6:0] display6,
output[6:0] display7,
output[6:0] display8
);

wire[127:0] dev_out;
wire[3:0] done_out;
wire enter_est;
wire[3:0] enter_out;

wire[1:0] bios_state;

machine machine(
.clk(clk),
.bios_controll(bios_controll),
.dev_out(dev_out),
.enter_out(enter_out),
.done_out(done_out)
);

saida_display saida_display(
.clk(clk),
.dado(dev_out[25:0]),
.enter_out(enter_out[0]),
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
.button(~enter), 
.clk(clk), 
.signal(enter_est));

assign done_out = {3'd0, enter_est};
assign {bios_state_led2, bios_state_led1} = bios_state;

endmodule */