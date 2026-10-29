
`include "MC.v"
`include "BTN_DEB.v"
`include "Pulse_GEN.v"

module MC_TOP(
    input clk, rst,
    input [1:0]btn,
    output reg[3:0]led
    );
    
    reg clean_up, clean_down;
    reg pulse_up, pulse_down;
    reg [3:0] out;
    
    BTN_DEB db_up (.clk(clk), .rst(rst), .btn(btn[0]), .btn_deb(clean_up));
    BTN_DEB db_down (.clk(clk), .rst(rst), .btn(btn[1]), .btn_deb(clean_down));

    Pulse_GEN pg_up (.clk(clk), .rst(rst), .in(clean_up), .out(pulse_up));
    Pulse_GEN pg_down (.clk(clk), .rst(rst), .in(clean_down), .out(pulse_down));

    MC cnt (
        .clk(clk),
        .rst(rst),
        .up_pulse(pulse_up),
        .down_pulse(pulse_down),
        .led(led)
    );
    
endmodule
