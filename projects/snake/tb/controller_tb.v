`define CYCLE 8
`define CLK_LEN 'd400 //! CLK_PERIOD = CLK_LEN*ran_gen_clk_PERIOD
module controller_tb(
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
        rst = 1;
        set_seed = 1;
        #(12);
        rst = 1;
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
        fd_r_i = $fopen("ctrl_tb_i", "r");
        fd_r_o = $fopen("ctrl_tb_o", "r");
    end
    initial begin
      err_cnt = 0;
    end

    wire clk_12500Hz;
    wire clk_forBody;
    
    // input
    reg [63:0] snake_body_map;
    reg [5:0] food_loc;
    reg [1:0] dir;
    
    // expect output
    reg [5:0]next_head_gold;
    reg eat_gold;
    reg [5:0]len_gold;
    reg update_food_gold;

    // true output
    wire [5:0]next_head;
    wire eat;
    wire [5:0]len;
    wire update_food;

    freq_divider #(
    .BODY_INIT_PERIOD(`CLK_LEN),
    .RAN_GEN_CLK_PERIOD('d10)
    )freq_divider(
      .rst(set_seed),
      .clk_125MHz(clk),
      .clk_12500Hz(clk_12500Hz),
      .clk_forBody(clk_forBody)
    );

    controller controller(
        .rst(rst),
        .clk(clk_forBody),
        .snake_body_map(snake_body_map),
        .food_loc(food_loc),
        .dir(dir),
        .eat(eat),
        .len(len),
        .next_head(next_head),
        .food_update(update_food)
    );

     initial begin
        err_cnt = 0;
        for(cnt = 0; cnt <= 20000; cnt=cnt+1)begin
            for(clk_len = 0; clk_len < `CLK_LEN; clk_len = clk_len + 1) begin
              #7
              $fscanf(fd_r_i, "%h %h %b %b\n", snake_body_map[63:32], snake_body_map[31:0], food_loc, dir);
              #1
              $fscanf(fd_r_o, "%b %b %b %b\n", next_head_gold, eat_gold, len_gold, update_food_gold);

              if(next_head != next_head_gold) begin
                $write("Err in next_head: gold:%b, out: %b\n", next_head_gold, next_head);
                err_cnt=err_cnt+1;
              end

              if(eat != eat_gold) begin
                $write("Err in eat: gold:%2b, out: %2b\n", eat_gold, eat);
                err_cnt=err_cnt+1;
              end

              if(len != len_gold) begin
                $write("Err in len: gold:%2b, out: %2b\n", len_gold, len);
                err_cnt=err_cnt+1;
              end

              if(update_food != update_food_gold) begin
                $write("Err in update_food: gold:%2b, out: %2b\n", update_food_gold, update_food);
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
    end
endmodule

