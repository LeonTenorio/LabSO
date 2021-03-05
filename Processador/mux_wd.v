module mux_wd(
input[22:0] inst9_31,
input[31:0] alu_result,
input[31:0] read,
input[31:0] a,
input[31:0] e_data,
input[31:0] bc_hi,
input[31:0] bc_lo,
input[31:0] pc,
input[31:0] bios_info,
input[3:0] write_d_sel,
output reg[31:0] write_data);

parameter zero = 32'd0;
parameter extend23 = 9'd0;

always @(*)
begin
	case(write_d_sel)
		4'b0000://OR, XOR, AND,NAND, ADD, ADDI, SUB, NOT, SL, SR, ROT, CMP, CMN, SLT 
			write_data = alu_result;
		4'b0001://LOAD
			write_data = read;
		4'b0010://LI
			write_data = $signed(inst9_31);
		4'b0011://MOV, SETHI, SETLO
			write_data = a;
		4'b0100://MFHI
			write_data = bc_hi;
		4'b0101://MFLO
			write_data = bc_lo;
		4'b0110://IN
			write_data = e_data;
		4'b0111://GETPC
			write_data = pc;
		4'b1000:
			write_data = bios_info;
		default:
			write_data = zero;
	endcase
end

endmodule 
