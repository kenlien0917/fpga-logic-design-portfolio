`timescale 1ns / 1ps

module vending_machine(
    input clk, rst,
    input [3:0] btn_drink,
    input [2:0] btn_coin,
    output reg [7:0] disp_coin,
    output reg [3:0] disp_led,
    output reg out_valid
);

parameter RESET = 2'd0, SEL = 2'd1, CHANGE = 2'd2, WAIT = 2'd3;
parameter RESET_DURATION = 625_000_000;

reg [1:0] state, next_state;
reg [30:0] wait_counter;
reg [31:0] reset_cnt;
reg [7:0] money;

reg [2:0] btn_coin_d, btn_coin_dd;
wire [2:0] btn_coin_edge;
assign btn_coin_edge = btn_coin_d & ~btn_coin_dd;

reg [3:0] btn_drink_d, btn_drink_dd;
wire [3:0] btn_drink_edge;
assign btn_drink_edge = btn_drink_d & ~btn_drink_dd;

reg drink_flag;
reg [1:0] change_counter;
reg [1:0] selected_drink;

//----------------------
// 同步器與邊緣檢測
//----------------------
always @(posedge clk or posedge rst) begin
    if (rst) begin
        btn_coin_d <= 0; btn_coin_dd <= 0;
        btn_drink_d <= 0; btn_drink_dd <= 0;
    end else begin
        btn_coin_d <= btn_coin;
        btn_coin_dd <= btn_coin_d;
        btn_drink_d <= btn_drink;
        btn_drink_dd <= btn_drink_d;
    end
end

//----------------------
// 狀態切換邏輯
//----------------------
always @(posedge clk or posedge rst) begin
    if (rst) state <= RESET;
    else     state <= next_state;
end

always @(*) begin

    case (state)
        RESET:   next_state = (reset_cnt >= RESET_DURATION) ? SEL : RESET;

        SEL: begin
            if (btn_drink_edge != 0 && !drink_flag &&
                ((btn_drink_edge[0] && money >= 8'd10) ||
                 (btn_drink_edge[1] && money >= 8'd25) ||
                 (btn_drink_edge[2] && money >= 8'd60) ||
                 (btn_drink_edge[3] && money >= 8'd75)))
                next_state = CHANGE;
                else next_state = SEL;
            end
        

        CHANGE:  next_state = (change_counter == 2'd1) ? WAIT : CHANGE;
        WAIT:    next_state = (wait_counter == 30'd125000000) ? RESET : WAIT;
    endcase
end

//----------------------
// 狀態行為邏輯
//----------------------
always @(posedge clk or posedge rst) begin
    if (rst) begin
        reset_cnt <= 0;
        disp_coin <= 0;
        money <= 0;
        disp_led <= 0;
        wait_counter <= 0;
        out_valid <= 0;
        drink_flag <= 0;
        change_counter <= 0;
    end else begin
        case (state)
            RESET: begin
                reset_cnt <= reset_cnt + 1;
                money <= 0;
                disp_coin <= 0;
                disp_led <= 0;
                wait_counter <= 0;
                out_valid <= 0;
                drink_flag <= 0;
                change_counter <= 0;
            end

            SEL: begin
                reset_cnt <= 0;

                // 投幣邊緣檢測
                if (btn_coin_edge[2]) money <= (money + 8'd50 > 8'd95) ? 8'd95 : money + 8'd50;
                else if (btn_coin_edge[1]) money <= (money + 8'd10 > 8'd95) ? 8'd95 : money + 8'd10;
                else if (btn_coin_edge[0]) money <= (money + 8'd5  > 8'd95) ? 8'd95 : money + 8'd5;

                // 飲料選擇紀錄
                if (!drink_flag) begin
                    if (btn_drink_edge[3]) begin
                        if (money >= 8'd75) selected_drink <= 2'd3;
                        drink_flag <= 1;
                    end else if (btn_drink_edge[2]) begin
                        if (money >= 8'd60) selected_drink <= 2'd2;
                        drink_flag <= 1;
                    end else if (btn_drink_edge[1]) begin
                        if (money >= 8'd25) selected_drink <= 2'd1;
                        drink_flag <= 1;
                    end else if (btn_drink_edge[0]) begin
                        if (money >= 8'd10) selected_drink <= 2'd0;
                        drink_flag <= 1;
                    end
                end else if (btn_drink_edge == 0) begin
                    drink_flag <= 0;
                end

                disp_coin <= money;

                if (money >= 8'd75) disp_led <= 4'b1111;
                else if (money >= 8'd60) disp_led <= 4'b0111;
                else if (money >= 8'd25) disp_led <= 4'b0011;
                else if (money >= 8'd10) disp_led <= 4'b0001;
                else disp_led <= 4'b0000;

                out_valid <= 0;
                change_counter <= 0;
            end

            CHANGE: begin
                if (change_counter == 0) begin
                    case (selected_drink)
                        2'd0: begin money <= money - 8'd10; disp_coin <= money - 8'd10; disp_led <= 4'b0001; end
                        2'd1: begin money <= money - 8'd25; disp_coin <= money - 8'd25; disp_led <= 4'b0010; end
                        2'd2: begin money <= money - 8'd60; disp_coin <= money - 8'd60; disp_led <= 4'b0100; end
                        2'd3: begin money <= money - 8'd75; disp_coin <= money - 8'd75; disp_led <= 4'b1000; end
                    endcase
                    wait_counter <= 0;
                    out_valid <= 0;
                end
                change_counter <= change_counter + 1;
            end

            WAIT: begin
                wait_counter <= wait_counter + 1;
                out_valid <= (wait_counter == 30'd125000000);
            end
        endcase
    end
end

endmodule
