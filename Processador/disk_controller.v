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

reg[31:0] values[14:0];

always @(negedge clk)
begin
	read_done = 0;
	if(read)
	begin
		read_value <= values[{track, sector, address_in_sector}];
		read_done = 1;
	end
end

always @(posedge clk)
begin
	write_done = 0;
	if(write)
	begin
		values[{track, sector, address_in_sector}] <= write_value;
		write_done = 1;
	end
end


endmodule