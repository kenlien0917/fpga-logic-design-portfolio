`timescale 1ns / 1ps

`define CYCLE 8
`define CLK_LEN 'd400 //! CLK_PERIOD = CLK_LEN*ran_gen_clk_PERIOD
`define COUNTER_NAME cnt // modify to your counter name in "body_map.v"

/*
format:
0 1 2 3
4 5 6 7
*/
`define COUNTER_ONE_DIMEN_ROW_MAJ `COUNTER_NAME[x_for_print + 8*y_for_print]
/*
format:
0 2 4 6
1 3 5 7
*/
`define COUNTER_ONE_DIMEN_COL_MAJ `COUNTER_NAME[8*x_for_print + y_for_print]
/*
format:
[0][0] [1][0] [2][0] [3][0]
[0][1] [1][1] [2][1] [3][1]
*/
`define COUNTER_TWO_DIMEN_ROW_MAJ `COUNTER_NAME[x_for_print][y_for_print] 
/*
format:
[0][0] [0][1] [0][2] [0][3]
[1][0] [1][1] [1][2] [1][3]
*/
`define COUNTER_TWO_DIMEN_COL_MAJ `COUNTER_NAME[y_for_print][x_for_print]

module Snake_tb(
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
      integer dir;
      reg up_but;
      reg right_but;
      reg down_but;
      reg left_but;
      integer x_for_print, y_for_print;

//duv
    top #(
    .BODY_INIT_PERIOD(`CLK_LEN),
    .RAN_GEN_CLK_PERIOD('d10)
    )duv(
        .rst(rst),
        .set_seed(set_seed),
        .system_clk(clk),
        .up_but(up_but),
        .right_but(right_but),
        .down_but(down_but),
        .left_but(left_but),
        .display()
    );

    //test start
     initial begin
        err_cnt = 0;
        for(cnt = 0; cnt <= 20000; cnt=cnt+1)begin
            #(8*`CLK_LEN - 1);
            dir = {$random()}%8; 
            {left_but,down_but,right_but,up_but} = 1 << dir; 
            
            #1;
            if(dir>= 4) $write(" dir remain");
            else $write("dir: %h",dir);
            $write("\n");

            for(y_for_print = 0; y_for_print < 8; y_for_print = y_for_print+1)begin
                for(x_for_print = 0; x_for_print < 8; x_for_print = x_for_print+1)begin
                    if((x_for_print == duv.snake_top.food_loc[2:0])&&(y_for_print == duv.snake_top.food_loc[5:3]))begin
                        $write(" F");
                    end
                    else $write("%d",duv.snake_top.body_map.`COUNTER_TWO_DIMEN_COL_MAJ);
                end
                $write("\n");
            end
            
            $display("----------------------%d----------------------", $time());
            if(duv.snake_top.body_map.dead)begin 
              $display("----------------------dead----------------------");
              $finish;
            end
        end
    $finish;
    end
endmodule
