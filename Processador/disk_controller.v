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

reg[31:0] registers[14:0];

parameter prepare_cycles = 5'd3;
parameter um = 5'd1;

reg prepared = 0;
reg[4:0] preparing_cout = 5'd0;

always @(negedge clk)
begin
	read_done = 0;
	if(prepared)
	begin
		if(read)
		begin
			read_value <= registers[{track, sector, address_in_sector}];
			read_done = 1;
		end
	end
end

always @(posedge clk)
begin
	write_done = 0;
	if(prepared)
	begin
		if(write)
		begin
			registers[{track, sector, address_in_sector}] <= write_value;
			write_done = 1;
		end
	end
	else
	begin
		preparing_cout = preparing_cout + um;
		
		registers[0] = {1'b1, 1'b0, 1'b0, 1'b0, 12'b000000000000, 8'b00000001, 8'd8};
		registers[1] = {4'b0100, 4'b0000, 24'd2};
		//.main
		registers[2] = {4'b0111, 5'b11100, 23'b00000000000000001100101};
		registers[3] = {4'b1010, 4'b0000, 5'b11100, 5'b00000, 5'b00000, 9'b000000000};
		registers[4] = {4'b1000, 4'b0000, 5'b00000, 5'b00000, 5'b11100, 9'b000000000};
		registers[5] = {4'b0111, 5'b11101, 23'd8};
		registers[6] = {4'b0000, 4'b0001, 24'b000000000000000000000000};
		registers[7] = {32'b11111111111111111111111111111111};
		//.done
	end
	if(preparing_cout >= prepare_cycles)
	begin
		prepared = 1;
	end
end

endmodule 