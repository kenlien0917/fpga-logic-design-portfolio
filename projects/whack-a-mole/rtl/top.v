module LFSR(
    input clk,
    input rst,
    input [3:0] seed,
    output reg [3:0] op
);
    always @(posedge clk) begin
        if (rst)
            op <= seed;
        else
            op <= {op[2:0], (op[3] ^ op[2])};
    end
endmodule


module BTN_DEB (
    input clk, rst,
    input btn,
    output reg btn_deb
);
    reg [15:0] count;
    reg btn_meta, btn_sync;
    reg btn_prev;
    reg a;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count     <= 0;
            btn_meta  <= 0;
            btn_sync  <= 0;
            btn_prev  <= 0;
            a         <= 0;
        end else begin
            btn_meta <= btn;
            btn_sync <= btn_meta;

            if (btn_sync == btn_prev) begin
                if (count < 16'hFFFF)
                    count <= count + 1;
                else
                    a <= btn_sync;
            end else begin
                count <= 0;
            end
            btn_prev <= btn_sync;
        end
    end

    reg in_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            in_d <= 0;
            btn_deb <= 0;
        end else begin
            btn_deb <= a & ~in_d;
            in_d <= a;
        end
    end
endmodule

module sing_mole(
    input clk,
    input rst,
    input btn,
    input [3:0] seed,
    output reg led
);

parameter IDLE = 2'd0, WAIT = 2'd1, HIT = 2'd2;
parameter HIT_DURATION = 250_000_000;  // 1秒（假設 250MHz）

reg [1:0] state, next_state;
reg [30:0] hit_cnt, wait_cnt, rdtime;
wire [3:0] op;

LFSR l1(
    .clk(clk),
    .rst(rst),
    .seed(seed),
    .op(op)
);

always @(posedge clk or posedge rst) begin
    if (rst)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    case(state)
        IDLE: next_state = WAIT;
        WAIT: next_state = (wait_cnt == rdtime)? HIT : WAIT;
        HIT:  next_state = (hit_cnt == HIT_DURATION || btn) ? WAIT : HIT;
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        hit_cnt  <= 0;
        wait_cnt <= 0;
        led      <= 0;
        rdtime   <= (op % 3 + 1) * 125_000_000;
    end else begin
        case (state)
            IDLE: begin
                hit_cnt  <= 0;
                wait_cnt <= 0;
                led      <= 0;
                rdtime   <= (op % 3 + 1) * 125_000_000;
            end
            WAIT: begin
                led <= 0;
                wait_cnt <= wait_cnt + 1;
                if (wait_cnt == 0)
                    rdtime <= (op % 3 + 1) * 125_000_000;
            end
            HIT: begin
                wait_cnt <= 0;
                hit_cnt <= hit_cnt + 1;
                led <= 1;
            end
        endcase
    end
end

endmodule

module mole(
    input clk,
    input rst,
    input [3:0] btn,
    output [3:0] led
);

wire [3:0] cln_btn;

BTN_DEB d1(.clk(clk), .rst(rst), .btn(btn[0]), .btn_deb(cln_btn[0]));
BTN_DEB d2(.clk(clk), .rst(rst), .btn(btn[1]), .btn_deb(cln_btn[1]));
BTN_DEB d3(.clk(clk), .rst(rst), .btn(btn[2]), .btn_deb(cln_btn[2]));
BTN_DEB d4(.clk(clk), .rst(rst), .btn(btn[3]), .btn_deb(cln_btn[3]));

sing_mole s0(
    .clk(clk),
    .rst(rst),
    .btn(cln_btn[0]),
    .seed(4'b0001),
    .led(led[0]));

sing_mole s1(
    .clk(clk),
    .rst(rst),
    .btn(cln_btn[1]),
    .seed(4'b0011),
    .led(led[1]));

sing_mole s2(
    .clk(clk),
    .rst(rst),
    .btn(cln_btn[2]),
    .seed(4'b0101),
    .led(led[2]));

sing_mole s3(
    .clk(clk),
    .rst(rst),
    .btn(cln_btn[3]),
    .seed(4'b0111),
    .led(led[3]));

endmodule
