`timescale 1ns / 1ps

module top(
    input   wire    clk100m,        //100mhz clock
    input   wire    reset,            //btn3
    input   wire    [2:0]   btn,    //btn2~0
        
    output  wire    [3:0]   fnd_com,
    output  wire    [7:0]   fnd_data,
    
    output  wire    [3:0]   motor_out,
    
    output  wire    [3:0]   test_led
);
//----------- led for test ----------
assign  test_led[3] = rst;
assign  test_led[2:0]   =   state;


wire    rst;
assign  rst =   ~reset;

wire    clk10k;
wire    [2:0]  btn_stable;

wire    [2:0] btn_stable_shot;
wire    [2:0]   state;
wire    [2:0]   counting_value;

wire            real_motor_onoff;
wire            real_motor_dir;

clk_gen clk_gen(.clk100m(clk100m), .clk10k(clk10k));

debouncer debouncer0(.rst(rst), .clk(clk10k), .in(~btn[0]), .out(btn_stable[0]));   //for stable btn signal
debouncer debouncer1(.rst(rst), .clk(clk10k), .in(~btn[1]), .out(btn_stable[1]));
debouncer debouncer2(.rst(rst), .clk(clk10k), .in(~btn[2]), .out(btn_stable[2]));

oneshot oneshot0(.clk(clk10k), .in(btn_stable[0]), .tick(btn_stable_shot[0]));      //for short pulse
oneshot oneshot1(.clk(clk10k), .in(btn_stable[1]), .tick(btn_stable_shot[1]));
oneshot oneshot2(.clk(clk10k), .in(btn_stable[2]), .tick(btn_stable_shot[2]));

state_machine state_machine(.rst(rst), .clk(clk10k), .btn_stable_shot(btn_stable_shot), .counting_value(counting_value), .state(state));    //state machine

counting counting(.rst(rst), .clk(clk10k), .btn_stable_shot(btn_stable_shot), .state(state), .counting_value(counting_value));  //5 second counting generator

fnd_ctrl fnd_ctrl(.rst(rst), .clk(clk10k), .state(state), .counting_value(counting_value), .fnd_com(fnd_com), .fnd_data(fnd_data)); //7 segment controller

motor_ctrl motor_ctrl(.rst(rst), .clk(clk10k), .state(state), .counting_value(counting_value), .real_motor_onoff(real_motor_onoff), .real_motor_dir(real_motor_dir));   //step motor control signal gen

step_motor step_motor(.clk(clk100m), .reset_n(~rst), .motor_onoff(real_motor_onoff), .motor_dir(real_motor_dir), .motor_out(motor_out));    //step motor control

endmodule
