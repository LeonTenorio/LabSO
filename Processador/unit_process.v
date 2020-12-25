module unit_process(
input bios_controll,
input reg_write,
input mem_write,
input in_req,
input new_out,
input pc_write,
output in_ready,
input[1:0] pc_orig,
input[1:0] rd_orig,
input[1:0] loc_write,
input[1:0] op_b,
input[2:0] branch_comp,
input[2:0] write_d_sel,
input[3:0] alu_op,
output[0:3] opcode,
output[0:3] operation,
input clk,
input[127:0] dev_in,
output[127:0] dev_out,
input[3:0] enter_in,
output[3:0] enter_out);

parameter um = 32'd1;
parameter zero = 32'd0;

reg write_mem = 0;
reg write_inst = 0;

reg[31:0] pc;
reg[0:31] reg_inst;
reg[31:0] write_ra;

wire[3:0] inst4_7;
wire[4:0] rd_select;
wire[0:31] instruction;
wire[31:0] read1, read2, prox_pc, wd_select, alu_result, alu_hi, alu_lo, b_select, read, e_data;
wire[4:0] inst4_8, inst8_12, inst13_17, inst18_22;
wire[8:0] inst23_31;
wire[9:0] inst13_22;
wire[13:0] inst18_31;
wire[22:0] inst9_31;

wire[31:0] bc_hi;
wire[31:0] bc_lo;

wire[0:23] lixo1;

initial 
begin
	pc = zero;
end

reg[31:0] data_inst_address;

data_inst data_inst(.address(data_inst_address), .write_data(read2), .write(write_inst), .instruction(instruction), .clk(clk));

udcpc udcpc(.pc(pc), 
.inst(instruction), 
.pc_orig(pc_orig), 
.branch_comp(branch_comp), 
.a(read1), 
.b(read2), 
.prox_pc(prox_pc), 
.inst4_7(inst4_7), 
.inst4_8(inst4_8), 
.inst8_12(inst8_12), 
.inst13_17(inst13_17), 
.inst18_22(inst18_22), 
.inst23_31(inst23_31), 
.inst13_22(inst13_22), 
.inst18_31(inst18_31), 
.inst9_31(inst9_31));

mux_rd mux_rd(.rd_orig(rd_orig), 
.inst18_22(inst18_22), 
.inst13_17(inst13_17), 
.inst4_8(inst4_8), 
.inst8_12(inst8_12),
.rd_select(rd_select));

mux_wd mux_wd(.inst9_31(inst9_31), 
.alu_result(alu_result), 
.read(read), 
.a(read1), 
.e_data(e_data), 
.bc_hi(bc_hi),
.bc_lo(bc_lo),
.write_d_sel(write_d_sel), 
.write_data(wd_select));

bc_registers bc_registers(.rs(inst8_12), 
.rt(inst13_17), 
.rd(rd_select), 
.write_data(wd_select), 
.write_hi(alu_hi), 
.write_lo(alu_lo), 
.write_ra(write_ra), 
.read1(read1), 
.read2(read2), 
.reg_write(reg_write), 
.loc_write(loc_write), 
.bc_hi(bc_hi), 
.bc_lo(bc_lo),
.clk(clk));

mux_op_b mux_op_b(.deslocamento(inst23_31), 
.b(read2), 
.imediate(inst18_31), 
.shift_desloc(inst13_17), 
.op_b(op_b), 
.b_select(b_select));

alu alu(.a(read1), 
.b(b_select), 
.alu_op(alu_op), 
.result(alu_result),
.hi(alu_hi),
.lo(alu_lo));

memory memory(.adress(alu_result), 
.write_data(read2), 
.mem_write(write_mem), 
.read(read), 
.clk(clk));

in_out_module in_out_module(.p_data(read1), 
.e_data(e_data), 
.adress(inst13_22), 
.in_req(in_req), 
.new_out(new_out), 
.in_ready(in_ready), 
.dev_in(dev_in), 
.dev_out(dev_out), 
.enter_in(enter_in), 
.enter_out(enter_out));

always @(pc)
	write_ra <= pc + um;

always @(posedge clk)
begin
	if(pc_write==1)
		pc = prox_pc;
end

always @(bios_controll, mem_write)
begin
	if(bios_controll)
	begin
		if(mem_write)
		begin
			write_mem = 0;
			write_inst = 1;
		end
	end
	else
	begin
		if(mem_write)
		begin
			write_mem = 1;
			write_inst = 0;
		end
	end
end

always @(pc, bios_controll)
begin
	if(bios_controll)
	begin
		data_inst_address = alu_result;
	end
	else
	begin
		data_inst_address = pc;
	end
end

	assign {opcode, operation} = instruction[0:7];
	
endmodule 