module alu(a, b, alu_op, result, hi, lo);

input[31:0] a;
input[31:0] b;
input[3:0] alu_op;

parameter zero=32'b00000000000000000000000000000000;
parameter um=32'b00000000000000000000000000000001;

output reg[31:0] result;
output reg[31:0] hi;
output reg[31:0] lo;

reg[31:0] abs;

always @(*)
begin
	result = zero;
	hi = zero;
	lo = zero;
	abs = zero;
	
	case(alu_op)
		4'b0000:	//OR
			result = a | b;
		4'b0001:	//XOR
			result = a ^ b;
		4'b0010:	//AND	
			result = a & b;
		4'b0011:	//NAND
			result = ~(a & b);
		4'b0100:	//ADD, ADDI
			result = a + b;
		4'b0101:	//SUB
			result = a - b;
		4'b0110:	//NOT
			result = ~a;
		4'b0111:	//SL
			result = a << b;
		4'b1000:	//SR
			result = a >> b;
		4'b1001:	//ROT
			result = {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15],a[16],a[17],a[18],a[19],a[20],a[21],a[22],a[23],a[24],a[25],a[26],a[27],a[28],a[29],a[30],a[31]};
		4'b1010:	//CMP
		begin
			if(a==b)
				result = um;
			else
				result = zero;
		end
		4'b1011://CMN	
			begin
				if(a==b)
					result = um;
				else if(a[31]==1)
				begin
					abs = -b;
					if(abs==a)
						result = um;
					else
						result = zero;
				end
				else if(b[31]==1)
				begin
					abs = -a;
					if(b==abs)
						result = um;
					else
						result = zero;
				end
				else
					result = zero;
			end
		4'b1100://SLT
		begin
			if(a < b)
				result = um;
			else
				result = zero;
		end
		4'b1101://MULT
			{hi, lo} = a*b;
		4'b1110://DIV	
			begin
				hi = a%b;
				lo = a/b;
			end
		default:	
			begin
				result = zero;
			end
	endcase
end
endmodule 
