module in_out_module(
input[31:0] p_data, 
input[31:0] drs,
//input[31:0] drt,
output reg[31:0] e_data, 
input[8:0] address,
input in_req, 
input new_out, 
output reg in_ready,
output reg out_done,
input[127:0] dev_in,
output reg[127:0] dev_out,
input[3:0] enter_in,
output reg[3:0] enter_out,
input[3:0] done_out,
input clk);//Terao 5 dispositivos de entrada e 5 dispositivos de saida 
//O dispositivo numero 5 serah o disco, tanto para entrada quanto para saida

parameter disk_clk_high_time = 3'd5;
parameter disk_clk_low_time = 3'd5;

reg[5:0] disp;
reg disk_read = 0;
reg disk_write = 0;

wire[31:0] disk_read_data;
wire[4:0] disps_enter_in;
wire[4:0] disps_done_out;
wire disk_read_done;
wire disk_write_done;
wire disk_clk;

wire[2:0] disk_track;
wire[4:0] disk_sector;
wire[6:0] disk_address_in_sector;
wire[16:0] lixo;

disk_controller disk_controller(
.track(disk_track),
.sector(disk_sector),
.address_in_sector(disk_address_in_sector),
.read(disk_read),
.write(disk_write),
.write_value(p_data),
.read_value(disk_read_data),
.read_done(disk_read_done),
.write_done(disk_write_done),
.clk(disk_clk)
);

clk_divisor clk_divisor(
.clk(clk),
.low_time(disk_clk_low_time),
.high_time(disk_clk_high_time),
.out_clk(disk_clk)
);

always @(posedge disps_enter_in[disp])//analise entrada de dados
begin
	if(in_req==1)
	begin
		if(disp<5'd4)
		begin
			e_data <= dev_in[address +: 32];
		end
		else
		begin
			e_data <= disk_read_data;
		end
	end
end

always @(disps_done_out[disp], disp, new_out)//sinalizador de saida de dados concluida
begin
	if(new_out)
		out_done <= disps_done_out[disp];
	else
		out_done <= 0;
end

always @(disps_enter_in[disp], disp, in_req)//sinalizador de entrada de dados concluida
begin
	if(in_req==1)
		in_ready <= disps_enter_in[disp];
	else
		in_ready <= 0;
end

always @(posedge new_out)//envio de saida de dados
begin
	dev_out[address +: 32] <= p_data;
end

always @(disp, in_req)//disk read
begin
	disk_read = 0;
	if(disp==5'd4)
	begin
		if(in_req==1)
		begin
			disk_read = 1;
		end
	end
end 

/*always @(posedge clk)
begin
	done_out = 0;
	if(new_out)
	begin
		if(disp<5'd4)
		begin
			done_out = 1;
			dev_out[address +: 32] <= p_data;
		end
		else
		begin
			if(disk_write_done)
			begin
				done_out = 1;
			end
		end
	end
end*/

always @(new_out,disp)
begin
	case(disp)
		5'd0:
		begin
			enter_out[0] = new_out;
			enter_out[1] = 0;
			enter_out[2] = 0;
			enter_out[3] = 0;
			//enter_out[4] = 0;
			disk_write = 0;
		end
		5'd1:
		begin
			enter_out[0] = 0;
			enter_out[1] = new_out;
			enter_out[2] = 0;
			enter_out[3] = 0;
			//enter_out[4] = 0;
			disk_write = 0;
		end
		5'd2:
		begin
			enter_out[0] = 0;
			enter_out[1] = 0;
			enter_out[2] = new_out;
			enter_out[3] = 0;
			//enter_out[4] = 0;
			disk_write = 0;
		end
		5'd3:
		begin
			enter_out[0] = 0;
			enter_out[1] = 0;
			enter_out[2] = 0;
			enter_out[3] = new_out;
			//enter_out[4] = 0;
			disk_write = 0;
		end
		5'd4:
		begin
			enter_out[0] = 0;
			enter_out[1] = 0;
			enter_out[2] = 0;
			enter_out[3] = 0;
			//enter_out[4] = new_out;
			disk_write = 1;
		end
		default:
		begin
			enter_out[0] = 0;
			enter_out[1] = 0;
			enter_out[2] = 0;
			enter_out[3] = 0;
			//enter_out[4] = 0;
			disk_write = 0;
		end
	endcase
end

always @(address)
begin
	disp = 5'd0;
	case(address)
		10'd0:	disp = 5'd0;
		10'd32:	disp = 5'd1;
		10'd64:	disp = 5'd2;
		10'd96:	disp = 5'd3;
		10'd128: disp = 5'd4;
		default:	disp = 5'd0;
	endcase
end

	assign disps_enter_in = {enter_in, disk_read_done};
	assign {lixo, disk_track, disk_sector, disk_address_in_sector} = drs;
	assign disps_done_out = {done_out, disk_write_done};

endmodule 