module processador(
input bios_controll,
input clk,
input wake_up,
input[127:0] dev_in,
output[127:0] dev_out,
input[3:0] enter_in,
output[3:0] enter_out,
output done_inst);

wire[0:3] opcode, operation;
wire reg_write, mem_write, in_req, pc_write;
wire in_ready;
wire new_out;	

wire[1:0] pc_orig, rd_orig, loc_read, op_b;
wire[2:0] branch_comp, write_d_sel, loc_write;
wire[3:0] alu_op;

unit_process unit_process(
.bios_controll(bios_controll),
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
.clk(clk),
.dev_in(dev_in),
.dev_out(dev_out),
.enter_in(enter_in),
.enter_out(enter_out));

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
.wake_up(wake_up),
.clk(clk),
.done_inst(done_inst));
	
endmodule 