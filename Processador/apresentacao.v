module apresentacao(
input clk,
input enter,
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

machine machine(
.clk(clk),
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
.button(enter), 
.clk(clk), 
.signal(enter_est));

assign done_out = {3'd0, enter_est};

endmodule 