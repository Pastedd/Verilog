`timescale 1ns / 1ps

module counting(
    input   wire    rst,
    input   wire    clk,    //10kHz
    
    input   wire    [2:0]   btn_stable_shot,
    
    input   wire    [2:0]   state,
    
    output  reg     [2:0]   counting_value
);
    
parameter   state_idle          =   3'd0;
parameter   state_floor1        =   3'd1;
parameter   state_floor2        =   3'd2;
parameter   state_going_to_1    =   3'd3;
parameter   state_going_to_2    =   3'd4;

reg [15:0]  cnt_clk;

always @ (posedge clk) begin
    if(rst) cnt_clk <= 16'd50000;
    else begin
        case(state)
            state_idle: cnt_clk <= 16'd50000;
            state_floor1: begin
                if(btn_stable_shot[2] | btn_stable_shot[1]) cnt_clk <= 16'd50000;
                else if(cnt_clk == 0)                       cnt_clk <= 16'd0;
                else                                        cnt_clk <= cnt_clk - 1;
            end
            state_floor2: begin
                if(btn_stable_shot[2] | btn_stable_shot[0]) cnt_clk <= 16'd50000;
                else if(cnt_clk == 0)                       cnt_clk <= 16'd0;
                else                                        cnt_clk <= cnt_clk - 1;
            end
            state_going_to_1: begin
                if(cnt_clk == 0)    cnt_clk <=  16'd50000;
                else                cnt_clk <=  cnt_clk-1;
            end
            state_going_to_2: begin
                if(cnt_clk == 0)    cnt_clk <=  16'd50000;
                else                cnt_clk <=  cnt_clk-1;
            end
            default: cnt_clk <= 16'd50000;
        endcase
    end
end

always @ (*) begin
    if(cnt_clk > 40000)         counting_value  =   3'd5;
    else if(cnt_clk > 30000)    counting_value  =   3'd4;
    else if(cnt_clk > 20000)    counting_value  =   3'd3;
    else if(cnt_clk > 10000)    counting_value  =   3'd2;
    else if(cnt_clk > 0)        counting_value  =   3'd1;
    else                        counting_value  =   3'd0;
end

endmodule
