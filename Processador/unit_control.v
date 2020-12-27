module unit_control(
output reg reg_write,
output reg mem_write,
output reg in_req,
output reg new_out,
output reg pc_write,
input in_ready,
output reg[1:0] pc_orig,
output reg[1:0] rd_orig,
output reg[2:0] loc_write,
output reg[1:0] op_b,
output reg[2:0] branch_comp,
output reg[2:0] write_d_sel,
output reg[3:0] alu_op,
input[0:3] opcode,
input[0:3] operation,
input wake_up,
input clk,
output reg done_inst);

parameter Inv=3'd0, A=3'd1, B=3'd2, C=3'd3, D=3'd4, E=3'd5, Halt=3'd6;
wire[7:0] opcode_operation;

reg[2:0] estado=Inv;

reg reg_in_ready;
reg reg_wake_up;

always @(negedge clk)
begin
	case(estado)
		Inv:
		begin
			estado = A;
		end
		A:
		begin
			if(opcode_operation==8'd0)//NOOP
				estado = D;
			else if(opcode_operation==8'b01000000)//B
				estado = D;
			else if(opcode_operation==8'b01000001)//BL
				estado = D;
			else if(opcode==4'b0111)//LI
				estado = D;
			else if(opcode==4'b1001)//IN
				estado = E;
			else if(opcode_operation==8'b00000001)//HALT
				estado = Halt;
			else
				estado = B;
		end
		B:
		begin
			if(opcode==4'b0010)//MULT
				estado = C;
			else if(opcode==4'b0011)//DIV
				estado = C;
			else if(opcode==4'b0110)//LOAD
				estado = C;
			else
				estado = D;
		end
		C:
		begin
			estado = D;
		end
		D:
		begin
			estado = A;
		end
		E:
		begin
			if(reg_in_ready==1)
				estado = D;
		end
		Halt:
		begin
			if(reg_wake_up==1)
				estado = D;
		end
		default:	
		begin
			estado = Inv;
		end
	endcase
end

always @(posedge clk)
begin
	if(estado==E)
		reg_in_ready = in_ready;
	else
		reg_in_ready = 0;
	if(estado==Halt)
		reg_wake_up = wake_up;
	else
		reg_wake_up = 0;
	if(estado==D)
		done_inst = 1;
	else
		done_inst = 0;
end

always @(estado, opcode, operation, opcode_operation)
begin
	reg_write = 0;
	mem_write = 0;
	in_req = 0;
	new_out = 0;
	pc_write = 0;

	case(estado)
		A:
		begin
			reg_write = 0;
			mem_write = 0;
			in_req = 0;
			new_out = 0;
			pc_write = 0;
		end
		B:
		begin
			reg_write = 0;
			mem_write = 0;
			in_req = 0;
			new_out = 0;
			pc_write = 0;
		end
		C:
		begin
			reg_write = 0;
			mem_write = 0;
			in_req = 0;
			new_out = 0;
			pc_write = 0;
		end
		D:
		begin
			in_req = 0;
			pc_write = 1;
			
			if(opcode==4'b0001)//Operacoes da ULA com excessao de MULT e DIV
				reg_write = 1;
			else if(opcode==4'b0010)//MULT
				reg_write = 1;
			else if(opcode==4'b0011)//DIV
				reg_write = 1;
			else if(opcode==4'b0110)//LOAD
				reg_write = 1;
			else if(opcode==4'b0111)//LI
				reg_write = 1;
			else if(opcode==4'b1000)//MOV, MFHI, MFLO
				reg_write = 1;
			else if(opcode==4'b1001)//IN
				reg_write = 1;
			else if(opcode_operation==8'b01000001)//BL
				reg_write = 1;
			else if(opcode_operation==8'b10000011)//SETHI
				reg_write = 1;
			else if(opcode_operation==8'b10000100)//SETLO
				reg_write = 1;
			else if(opcode_operation==8'b00000010)//GETPC
				reg_write = 1;
			else
				reg_write = 0;
			
			if(opcode==4'b0101)//STORE
				mem_write = 1;
			else
				mem_write = 0;
			
			if(opcode==4'b1010)//OUT
				new_out = 1;
			else
				new_out = 0;
		end
		E:
		begin
			reg_write = 0;
			mem_write = 0;
			in_req = 1;
			new_out = 0;
			pc_write = 0;
		end
		default:
		begin
			reg_write = 0;
			mem_write = 0;
			in_req = 0;
			new_out = 0;
			pc_write = 0;
		end
	endcase
end

always @(opcode, operation, opcode_operation)
begin
	pc_orig = 2'b00;
	rd_orig = 2'b00;
	loc_write = 3'b000;
	op_b = 2'b00;
	branch_comp = 3'b000;
	write_d_sel = 3'b000;
	alu_op = 4'b0000;
	
	if(opcode_operation==8'b01000000)//B
		pc_orig = 2'b01;
	else if(opcode_operation==8'b01000001)//BL
		pc_orig = 2'b01;
	else if(opcode_operation==8'b01000010)//BR
		pc_orig = 2'b11;
	else if(opcode_operation==8'b01000011)//BEQ
		pc_orig = 2'b10;
	else if(opcode_operation==8'b01000100)//BNE
		pc_orig = 2'b10;
	else if(opcode_operation==8'b01000101)//BLT
		pc_orig = 2'b10;
	else if(opcode_operation==8'b01000110)//BLE
		pc_orig = 2'b10;
	else if(opcode_operation==8'b01000111)//BMT
		pc_orig = 2'b10;
	else if(opcode_operation==8'b01001000)//BME
		pc_orig = 2'b10;
	else//Sequencial
		pc_orig = 2'b00;
		
	if(opcode==4'b0001)//Todas operacoes da ULA
	begin
		if(operation==4'b0101)//ADDI
			rd_orig = 2'b01;
		else
			rd_orig = 2'b00;
	end
	else if(opcode==4'b0110)//LOAD
		rd_orig = 2'b00;
	else if(opcode==4'b1000)//MOV, MFHI, MFLO
		rd_orig = 2'b00;
	else if(opcode_operation==8'b00000010)//GETPC
		rd_orig = 2'b00;
	else if(opcode==4'b1001)//IN
		rd_orig = 2'b11;
	else if(opcode==4'b0111)//LI
		rd_orig = 2'b10;
	else
		rd_orig = 2'b00;
	
	if(opcode==4'b0001)//Todas operacoes da ULA
		loc_write = 3'b000;
	else if(opcode_operation==8'b00000010)//GETPC
		loc_write = 3'b000;
	else if(opcode_operation==8'b01000001)//BL
		loc_write = 3'b010;
	else if(opcode_operation==8'b10000011)//SETHI
		loc_write = 3'b011;
	else if(opcode_operation==8'b10000100)//SETLO
		loc_write = 3'b100;
	else if(opcode==4'b0010)//MULT
		loc_write = 3'b001;
	else if(opcode==4'b0011)//DIV
		loc_write = 3'b001;
	else
		loc_write = 3'b000;
	
	if(opcode==4'b0101)//STORE
		op_b = 2'b01;
	else if(opcode==4'b0110)//LOAD
		op_b = 2'b01;
	else if(opcode_operation==8'b00010101)//ADDI
		op_b = 2'b10;
	else if(opcode_operation==8'b00011000)//SL
		op_b = 2'b11;
	else if(opcode_operation==8'b00011001)//SR
		op_b = 2'b11;
	else
		op_b = 2'b00;
	
	if(opcode==4'b0100)//Todos os saltos
	begin
		case(operation)
			4'b0011://BEQ
				branch_comp = 3'b000;
			4'b0100://BNE
				branch_comp = 3'b001;
			4'b0101://BLT
				branch_comp = 3'b010;
			4'b0110://BLE
				branch_comp = 3'b011;
			4'b0111://BMT
				branch_comp = 3'b100;
			4'b1000://BME
				branch_comp = 3'b101;
			default: branch_comp = 3'b000;
		endcase
	end
	
	if(opcode==4'b0001)//Todas operacoes da ula
		write_d_sel = 3'b000;
	else if(opcode==4'b0110)//LOAD
		write_d_sel = 3'b001;
	else if(opcode==4'b0111)//LI
		write_d_sel = 3'b010;
	else if(opcode_operation==8'b10000000)//MOV
		write_d_sel = 3'b011;
	else if(opcode_operation==8'b10000001)//MFHI
		write_d_sel = 3'b100;
	else if(opcode_operation==8'b10000010)//MFLO
		write_d_sel = 3'b101;
	else if(opcode_operation==8'b10000011)//SETHI
		write_d_sel = 3'b011;
	else if(opcode_operation==8'b10000100)//SETLO
		write_d_sel = 3'b011;
	else if(opcode_operation==8'b00000010)//GETPC
		write_d_sel = 3'b111;
	else if(opcode==4'b1001)//IN
		write_d_sel = 3'b110;
	
	if(opcode==4'b0001)//Todas as operacoes da ULA
	begin
		case(operation)
			4'b0000:	alu_op = 4'b0000;
			4'b0001:	alu_op = 4'b0001;
			4'b0010:	alu_op = 4'b0010;
			4'b0011:	alu_op = 4'b0011;
			4'b0100:	alu_op = 4'b0100;
			4'b0101:	alu_op = 4'b0100;
			4'b0110:	alu_op = 4'b0101;
			4'b0111:	alu_op = 4'b0110;
			4'b1000:	alu_op = 4'b0111;
			4'b1001:	alu_op = 4'b1000;
			4'b1010:	alu_op = 4'b1001;
			4'b1011:	alu_op = 4'b1010;
			4'b1100:	alu_op = 4'b1011;
			4'b1101:	alu_op = 4'b1100;
			default:	alu_op = 4'b0000;
		endcase
	end
	
	if(opcode==4'b0010)//MULT
		alu_op = 4'b1101;
	else if(opcode==4'b0011)//DIV
		alu_op = 4'b1110;
	else if(opcode==4'b0101)//STORE
		alu_op = 4'b0100;
	else if(opcode==4'b0110)//LOAD
		alu_op = 4'b0100;
end

	assign opcode_operation = {opcode,operation};

endmodule 