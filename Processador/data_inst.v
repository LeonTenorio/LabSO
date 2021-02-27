module data_inst(address, write_data, write, instruction, clk);

input clk;

input write;

input[31:0] write_data;

input[31:0] address;

output reg[0:31] instruction;//DATA INST sera a unica em EM BIG ENDIAN

reg[0:31] registers[1000:0];//As instrucoes armazenadas tambem estao em BIG ENDIAN

always @(posedge clk)
begin	
	if(write)
	begin
		registers[address] <= write_data;
	end
end

always @(negedge clk)
begin
	instruction <= registers[address];
end
endmodule 