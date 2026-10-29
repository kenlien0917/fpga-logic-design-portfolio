`define THIS_CNT cnt[i[2:0]][j[2:0]]

module body_map(
    input rst,
    input clk,
    input eat,
    input [5:0] len,
    input [5:0] next_head,
    output reg [63:0] snake_body_map
);

    reg dead;
    reg collide;
    reg [5:0] len_r;
    reg [5:0] cnt[0:7][0:7];
    wire [2:0] hx = next_head[2:0]; // x 座標
    wire [2:0] hy = next_head[5:3]; // y 座標
    integer i, j;
    
    // Compute the "one-clock-ahead" length:
    //   if we're eating this cycle, head_life = len+1, else len
    wire [5:0] head_life = eat ? (len + 6'd1) : len;
    
    // 1) Maintain cnt[][], collision, decay, and growth
    always @(posedge clk or posedge rst) begin
    if (rst) begin
        dead <= 1'b0;
        collide <= 1'b0;
        for (i = 0; i < 8; i = i + 1)
            for (j = 0; j < 8; j = j + 1)
                cnt[i][j] <= 6'd0;
    end else if (!dead) begin
        collide <= 1'b0;  // 預設為不撞

        // 1. decay and 判斷是否會撞到
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                if (!eat) begin
                    if (cnt[i][j] == 1)
                        cnt[i][j] <= 0;
                    else if (cnt[i][j] > 1)
                        cnt[i][j] <= cnt[i][j] - 1;
                end
            end
        end

        // 判斷撞不撞（需使用 decay 後的值）
        if (cnt[hy][hx] > (eat ? 0 : 1)) begin
            collide <= 1;
        end else begin
            cnt[hy][hx] <= eat ? (len + 1) : len;
        end

        // 紀錄死亡
        if (collide)
            dead <= 1;
    end
end


    // 2) Build the 8×8 map: 1 if cnt>0, else 0
    always @(*) begin
        for (i = 0; i < 8; i = i + 1)
            for (j = 0; j < 8; j = j + 1)
                snake_body_map[8*i + j] = (cnt[i][j] > 0) ? 1'b1 : 1'b0;
    end

endmodule
