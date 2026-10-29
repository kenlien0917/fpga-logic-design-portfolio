`define CYCLE 8
`define CLK_LEN 'd400 //! CLK_PERIOD = CLK_LEN*ran_gen_clk_PERIOD
module body_map_tb(
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
    integer i;

    initial begin
        fd_r_i = $fopen("body_map_tb_i", "r");
        fd_r_o = $fopen("body_map_tb_o", "r");
    end
    initial begin
      err_cnt = 0;
    end

    wire clk_12500Hz;
    wire clk_forBody;
    
    // input
    reg [5:0]len_i;
    reg [5:0] next_head_i;
    reg eat_i;
    
    // expect output
    reg [63:0]body_golden;

    // true output
    wire [63:0]snake_body_map;

    freq_divider #(
    .BODY_INIT_PERIOD(`CLK_LEN),
    .RAN_GEN_CLK_PERIOD('d10)
    )freq_divider(
      .rst(set_seed),
      .clk_125MHz(clk),
      .clk_12500Hz(clk_12500Hz),
      .clk_forBody(clk_forBody)
    );

    body_map body_map(
        .rst(rst),
        .clk(clk_forBody),
        .len(len_i),
        .next_head(next_head_i),
        .eat(eat_i),
        .snake_body_map(snake_body_map)
    );

     initial begin
        err_cnt = 0;
        for(cnt = 0; cnt <= 20000; cnt=cnt+1)begin
            for(clk_len = 0; clk_len < `CLK_LEN; clk_len = clk_len + 1) begin
              #7
              $fscanf(fd_r_i, "%d %b %b\n", len_i, next_head_i, eat_i);
              #1
              $fscanf(fd_r_o, "%h %h\n", body_golden[63:32], body_golden[31:0]);

              if(snake_body_map != body_golden) begin
                $write("Err in snake_body_map, golden is:\n");
                for(i = 0; i < 64; i = i + 1) begin
                  $write("%b ", body_golden[i]);
                  if(i % 8 == 7)
                    $write("\n");
                end
                $write("\nYour output is:\n");
                for(i = 0; i < 64; i = i + 1) begin
                  $write("%b ", snake_body_map[i]);
                  if(i % 8 == 7)
                    $write("\n");
                end
                err_cnt = err_cnt + 1;
              end

              if($feof(fd_r_o)) begin
                $display("err_cnt: %d",  err_cnt);
                $fclose(fd_r_i);
                $fclose(fd_r_o);
                $finish;
              end
            end
              $write("\n");
              $display("----------------------%d----------------------", $time());
                if(err_cnt != 0) begin
                $display("----------------------has err----------------------");
                $display("err_cnt: %d",  err_cnt);
                $finish;
            end
        end
    end
endmodule
