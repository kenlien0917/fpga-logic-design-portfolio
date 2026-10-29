`define CYCLE 8
`define CLK_LEN 'd400 //! CLK_PERIOD = CLK_LEN*ran_gen_clk_PERIOD
module dir_tb(
    );
    reg rst;
    reg clk;   
    reg set_seed;
    always #(`CYCLE/2)    clk = ~clk;

    //set clk
    initial begin
      clk = 0;
    end
    //set reset
    initial begin
      rst = 0;
      set_seed = 1;
      #(12);
      rst = 0;
      set_seed = 0;
      #(8)
      rst = 1;
      #(8000)
      rst = 0;
    end
//signals
    integer err_cnt;
    integer cnt;

    reg up_but;
    reg right_but;
    reg down_but;
    reg left_but;
    integer fd_r_i;
    integer fd_r_o;
    integer clk_len;

    initial begin
        fd_r_i = $fopen("dir_decider_tb_i", "r");
        fd_r_o = $fopen("dir_decider_tb_o", "r");
    end
    initial begin
      err_cnt = 0;
    end

    wire clk_12500Hz;
    wire clk_forBody;

    // input
    reg update_food;
    reg up_but;
    reg right_but;
    reg down_but;
    reg left_but;

    // expected output
    reg [1:0] dir_gold;

    // true output
    wire [1:0] dir;

    freq_divider #(
    .BODY_INIT_PERIOD(`CLK_LEN),
    .RAN_GEN_CLK_PERIOD('d10)
    )freq_divider(
      .rst(set_seed),
      .clk_125MHz(clk),
      .clk_12500Hz(clk_12500Hz),
      .clk_forBody(clk_forBody)
    );

    dir_decider dir_decider(
        .rst(rst),
        .clk_12500Hz(clk_12500Hz),
        .up_but(up_but),
        .right_but(right_but),
        .down_but(down_but),
        .left_but(left_but),
        .dir(dir)
    );

     initial begin
        err_cnt = 0;
        for(cnt = 0; cnt <= 20000; cnt=cnt+1)begin
            for(clk_len = 0; clk_len < `CLK_LEN; clk_len = clk_len + 1) begin
              #7
              $fscanf(fd_r_i, "%d %d %d %d\n", up_but, right_but, down_but, left_but);
              #1
              $fscanf(fd_r_o, "%b\n", dir_gold);
              if(dir != dir_gold) begin
                $write("Err: gold:%b, res: %b,\n", dir_gold, dir);
                err_cnt=err_cnt+1;
              end
              if($feof(fd_r_o)) begin
                $display("err_cnt: %d",  err_cnt);
                $fclose(fd_r_i);
                $fclose(fd_r_o);
                $finish;
              end
            end

            $display("----------------------%d----------------------", $time());
              if(err_cnt != 0) begin
              $display("----------------------has err----------------------");
              $display("err_cnt: %d",  err_cnt);
              $finish;
            end
        end
    $display("err_cnt: %d",  err_cnt);
  end
endmodule

