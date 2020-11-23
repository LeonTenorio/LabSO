module display(numero,display);
input[3:0] numero;
output reg[6:0] display;
always @(numero)
begin
	case (numero)
		4'b0000: display =7'b1000000;
		4'b0001: display =7'b1111001;
		4'b0010: display =7'b0100100;
		4'b0011: display =7'b0110000;
		4'b0100: display =7'b0011001;
		4'b0101: display =7'b0010010;
		4'b0110: display =7'b0000010;
		4'b0111: display =7'b1111000;
		4'b1000: display =7'b0000000;
		4'b1001: display =7'b0011000;
		default: display = 7'b1111111;
	endcase
end
endmodule
	