`timescale 1ns / 1ps

module oneshot(
    input   wire    clk,
    input   wire    in,
    output  reg     tick
);
    reg in_buf1; //generate pulse signal by using 1 delayed buffer
    
    always @ (posedge clk) begin
        if (in && !in_buf1) tick <= 1'b1;
        else tick <= 1'b0;
        
        in_buf1 <= in;
    end
endmodule
