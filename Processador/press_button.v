module press_button(input button, input clk, output reg signal);

parameter[31:0] t_alta = 32'd1;
parameter[31:0] t_baixa = 32'd120000000;
parameter[31:0] um = 32'd1;

reg[31:0] cont_baixa = 32'd0;
reg[31:0] cont_alta = 32'd0;

reg[1:0] estado = 2'd0;
reg reg_button;

always @(posedge clk)
begin
	reg_button = button;
end

always @(negedge clk)
begin
	case(estado)
		2'd0:	//Espera de press_button
		begin
			if(reg_button==1)
				estado = 2'd1;
			cont_alta = 32'd0;
			cont_baixa = 32'd0;
		end
		2'd1:	//Conta periodo de alta
		begin
			if(cont_alta<t_alta)
				cont_alta = cont_alta + um;
			else
			begin
				estado = 2'd2;
				cont_alta = 32'd0;
			end
			cont_baixa = 32'd0;
		end
		2'd2:	//Conta periodo de baixa
		begin
			if(cont_baixa<t_baixa)
				cont_baixa = cont_baixa + um;
			else
			begin
				estado = 2'd0;
				cont_baixa = 32'd0;
			end
			cont_alta = 32'd0;
		end
		default:
		begin
			estado = 2'd0;
			cont_baixa = 32'd0;
			cont_alta = 32'd0;
		end
	endcase
end

always @(estado)
begin
	if(estado==2'd1)
		signal = 1;
	else
		signal = 0;
end

endmodule 