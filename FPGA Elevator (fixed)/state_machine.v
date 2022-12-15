`timescale 1ns / 1ps

module state_machine(
    input   wire    rst,
    input   wire    clk,
    
    input   wire    [2:0]   btn_stable_shot,
    input   wire    [2:0]   counting_value,
    output  reg     [2:0]   state
);

parameter   state_idle          =   3'd0;
parameter   state_floor1        =   3'd1;
parameter   state_floor2        =   3'd2;
parameter   state_going_to_1    =   3'd3;
parameter   state_going_to_2    =   3'd4;

always @ (posedge clk) begin
    if(rst) state   <=  state_idle;
    else begin
        case(state)
            state_idle: begin
                if(btn_stable_shot[0])      state   <=  state_floor1;
                else if(btn_stable_shot[1]) state   <=  state_going_to_2;
            end
            state_floor1: begin                
                if(btn_stable_shot[1] & (counting_value == 0))      state   <=  state_going_to_2;
            end
            state_floor2: begin
                if(btn_stable_shot[0] & (counting_value == 0))      state   <=  state_going_to_1;
            end
            state_going_to_1: begin
                if(counting_value == 0)     state   <=  state_floor1;
            end
            state_going_to_2: begin
                if(counting_value == 0)     state   <=  state_floor2;
            end
            default: state  <=  state_idle;
        endcase
    end
end

endmodule
