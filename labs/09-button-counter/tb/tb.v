`timescale 1ns/1ns
`include "MC_TOP.v"

module tb();

    reg clk, rst;
    reg [1:0] btn;
    reg [3:0] led;

    MC_TOP u1 (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .led(led)
    );

    // 125MHz clock = 8ns period
    always #4 clk = ~clk;

    initial begin
       // $fsdbDumpfile("waveform.fsdb");
       // $fsdbDumpvars(0, tb);
        clk = 0;
        rst = 1;
        btn = 2'b00;

        // Reset
        #20 rst = 0;
        $display(">>> Reset done at %t", $time);
        print_led();

        // press btn[0] once (expect 0001)
        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();        

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();        

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();        

        press_btn(2'b01, "BTN0");
        print_led();                

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0");
        print_led();

        press_btn(2'b01, "BTN0 (limit)");
        print_led();

        // press btn[1] 
        press_btn(2'b10, "BTN1");
        print_led();
        press_btn(2'b10, "BTN1");
        print_led();


        // simulate bouncing (btn[0])
        bounce_btn(2'b01, "BTN0 bounce test");
        print_led();

        // simulate bouncing (btn[1])
        bounce_btn(2'b10, "BTN1 bounce test");
        print_led();

        $display(">>> Test Complete at %t", $time);
        #1000;
        $finish;
    end

    // Press and hold button for 50ms, then release
    task press_btn(input [1:0] key, input [255:0] msg);
        begin
            $display(">>> Pressing %s at %t", msg, $time);
            btn = key;
            #50000016;  // 50 ms
            btn = 2'b00;
            $display(">>> Released %s at %t", msg, $time);
            #50000000;  // 10 ms wait
        end
    endtask

    // Bounce test: simulate bouncing by toggling fast
    task bounce_btn(input [1:0] key, input [255:0] msg);
        begin
            $display(">>> Bounce start: %s at %t", msg, $time);
            repeat (6) begin
                btn = key;
                #4000000;   // 4ms
                btn = 2'b00;
                #4000000;
            end
            $display(">>> Bounce end: %s at %t", msg, $time);
            #10000000;
        end
    endtask

    // Print current LED
    task print_led;
    begin
        $display(">>> LED = %b at %t", led, $time);
    end
    endtask

endmodule