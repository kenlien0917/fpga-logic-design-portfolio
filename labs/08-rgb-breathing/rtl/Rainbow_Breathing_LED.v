`timescale 1ns / 1ps

module Breathing_LED(
    input clk, rst,
    output led
    );
reg [7:0] phase_counter;
reg [7:0] bright_threshold;
reg [16:0] timer_8ns;
reg [9:0] timer_1ms;

wire passed_1ms, acc_99ms, passed_5ms;

assign passed_1ms = timer_8ns == 17'd124999;
assign acc_999ms = timer_1ms == 10'd999;
assign passed_5ms = passed_1ms & (timer_1ms%5 == 4);

always@(posedge clk or posedge rst) begin
    if(rst) begin
        timer_8ns <= 17'd0;
    end
    else if (passed_1ms) begin
        timer_8ns <= 17'd0;
    end
    else begin
        timer_8ns <= timer_8ns + 17'd1;
    end
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        timer_1ms <= 10'd0;
    end
    else if(passed_1ms)begin
        timer_1ms <= (acc_999ms) ? 10'd0 : timer_1ms + 10'd1;
    end
    else begin
    timer_1ms <= timer_1ms;
    end
    
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        phase_counter <= 8'd0;
    end
    else if(phase_counter == 8'd199) begin
        phase_counter <= 8'd0;
    end
    else begin
        phase_counter <= phase_counter + 8'd1;
    end
end

always@(posedge clk or posedge rst) begin
    if(rst) begin
        bright_threshold <= 8'd0;
    end
    else if( passed_5ms) begin
        if ( timer_1ms <= 10'd500) begin
            bright_threshold <= bright_threshold + 8'd1;
        end
        else begin
            bright_threshold <= bright_threshold - 8'd1;
        end
    end
    else begin
        bright_threshold <= bright_threshold;
    end
end

assign led = (phase_counter < bright_threshold);

endmodule

module RGB_Mixer (
    input [2:0] color_state,
    output reg [7:0] threshold_r,
    output reg [7:0] threshold_g,
    output reg [7:0] threshold_b
);
always @(*) begin
    case(color_state)
        3'd0: begin threshold_r = 8'd200; threshold_g = 8'd0;   threshold_b = 8'd0;   end // RED
        3'd1: begin threshold_r = 8'd200; threshold_g = 8'd80;  threshold_b = 8'd0;   end // ORANGE
        3'd2: begin threshold_r = 8'd200; threshold_g = 8'd200; threshold_b = 8'd0;   end // YELLOW
        3'd3: begin threshold_r = 8'd0;   threshold_g = 8'd200; threshold_b = 8'd0;   end // GREEN
        3'd4: begin threshold_r = 8'd0;   threshold_g = 8'd0;   threshold_b = 8'd200; end // BLUE
        3'd5: begin threshold_r = 8'd128; threshold_g = 8'd0;   threshold_b = 8'd128; end // PURPLE
        3'd6: begin threshold_r = 8'd200; threshold_g = 8'd200; threshold_b = 8'd200; end // WHITE
        default: begin threshold_r = 8'd0; threshold_g = 8'd0; threshold_b = 8'd0; end
    endcase
end
endmodule

module Rainbow_Breathing_LED(
    input clk, rst,
    output led_r, led_g, led_b
);

localparam RED    = 3'd0;
localparam ORANGE = 3'd1;
localparam YELLOW = 3'd2;
localparam GREEN  = 3'd3;
localparam BLUE   = 3'd4;
localparam PURPLE = 3'd5;
localparam WHITE  = 3'd6;

reg [2:0] cs, ns;
reg [2:0] timer_1s;
reg [26:0] timer_8ns;

wire passed_1s;
assign passed_1s = (timer_8ns == 27'd124_999_999);

always@(posedge clk or posedge rst) begin
    if (rst)
        cs <= RED;
    else
        cs <= ns;
end

always@(*) begin
    case (cs)
        RED    : ns = passed_1s ? ORANGE : cs;
        ORANGE : ns = passed_1s ? YELLOW : cs;
        YELLOW : ns = passed_1s ? GREEN  : cs;
        GREEN  : ns = passed_1s ? BLUE   : cs;
        BLUE   : ns = passed_1s ? PURPLE : cs;
        PURPLE : ns = passed_1s ? WHITE  : cs;
        WHITE  : ns = passed_1s ? RED    : cs;
        default: ns = RED;
    endcase
end

always@(posedge clk or posedge rst) begin
    if (rst)
        timer_8ns <= 27'd0;
    else if (passed_1s)
        timer_8ns <= 27'd0;
    else
        timer_8ns <= timer_8ns + 27'd1;
end

always@(posedge clk or posedge rst) begin
    if (rst)
        timer_1s <= 3'd0;
    else if (passed_1s)
        timer_1s <= (timer_1s == 3'd6) ? 3'd0 : timer_1s + 3'd1;
end

wire breathing_pwm;
Breathing_LED breath(
    .clk(clk),
    .rst(rst),
    .led(breathing_pwm)
);

wire [7:0] th_r, th_g, th_b;
RGB_Mixer color_sel(
    .color_state(cs),
    .threshold_r(th_r),
    .threshold_g(th_g),
    .threshold_b(th_b)
);

reg [7:0] phase_counter;
always@(posedge clk or posedge rst) begin
    if (rst)
        phase_counter <= 8'd0;
    else
        phase_counter <= (phase_counter == 8'd199) ? 8'd0 : phase_counter + 8'd1;
end

assign led_r = breathing_pwm && (phase_counter < th_r);
assign led_g = breathing_pwm && (phase_counter < th_g);
assign led_b = breathing_pwm && (phase_counter < th_b);

endmodule

