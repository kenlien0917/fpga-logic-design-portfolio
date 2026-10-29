
/*
mapping
+-------+-------+-------+-------+-------+-------+-------+-------+
| (0,0) | (0,1) | (0,2) | (0,3) | (0,4) | (0,5) | (0,6) | (0,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
| (1,0) | (1,1) | (1,2) | (1,3) | (1,4) | (1,5) | (1,6) | (1,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
| (2,0) | (2,1) | (2,2) | (2,3) | (2,4) | (2,5) | (2,6) | (2,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
| (3,0) | (3,1) | (3,2) | (3,3) | (3,4) | (3,5) | (3,6) | (3,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
| (4,0) | (4,1) | (4,2) | (4,3) | (4,4) | (4,5) | (4,6) | (4,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
| (5,0) | (5,1) | (5,2) | (5,3) | (5,4) | (5,5) | (5,6) | (5,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
| (6,0) | (6,1) | (6,2) | (6,3) | (6,4) | (6,5) | (6,6) | (6,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
| (7,0) | (7,1) | (7,2) | (7,3) | (7,4) | (7,5) | (7,6) | (7,7) |
+-------+-------+-------+-------+-------+-------+-------+-------+
{y, x}
UP    => y - 1
RIGHT => x + 1
DOWN  => y + 1
KEFT  => x - 1
*/
module snake_top(
    input clk, // lower freq
    input clk_12500Hz, // higher freq
    input rst,
    input set_seed,
    input up_but,
    input right_but,
    input down_but, 
    input left_but,
    output [15:0] display //indeed used
);

wire food_update, eat;
wire [1:0]dir;
wire [5:0]food_loc, len, next_head;
wire [63:0]snake_body_map;

food food(
    .clk_12500Hz(clk_12500Hz), //higher freq
    .rst(rst),
    .set_seed(set_seed),
    .food_update(food_update),
    .food_loc(food_loc));

body_map body_map(
    .rst(rst),
    .clk(clk),
    .eat(eat),
    .len(len),
    .next_head(next_head),
    .snake_body_map(snake_body_map));
    
controller controller(
    .rst(rst),
    .clk(clk),
    .dir(dir),
    .food_loc(food_loc), 
    .snake_body_map(snake_body_map),
    .next_head(next_head),
    .len(len),
    .eat(eat),
    .food_update(food_update));
dir_decider dir_decider(
    .rst(rst),
    .clk_12500Hz(clk_12500Hz),
    .up_but(up_but),
    .right_but(right_but),
    .down_but(down_but),
    .left_but(left_but),
    .dir(dir));
    
Body2display Body2display(
    .clk(clk),
    .rst(rst),
    .food_place(food_loc),
    .snake_map(snake_body_map),
    .display(display));


endmodule
