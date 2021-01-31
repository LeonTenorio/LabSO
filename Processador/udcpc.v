module udcpc(
input[31:0] pc,
input[0:31] inst,
input[1:0] pc_orig,
input[2:0] branch_comp,
input[31:0] a,
input[31:0] b,
output reg[31:0] prox_pc,
output[3:0] inst4_7,
output[4:0] inst4_8,
output[4:0] inst8_12,
output[4:0] inst13_17,
output[4:0] inst18_22,
output[8:0] inst23_31,
//output[9:0] inst13_22,
output[13:0] inst18_31,
output[22:0] inst9_31);//Unidade de divisao e calculo do endereco do program counter

parameter zero = 32'd0;
parameter um = 32'd1;

wire[23:0] inst8_31;
	
always @(*)
begin
	if(pc_orig==2'b00)//Sequencial
		prox_pc = pc + um;
	else if(pc_orig==2'b01)//B, BL
		prox_pc = {8'd0, inst8_31};
	else if(pc_orig==2'b10)//BEQ, BNE, BLT, BLE, BMT, BME
	begin
		case(branch_comp)
			3'b000://BEQ
				begin
					if(a==b)
						prox_pc = {18'd0,inst18_31};
					else
						prox_pc = pc + um;
				end
			3'b001://BNE
				begin
					if(a!=b)
						prox_pc = {18'd0,inst18_31};
					else
						prox_pc = pc + um;
				end
			3'b010://BLT
				begin
					if(a<b)
						prox_pc = {18'd0,inst18_31};
					else
						prox_pc = pc + um;
				end
			3'b011://BLE
				begin
					if(a<=b)
						prox_pc = {18'd0,inst18_31};
					else
						prox_pc = pc + um;
				end
			3'b100://BMT
				begin
					if(a>b)
						prox_pc = {18'd0,inst18_31};
					else
						prox_pc = pc + um;
				end
			3'b101://BME
				begin
					if(a>=b)
						prox_pc = {18'd0,inst18_31};
					else
						prox_pc = pc + um;
				end			

			default: prox_pc = pc + um;
		endcase
	end
	else if(pc_orig==2'b11)//BR
		prox_pc = a;
	else
		prox_pc = pc+um;
end

	assign {inst4_7,inst8_31} = inst[4:31];
	assign {inst4_8,inst9_31} = inst[4:31];
	assign {inst8_12,inst13_17,inst18_31} = inst[8:31];
	assign {inst18_22,inst23_31} = inst[18:31];
	//assign inst13_22 = inst[13:22];
 
endmodule 