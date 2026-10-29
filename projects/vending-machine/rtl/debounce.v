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
            a   <= 0;
        end else begin
            // 2-stage synchronizer to prevent metastability
            btn_meta <= btn;
            btn_sync <= btn_meta;

            // Debounce logic
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
            btn_deb <= a & ~in_d;  // Rising edge detector
            in_d <= a;
        end
    end
endmodule