module memory(adress, write_data, mem_write, read, clk);

input[31:0] adress;
input[31:0] write_data;
input mem_write;
input clk;

output reg[31:0] read;

reg[31:0] data[4095:0];

always @(posedge clk)
begin
	if(mem_write==1)
		data[adress] <= write_data;
end

always @(negedge clk)
begin
	read <= data[adress];
end

endmodule 