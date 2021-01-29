module processador(
input bios_controll,
input bios_write_pc,
input[31:0] bios_info,
output[31:0] processor_info,
output[0:7] opcode_operation,
input clk,
//input wake_up,
output[31:0] bios_pc,
input[0:31] bios_inst,
input[127:0] dev_in,
output[127:0] dev_out,
input[3:0] enter_in,
output[3:0] enter_out,
output done_inst,
input[3:0] done_out);

wire[0:3] opcode, operation;
wire reg_write, mem_write, in_req, pc_write;
wire in_ready;
wire new_out;
wire inst_write;
wire out_done;

wire[1:0] pc_orig, rd_orig, loc_read, op_b;
wire[2:0] branch_comp, write_d_sel, loc_write;
wire[3:0] alu_op;

unit_process unit_process(
.bios_controll(bios_controll),
.bios_write_pc(bios_write_pc),
.bios_info(bios_info),
.processor_info(processor_info),
.reg_write(reg_write),
.mem_write(mem_write),
.in_req(in_req),
.new_out(new_out),
.pc_write(pc_write),
.in_ready(in_ready),
.bios_pc(bios_pc),
.bios_inst(bios_inst),
.pc_orig(pc_orig),
.rd_orig(rd_orig),
.loc_write(loc_write),
.op_b(op_b),
.branch_comp(branch_comp),
.write_d_sel(write_d_sel),
.alu_op(alu_op),
.opcode(opcode),
.operation(operation),
.clk(clk),
.dev_in(dev_in),
.dev_out(dev_out),
.enter_in(enter_in),
.enter_out(enter_out),
.inst_write(inst_write),
.done_out(done_out),
.out_done(out_done));

unit_control unit_control(
.reg_write(reg_write),
.mem_write(mem_write),
.in_req(in_req),
.new_out(new_out),
.pc_write(pc_write),
.in_ready(in_ready),
.pc_orig(pc_orig),
.rd_orig(rd_orig),
.loc_write(loc_write),
.op_b(op_b),
.branch_comp(branch_comp),
.write_d_sel(write_d_sel),
.alu_op(alu_op),
.opcode(opcode),
.operation(operation),
//.wake_up(wake_up),
.inst_write(inst_write),
.clk(clk),
.done_inst(done_inst),
.out_done(out_done));

	assign opcode_operation = {opcode, operation};
	
endmodule 