`define UP    2'h0
`define RIGHT 2'h1
`define DOWN  2'h2
`define LEFT  2'h3
`define HEAD_Y head[5:3]
`define HEAD_X head[2:0]

module controller(
    input rst,
    input clk,
    input [1:0] dir,
    input [5:0] food_loc, 
    input [63:0] snake_body_map,
    output reg [5:0] next_head,
    output reg [5:0] len,
    output reg eat,
    output reg food_update
);

    reg [5:0] head;
    reg [2:0] x, y;
    reg [5:0] prev_food_loc;

    // 計算 next_head（組合邏輯）
    always @(*) begin
        x = head[2:0];
        y = head[5:3];
        case (dir)
            `UP:    y = (y == 3'd0) ? 3'd7 : y - 1;
            `DOWN:  y = (y == 3'd7) ? 3'd0 : y + 1;
            `LEFT:  x = (x == 3'd0) ? 3'd7 : x - 1;
            `RIGHT: x = (x == 3'd7) ? 3'd0 : x + 1;
        endcase
        next_head = {y, x};
    end

    // 1. head 寫入邏輯
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 6'd0;
        end else begin
            head <= next_head;
        end
    end

    // 2. len 增加邏輯（吃到食物時）
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            len <= 6'd1;
        end else if (next_head == food_loc) begin
            len <= len + 1;
        end
    end

    // 3. eat 控制邏輯（組合邏輯）
    always @(*) begin
        if (rst) begin
            eat = 1'b0;
        end else begin
            eat = (next_head == food_loc) ? 1'b1 : 1'b0;
        end
    end

    // 4. food_update 控制邏輯（偵測 food_loc 變化）
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            food_update <= 1'b0;
            prev_food_loc <= 6'd0;
        end else begin
            if (next_head == food_loc || snake_body_map[food_loc]) begin
                // 如果沒換位置，就視狀況繼續要求更新
                food_update <= 1'b1;
            end
    
            prev_food_loc <= food_loc;  // 最後更新追蹤變數
        end
    end
    
    always @(*) begin
        if (snake_body_map[food_loc]) begin
                // 如果沒換位置，就視狀況繼續要求更新
                food_update <= 1'b1;
        end
        else if (food_loc != prev_food_loc) begin
                // 一偵偵測到 food 位置更新，就馬上清除 food_update
                food_update <= 1'b0;
        end
    end


endmodule
