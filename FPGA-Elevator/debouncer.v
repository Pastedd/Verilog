module debouncer(
	input 	wire 			rst,
	input 	wire 			clk,
	input 	wire			in,
	output	reg				out
);

parameter DELAY = 40;

reg in_reg;
reg [18:0] cnt;

wire cnt_clr;
wire cnt_expire;

assign cnt_clr = (in != in_reg);
assign cnt_expire = (cnt == DELAY);

always @ (posedge clk or posedge rst) begin
	if(rst) in_reg <= 1'b0;
	else in_reg <= in;
end

always @ (posedge clk or posedge rst) begin
	if(rst) cnt <= 19'b0000000000000000000;
	else begin
		case({cnt_expire, cnt_clr})
			2'b00: cnt <= cnt+19'b0000000000000000001;            
			2'b01: cnt <= 0;
			2'b10: cnt <= cnt;
			2'b11: cnt <= 0;
		endcase
	end
end

always @ (posedge clk or posedge rst) begin
	if(rst) out <= 1'b0;
	else begin
		if(cnt_expire) out <= in_reg;
		else out <= out;
	end
end

endmodule
