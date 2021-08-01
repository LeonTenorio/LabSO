module unit_process(
input bios_controll,
input bios_write_pc,
input[31:0] bios_info,
output[31:0] processor_info,
input reg_write,
input mem_write,
input in_req,
input new_out,
input pc_write,
output in_ready,
output reg[31:0] bios_pc,
output reg[31:0] pc,
input[0:31] bios_inst,
input[1:0] pc_orig,
input[1:0] rd_orig,
input[1:0] loc_write,
input[1:0] op_b,
input[2:0] branch_comp,
input[3:0] write_d_sel,
input[3:0] alu_op,
output[0:3] opcode,
output[0:3] operation,
input clk,
input[127:0] dev_in,
output[127:0] dev_out,
input[3:0] enter_in,
output[3:0] enter_out,
input inst_write,
output out_done,
input[3:0] done_out,
output[31:0] k0,
output[31:0] k1,
output[31:0] t0,
output[31:0] t3,
output[2:0] track,
output[4:0] sector,
output[6:0] address_in_sector,
output[31:0] v0, 
output[31:0] s2,
output[31:0] t2,
input async_in_out
);

parameter um = 32'd1;
parameter zero = 32'd0;

//reg[31:0] pc = 32'd0;
reg[0:31] reg_inst;
reg[31:0] write_ra;

wire[3:0] inst4_7;
wire[4:0] rd_select;
wire[0:31] internal_inst;
wire[31:0] read1, read2, prox_pc, wd_select, alu_result, alu_hi, alu_lo, b_select, read, e_data;
wire[4:0] inst4_8, inst8_12, inst13_17, inst18_22;
wire[8:0] inst23_31;
wire[9:0] inst22_31;
//wire[9:0] inst13_22;
wire[13:0] inst18_31;
wire[22:0] inst9_31;

wire[31:0] bc_hi;
wire[31:0] bc_lo;

wire[0:23] lixo1;

reg[31:0] data_inst_address;

reg[31:0] process_pc;

reg[0:31] instruction;

data_inst data_inst(.address(data_inst_address), .write_data(read2), .write(inst_write), .instruction(internal_inst), .clk(clk));

udcpc udcpc(.pc(process_pc), 
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
.inst22_31(inst22_31),
//.inst13_22(inst13_22), 
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
.pc(pc), 
.bios_info(bios_info),
.write_data(wd_select));

bc_registers bc_registers(.rs(inst8_12), 
.rt(inst13_17), 
.srs(inst18_22),
.rd(rd_select), 
.write_data(wd_select), 
.write_hi(alu_hi), 
.write_lo(alu_lo), 
.write_ra(write_ra), 
.read1(read1), 
.read2(read2), 
//.read3(read3),
.reg_write(reg_write), 
.loc_write(loc_write), 
.bc_hi(bc_hi), 
.bc_lo(bc_lo),
.clk(clk),
.k0(k0),
.k1(k1),
.t0(t0),
.t3(t3),
.v0(v0),
.s2(s2),
.t2(t2)
);

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
.mem_write(mem_write), 
.read(read), 
.clk(clk));

in_out_module in_out_module(
.p_data(read1), 
.drs(read2),
.e_data(e_data), 
//.drt(read3),
//.adress(inst13_22), 
//.address(inst23_31),
.adress(inst22_31),
.in_req(in_req), 
.new_out(new_out), 
.in_ready(in_ready), 
.out_ready(out_done),
.dev_in(dev_in), 
.dev_out(dev_out), 
.enter_in(enter_in), 
.enter_out(enter_out),
.done_out(done_out),
.clk(clk),
.track(track),
.sector(sector),
.address_in_sector(address_in_sector),
.async_in_out(async_in_out)
);

always @(clk, bios_controll, pc, bios_pc)
begin
	if(bios_controll)
	begin
		write_ra <= bios_pc + um;
	end
	else
	begin
		write_ra <= pc + um;
	end
end
	

always @(posedge clk)
begin
	if(pc_write==1)
	begin
		if(bios_controll)
		begin
			if(bios_write_pc)
			begin
				pc = read1;
			end
			bios_pc = prox_pc;
		end
		else
		begin
			pc = prox_pc;
		end
	end
end

always @(clk, bios_controll, alu_result, pc)//pc, bios_controll, alu_result
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

always @(clk, bios_controll, bios_pc, pc)//bios_controll, pc, bios_pc
begin
	if(bios_controll)
	begin
		process_pc = bios_pc;
	end
	else
	begin
		process_pc = pc;
	end
end

always @(clk, bios_controll, bios_inst, internal_inst)//bios_controll, bios_inst, internal_inst
begin
	if(bios_controll)
	begin
		instruction = bios_inst;
	end
	else
	begin
		instruction = internal_inst;
	end
end

	assign {opcode, operation} = instruction[0:7];
	assign processor_info = read1;
	
endmodule 