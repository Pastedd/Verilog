module motor_ctrl(
    input   wire    rst,
    input   wire    clk,
    
    input   wire    [2:0]   state,
    input   wire    [2:0]   counting_value,
    
    output  reg     real_motor_onoff,
    output  reg     real_motor_dir
);

parameter   state_idle          =   3'd0;
parameter   state_floor1        =   3'd1;
parameter   state_floor2        =   3'd2;
parameter   state_going_to_1    =   3'd3;
parameter   state_going_to_2    =   3'd4;

always @ (posedge clk) begin
    if(rst) begin
        real_motor_onoff    <=  0;
        real_motor_dir      <=  0;
    end
    else begin
        case(state)
            state_idle: begin
                real_motor_onoff    <=  0;
                real_motor_dir      <=  0;
            end
            state_floor1: begin
                real_motor_onoff    <=  0;
                real_motor_dir      <=  0;            
            end
            state_floor2: begin
                real_motor_onoff    <=  0;
                real_motor_dir      <=  0;            
            end
            state_going_to_1: begin
                if(counting_value ==0) begin
                    real_motor_onoff    <=  0;
                    real_motor_dir      <=  0;  
                end              
                else begin  //during moving time, motor should operate
                    real_motor_onoff    <=  1;
                    real_motor_dir      <=  0;                      
                end
            end
            state_going_to_2: begin
                if(counting_value ==0) begin
                    real_motor_onoff    <=  0;
                    real_motor_dir      <=  0;  
                end              
                else begin  //during moving time, motor should operate in opposite direction compared with state_going_to_1
                    real_motor_onoff    <=  1;
                    real_motor_dir      <=  1;                      
                end
            end
        endcase
    end
end

endmodule
