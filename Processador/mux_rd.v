module mux_rd(
input[1:0] rd_orig,
input[4:0] inst18_22,
input[4:0] inst13_17,
input[4:0] inst4_8,
input[4:0] inst8_12,
output reg[4:0] rd_select);

parameter zero = 5'd0;

always @(*)
begin
	case(rd_orig)
		2'b00://OR, XOR, AND, NAND, ADD, SUB, NOT, SL, SR, ROT, CMP, CMN, SLT, LOAD, MOV, MFHI, MFLO, IN
			rd_select = inst18_22;
		2'b01://ADDI
			rd_select = inst13_17;
		2'b10://LI
			rd_select = inst4_8;
		2'b11://IN
			rd_select = inst8_12;
		default:
			rd_select = zero;
	endcase
end

endmodule 