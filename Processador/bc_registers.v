module bc_registers(rs, rt, srs, rd, write_data, write_hi, write_lo, write_ra, read1, read2, reg_write, loc_write, bc_hi, bc_lo, clk, k0, k1);

input clk;
input[4:0] rs;
input[4:0] rt;
input[4:0] srs;
input[4:0] rd;
input[31:0] write_data;
input[31:0] write_hi;
input[31:0] write_lo;
input[31:0] write_ra;

input reg_write;

input[2:0] loc_write;

reg[31:0] registers[31:0];
reg[31:0] reg_hi;
reg[31:0] reg_lo;

output reg[31:0] read1;
output reg[31:0] read2;
//output reg[31:0] read3;
output reg[31:0] bc_hi;
output reg[31:0] bc_lo;

output reg[31:0] k0;
output reg[31:0] k1;

parameter zero=32'b00000000000000000000000000000000;

always @(posedge clk)
begin
	if(reg_write==1)
	begin
		case(loc_write)
			3'b000://Escrita nos 31 registradores normais
			begin
				registers[rd] = write_data;
			end
			3'b001://Escrita em hi e lo
			begin
				reg_hi = write_hi;
				reg_lo = write_lo;
			end
			3'b010://Escrita em "ra" que eh por BL
			begin
				registers[5'd31] = write_ra;
			end
			3'b011://Escrita em HI por SETHI
			begin
				reg_hi = write_data;
			end
			3'b100://Escrita em LO por SETLO
			begin
				reg_lo = write_data;
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
	//read3 = registers[srs];
	bc_hi = reg_hi;
	bc_lo = reg_lo;
	k0 = registers[5'd28];
	k1 = registers[5'd29];
end

endmodule 