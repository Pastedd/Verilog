`timescale 1ns / 1ps

module step_motor(
    input wire clk,
    input wire reset_n,
    input wire motor_onoff,
    input wire motor_dir,
    output reg [3:0] motor_out //A,B,nA,nB
);
    reg sw_onoff = 1'b0;
    reg sw_dir = 1'b0;
    reg [25:0] count;
    
//    always @ (motor_onoff, sw_onoff) begin
//        if (!motor_onoff)   sw_onoff    <=  ~sw_onoff;
//        else                sw_onoff    <=  sw_onoff;
//    end
//    always @ (motor_dir, sw_dir) begin
//        if (!motor_dir) sw_dir <= ~sw_dir;
//        else            sw_dir <= sw_dir;
//    end
    
    always @ (*) begin
        sw_onoff    =   motor_onoff;
        sw_dir      =   motor_dir;
    end
    
    always @ (posedge clk, negedge reset_n) begin
        if (!reset_n) begin
            motor_out <=4'b0;
            count <= 26'd0;
        end 
        else begin
            if (sw_onoff == 1) begin
                if (count > 26'd2000000 )   count   <=  26'd0;
                else                        count   <=  count + 1;
                case (count)
                    0: begin
                        if(sw_dir)  motor_out <= 4'b1001;
                        else        motor_out <= 4'b1100;
                    end
                    500000: begin
                        if(sw_dir)  motor_out <= 4'b1100;
                        else        motor_out <= 4'b1001;
                    end
                    1000000: begin
                        if(sw_dir)  motor_out <= 4'b0110;
                        else        motor_out <= 4'b0011;
                    end
                    1500000: begin
                        if(sw_dir)      motor_out <= 4'b0011;
                        else            motor_out <= 4'b0110;
                    end
                    default :           motor_out <=  motor_out;
                endcase
            end 
            else begin
                motor_out <= 4'b0;
                count <= 26'd2000000;
            end
        end
    end
endmodule
