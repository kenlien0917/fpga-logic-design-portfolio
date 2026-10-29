module freq_divider #(
    BODY_INIT_PERIOD = 'd40000000,
    RAN_GEN_CLK_PERIOD = 'd10000
)(
    input clk_125MHz,
    input rst,
    output reg clk_12500Hz,
    output reg clk_forBody
);
    integer cnt;
    integer cnt_for_clk2;
    integer body_period;
    
    always@(posedge clk_125MHz or posedge rst)begin
        if (rst)begin
             cnt <= 0;
             cnt_for_clk2 <= 0;
             clk_12500Hz <= 0;
             clk_forBody <= 0;
             body_period <= BODY_INIT_PERIOD;
        end
        else begin
            if(cnt == (RAN_GEN_CLK_PERIOD / 2))begin
                cnt <= 0;
                clk_12500Hz <= ~(clk_12500Hz);
            end
            else cnt <= cnt + 1;
            if(cnt_for_clk2 == (body_period / 2))begin
                cnt_for_clk2 <= 0;
                clk_forBody <= ~(clk_forBody);
                body_period <= (body_period > 6250000)? body_period - (body_period >> 10) : body_period ; 
            end
            else cnt_for_clk2 <= cnt_for_clk2 + 1;
        end
    end

 endmodule
