`define CYCLE 8
`define CLK_LEN 'd400 //! CLK_PERIOD = CLK_LEN*ran_gen_clk_PERIOD
module food_tb(
    );
//clk & rst
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
    integer fd_r_i;
    integer fd_r_o;
    integer clk_len;

    initial begin
        fd_r_i = $fopen("food_tb_i", "r");
        fd_r_o = $fopen("food_tb_o", "r");
    end
    initial begin
      err_cnt = 0;
    end

    wire clk_12500Hz;
    wire clk_forBody;

    // input
    reg update_food;

    // expected output
    reg [5:0] food_place_gold;
    reg [9:0] ran_shift_reg_gold;

    // true output
    wire [5:0] food_loc;
    wire [9:0] ran_shift_reg;

    assign ran_shift_reg = food.random_generator.shift_reg;
    freq_divider #(
    .BODY_INIT_PERIOD(`CLK_LEN),
    .RAN_GEN_CLK_PERIOD('d10)
    )freq_divider(
      .rst(set_seed),
      .clk_125MHz(clk),
      .clk_12500Hz(clk_12500Hz),
      .clk_forBody(clk_forBody)
    );

    food food(
        .rst(rst),
        .set_seed(set_seed),
        .clk_12500Hz(clk_12500Hz),
        .food_update(update_food),
        .food_loc(food_loc)
    );

     initial begin
        err_cnt = 0;
        for(cnt = 0; cnt <= 20000; cnt=cnt+1)begin
            for(clk_len = 0; clk_len < `CLK_LEN; clk_len = clk_len + 1) begin
              #7
              $fscanf(fd_r_i, "%d\n", update_food);
              #1
              $fscanf(fd_r_o, "%d %d %h\n", food_place_gold[5:3], food_place_gold[2:0], ran_shift_reg_gold);
              if(food_loc != food_place_gold) begin
                $write("Err: gold:%b %h, res: %b %h, upfood:%b\n", food_place_gold, ran_shift_reg_gold, 
                food_loc, ran_shift_reg, update_food);
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
              $finish;
            end
        end
    end
endmodule

