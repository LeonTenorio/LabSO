module bc_registers(rs, rt, rd, write_data, write_hi, write_lo, write_ra, read1, read2, reg_write, loc_write, bc_hi, bc_lo, clk);

input clk;
input[4:0] rs;
input[4:0] rt;
input[4:0] rd;
input[31:0] write_data;
input[31:0] write_hi;
input[31:0] write_lo;
input[31:0] write_ra;

input reg_write;

input[1:0] loc_write;

reg[31:0] registers[31:0];
reg[31:0] reg_hi;
reg[31:0] reg_lo;

output reg[31:0] read1;
output reg[31:0] read2;
output reg[31:0] bc_hi;
output reg[31:0] bc_lo;

parameter zero=32'b00000000000000000000000000000000;

always @(posedge clk)
begin
	if(reg_write==1)
	begin
		case(loc_write)
			2'b00://Escrita nos 31 registradores normais
			begin
				if(rd<5'b11111)
					registers[rd] = write_data;
			end
			2'b01://Escrita em hi e lo
			begin
				reg_hi = write_hi;
				reg_lo = write_lo;
			end
			2'b10://Escrita em "ra" que eh "registers[31]"
			begin
				registers[5'd31] = write_ra;
			end
			default:
			begin
				registers[rd] = registers[rd];
			end
		endcase
	end
end

always @(negedge clk)
begin
	read1 = registers[rs];
	read2 = registers[rt];
	bc_hi = reg_hi;
	bc_lo = reg_lo;
end

endmodule 