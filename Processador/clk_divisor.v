module clk_divisor(
input clk,
input[2:0] low_time,
input[2:0] high_time,
output out_clk
);

parameter um = 3'd1;
parameter zero = 3'd0;

reg[2:0] count = zero;
reg high = 0;

always @(posedge clk)
begin
	count = count + um;
	if(high)
	begin
		if(count==high_time)
		begin
			count = zero;
			high = 0;
		end
	end
	else
	begin
		if(count==low_time)
		begin
			count = zero;
			high = 1;
		end
	end
end

	assign out_clk = high;

endmodule 