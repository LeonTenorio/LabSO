module machine(
input clk,
output[31:0] bios_pc,
output[31:0] process_pc,
input[127:0] dev_in,
output[127:0] dev_out,
input[3:0] enter_in,
output[3:0] enter_out,
input[3:0] done_out,
output done_inst,
output bios_controll,
output[0:7] opcode_operation,
output[2:0] controll_state,
output out_done,
output[31:0] k0,
output[31:0] k1,
output[4:0] devs_done_out,
output[4:0] devs_enter_in,
output[1:0] output_state,
output[1:0] input_state
);

//wire bios_controll;
wire[31:0] bios_info;
wire[31:0] processor_info;
//wire[0:7] opcode_operation;
wire[0:31] bios_inst;
//wire done_inst;

processador processador(
.bios_controll(bios_controll),
.bios_info(bios_info),
.processor_info(processor_info),
.opcode_operation(opcode_operation),
.clk(clk),
.bios_pc(bios_pc),
.process_pc(process_pc),
.bios_inst(bios_inst),
.dev_in(dev_in),
.dev_out(dev_out),
.enter_in(enter_in),
.enter_out(enter_out),
.done_out(done_out),
.done_inst(done_inst),
.controll_state(controll_state),
.out_done(out_done),
.k0(k0),
.k1(k1),
.devs_done_out(devs_done_out),
.devs_enter_in(devs_enter_in),
.output_state(output_state),
.input_state(input_state)
);

bios_module bios_module(
.done_inst(done_inst),
.clk(clk),
.pc(bios_pc),
.processor_info(processor_info),
.processor_opcode_operation(opcode_operation),
.instruction(bios_inst),
.controll(bios_controll),
.bios_info(bios_info)
);

endmodule 