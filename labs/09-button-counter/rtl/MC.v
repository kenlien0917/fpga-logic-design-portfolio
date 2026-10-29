`timescale 1ns / 1ps

module MC(
    input clk, rst,
    input up_pulse, down_pulse,
    output reg [3:0]led
    );
    
    always @ (posedge clk or posedge rst) begin
        if (rst) led <= 0;
        else begin
            if (up_pulse) led <= led+1;
            else if (down_pulse) led <= led-1;
        end
    end
endmodule
