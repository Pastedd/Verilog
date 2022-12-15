`timescale 1ns / 1ps

module clk_gen(
    input   wire    clk100m,
    output  reg     clk10k=0
);

parameter   count_target10k =   4999;

reg [12:0]  cnt_clk100m=0;
always @ (posedge clk100m) begin
    if(cnt_clk100m >= count_target10k)  cnt_clk100m <= 0;
    else                                cnt_clk100m <= cnt_clk100m + 1;
end

always @ (posedge clk100m) begin
    if(cnt_clk100m >= count_target10k)  clk10k <= ~clk10k;
end

endmodule
