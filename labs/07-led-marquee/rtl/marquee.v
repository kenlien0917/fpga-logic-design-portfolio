`timescale 1ns / 1ps

module Marquee ( 
    input clk, rst, 
    output [3:0] led
);

localparam st0 = 2'd0;
localparam st1 = 2'd1;
localparam st2 = 2'd2;
localparam st3 = 2'd3;

reg [1:0] cs, ns;
reg [26:0] counter; 
wire passed;

assign led[0] = (cs == st0) ? 1'd1: 1'd0;
assign led[1] = (cs == st1) ? 1'd1: 1'd0;
assign led[2] = (cs == st2) ? 1'd1: 1'd0;
assign led[3] = (cs == st3) ? 1'd1: 1'd0;

assign passed = counter == 26'd 62499999;

always@ (posedge clk or posedge rst) begin 
    if (rst)   cs <= st0;
    else  begin cs <= ns;

    end
end

always@(*) begin
    case (cs)
        st0 : ns = (passed) ? st1 : st0;
        st1 : ns = (passed) ? st2 : st1;
        st2 : ns = (passed) ? st3 : st2;
        st3 : ns = (passed) ? st0 : st3;
        default: ns = st0;
    endcase
end

always@ (posedge clk or posedge rst) begin 
    if (rst)    counter <= 26'd0;
    else if (passed)   counter <= 26'd0;
    else
        counter <= counter + 26'd1;
end

endmodule
