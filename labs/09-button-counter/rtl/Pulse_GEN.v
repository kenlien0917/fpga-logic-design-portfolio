`timescale 1ns / 1ps


module Pulse_GEN(
    input clk, rst,
    input in,
    output reg out
    );
    
    reg in_prev;
    
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            in_prev <= 0;
            out <= 0;
        end else begin
            in_prev <= in;
            out <= (in && !in_prev);
        end
    end
endmodule
