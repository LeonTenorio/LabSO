module in_out_module(
input[31:0] p_data, 
output reg[31:0] e_data, 
input[9:0] adress,
input in_req, 
input new_out, 
output reg in_ready,
input[127:0] dev_in,
output reg[127:0] dev_out,
input[3:0] enter_in,
output reg[3:0] enter_out);//Terao 4 dispositivos de entrada e 6 dispositivos de saida no maximo

reg[4:0] disp;

always @(posedge enter_in[disp])
begin
	if(in_req==1)
		e_data <= dev_in[adress +: 32];
end

always @(enter_in[disp], disp, in_req)
begin
	if(in_req==1)
		in_ready <= enter_in[disp];
	else
		in_ready <= 0;
end

always @(posedge new_out)
begin
	dev_out[adress +: 32] <= p_data;
end

always @(new_out,disp)
begin
	case(disp)
		5'd0:
		begin
			enter_out[0] = new_out;
			enter_out[1] = 0;
			enter_out[2] = 0;
			enter_out[3] = 0;
		end
		5'd1:
		begin
			enter_out[0] = 0;
			enter_out[1] = new_out;
			enter_out[2] = 0;
			enter_out[3] = 0;
		end
		5'd2:
		begin
			enter_out[0] = 0;
			enter_out[1] = 0;
			enter_out[2] = new_out;
			enter_out[3] = 0;
		end
		5'd3:
		begin
			enter_out[0] = 0;
			enter_out[1] = 0;
			enter_out[2] = 0;
			enter_out[3] = new_out;
		end
		default:
		begin
			enter_out[0] = 0;
			enter_out[1] = 0;
			enter_out[2] = 0;
			enter_out[3] = 0;
		end
	endcase
end

always @(adress)
begin
	disp = 5'd0;
	case(adress)
		10'd0:	disp = 5'd0;
		10'd32:	disp = 5'd1;
		10'd64:	disp = 5'd2;
		10'd96:	disp = 5'd3;
		default:	disp = 5'd0;
	endcase
end

endmodule 