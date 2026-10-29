`timescale 1ns / 1ps

module BTN_DEB(
    input clk, rst,
    input btn,
    output reg btn_deb
    );
    
    reg [19:0] count;
    reg btn_sync_0, btn_sync_1;
    
    always @(posedge clk) begin
        btn_sync_0 <= btn;
        btn_sync_1 <= btn_sync_0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            btn_deb <=0;
        end else if (btn_sync_1 != btn_deb) begin
            count <= count + 1;
            if (count == 500000) begin
                btn_deb <= btn_sync_1;
                count <= 0;
            end else begin
                count <= 0;
            end
        end
    end
endmodule
