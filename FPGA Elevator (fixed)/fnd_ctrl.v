module fnd_ctrl(
    input   wire    rst,
    input   wire    clk,
    input   wire    [2:0]   state,
    input   wire    [2:0]   counting_value,    
    
    output  reg     [3:0]   fnd_com,
    output  reg     [7:0]   fnd_data
);
    
parameter   state_idle          =   3'd0;
parameter   state_floor1        =   3'd1;
parameter   state_floor2        =   3'd2;
parameter   state_going_to_1    =   3'd3;
parameter   state_going_to_2    =   3'd4;

parameter   seg7_print0 =   8'b00111111;
parameter   seg7_print1 =   8'b00000110;
parameter   seg7_print2 =   8'b01011011;
parameter   seg7_print3 =   8'b01001111;
parameter   seg7_print4 =   8'b01100110;
parameter   seg7_print5 =   8'b01101101;
parameter   seg7_print6 =   8'b01111101;
parameter   seg7_print7 =   8'b00100111;
parameter   seg7_print8 =   8'b01111111;
parameter   seg7_print9 =   8'b01101111;
parameter   seg7_print_nothing  =   8'b00000000;

parameter   seg7_print_top_square       =   8'b01100011;
parameter   seg7_print_bottom_square    =   8'b01011100;
parameter   seg7_print_large_square     =   8'b00111111;

reg [7:0]   seg_print[0:3];
always @ (*) begin  //converting the real value to 7segment led configuration data
    seg_print[0]    =   seg7_print_nothing;
    
    if(counting_value > 4)          seg_print[1]    =   seg7_print5;
    else if(counting_value > 3)     seg_print[1]    =   seg7_print4;
    else if(counting_value > 2)     seg_print[1]    =   seg7_print3;
    else if(counting_value > 1)     seg_print[1]    =   seg7_print2;
    else if(counting_value > 0)     seg_print[1]    =   seg7_print1;
    else                            seg_print[1]    =   seg7_print_nothing;
    
    case(state)
        state_idle:         seg_print[2]    =   seg7_print_nothing;
        state_floor1:       seg_print[2]    =   seg7_print_large_square;
        state_floor2:       seg_print[2]    =   seg7_print_large_square;
        state_going_to_1:   seg_print[2]    =   seg7_print_bottom_square;
        state_going_to_2:   seg_print[2]    =   seg7_print_top_square;
        default:            seg_print[2]    =   seg7_print_nothing;
    endcase
    
    case(state)
        state_idle:         seg_print[3]    =   seg7_print1;
        state_floor1:       seg_print[3]    =   seg7_print1;
        state_floor2:       seg_print[3]    =   seg7_print2;
        state_going_to_1:   seg_print[3]    =   seg7_print2;
        state_going_to_2:   seg_print[3]    =   seg7_print1;
        default:            seg_print[3]    =   seg7_print_nothing;
    endcase
end

always @ (posedge clk) begin    //fnd_com rotation for showing segment led one by one very fast 
    if(rst) fnd_com <=  4'b0111;
    else begin
        case(fnd_com)
            4'b0111:    fnd_com <=  4'b1011;
            4'b1011:    fnd_com <=  4'b1101;
            4'b1101:    fnd_com <=  4'b1110;
            4'b1110:    fnd_com <=  4'b0111;
            default:    fnd_com <=  4'b0111;
        endcase
    end
end

always @ (*) begin
    case(fnd_com)
        4'b0111:    fnd_data    =   seg_print[3];
        4'b1011:    fnd_data    =   seg_print[2];
        4'b1101:    fnd_data    =   seg_print[1];
        4'b1110:    fnd_data    =   seg_print[0];
        default:    fnd_data    =   seg7_print_nothing;
    endcase
end

endmodule
