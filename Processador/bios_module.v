module bios_module(
input clk,
input done_inst,
input[31:0] pc,
input[31:0] processor_info,
input[0:7] processor_opcode_operation,
output reg[0:31] instruction,
output reg controll,
output reg[31:0] bios_info
);

parameter MILLIS_PARAM = 16'd50000;
parameter MAX_VALUE = 33'd4294967296;

parameter INV=2'd0, BIOSEXEC=2'd1, PROCESSEXEC=2'd2, PROCESSINT=2'd3;//Declaracao dos estados da BIOS

reg[1:0] state = INV;

reg[0:31] registers[255:0];//As instrucoes armazenadas tambem estao em BIG ENDIAN

reg lock_quantum = 0;
reg release_exec = 0;
reg program_done = 0;

reg[31:0] quantum = 32'd0;
reg[31:0] reg_quantum = 32'd0;

reg[31:0] millis_time = 32'd0;
reg[31:0] reg_millis_time = 32'd0;

always @(posedge clk)
begin
	//Carregamento da minha memoria de programa para a BIOS
end

always @(negedge clk)
begin
	instruction = registers[pc];
end

always @(posedge clk)//No meio do clock posso avaliar o que fazer com as instrucoes e dados do processador
begin
	release_exec = 0;
	program_done = 0;
	case(processor_opcode_operation)
		8'b10110001: //LOCK
		begin
			lock_quantum = 1;
		end
		8'b10110010: //RELEASE
		begin	
			lock_quantum = 0;
		end
		8'b10110101: //BIOSINT
		begin
			release_exec = 1;
		end
		8'b10110100: //SETQUANTUM
		begin
			quantum = processor_info;
		end
		8'b10110000: //GETTIME
		begin
			bios_info = millis_time;
		end
		8'b10110011: //GETQUANTUM
		begin
			bios_info = reg_quantum;
		end
		8'b00000001: //HALT
		begin
			program_done = 1;
		end
		default:
		begin
			
		end
	endcase
end

always @(negedge clk)//Troca de estados da BIOS
begin
	case(state)
		INV:
		begin
			state = BIOSEXEC;
		end
		BIOSEXEC:
		begin
			if(release_exec && done_inst)
			begin
				state = PROCESSEXEC;
			end
		end
		PROCESSEXEC:
		begin
			if(program_done)
			begin
				state = PROCESSINT;
			end
			else if(reg_quantum >= quantum)
			begin
				if(lock_quantum==0)
				begin
					state = PROCESSINT;
				end
			end
		end
		PROCESSINT:
		begin
			if(done_inst)
			begin
				state = BIOSEXEC;
			end
		end
	endcase
	
	case(state)
		BIOSEXEC:
		begin
			controll = 1;
		end
		default:
		begin
			controll = 0;
		end
	endcase
end

always @(posedge clk)//Contadores de quantum e tempo de execucao
begin
	if(state==INV)
	begin
		reg_quantum = 32'd0;
		millis_time = 32'd0;
		reg_millis_time = 32'd0;
	end
	else
	begin
		reg_millis_time = reg_millis_time + 32'd1;
		if(reg_millis_time >= MILLIS_PARAM)
		begin
			millis_time = millis_time + 32'd1;
			reg_millis_time = 32'd0;
		end
		
		case(state)
			BIOSEXEC:
			begin
				quantum = 32'd0;
				reg_quantum = 32'd0;
			end
			PROCESSEXEC:
			begin
				if(reg_quantum < MAX_VALUE)
				begin
					reg_quantum = reg_quantum + 32'd1;
				end
			end
			PROCESSINT:
			begin
				if(reg_quantum < MAX_VALUE)
				begin
					reg_quantum = reg_quantum + 32'd1;
				end
			end
			default:
			begin
				reg_quantum = 32'd0;
			end
		endcase
	end
end

endmodule 