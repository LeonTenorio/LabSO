module mux_wd(
input[22:0] inst9_31,
input[31:0] alu_result,
input[31:0] read,
input[31:0] a,
input[31:0] e_data,
input[31:0] bc_hi,
input[31:0] bc_lo,
input[2:0] write_d_sel,
output reg[31:0] write_data);

parameter zero = 32'd0;
parameter extend23 = 9'd0;

always @(*)
begin
	case(write_d_sel)
		3'b000://OR, XOR, AND,NAND, ADD, ADDI, SUB, NOT, SL, SR, ROT, CMP, CMN, SLT 
			write_data = alu_result;
		3'b001://LOAD
			write_data = read;
		3'b010://LI
			write_data = $signed(inst9_31);
		3'b011://MOV
			write_data = a;
		3'b100://MFHI
			write_data = bc_hi;
		3'b101://MFLO
			write_data = bc_lo;
		3'b110://IN
			write_data = e_data;
		default:
			write_data = zero;
	endcase
end

endmodule 