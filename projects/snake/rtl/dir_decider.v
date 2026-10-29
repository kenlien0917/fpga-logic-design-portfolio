`define UP    2'h0
`define RIGHT 2'h1
`define DOWN  2'h2
`define LEFT  2'h3
module dir_decider(
    input rst,
    input clk_12500Hz,
    input up_but,
    input right_but,
    input down_but,
    input left_but,
    output reg[1:0] dir
);

    always@(posedge clk_12500Hz or posedge rst) begin
        if(rst)
            dir <= `UP;
        else begin
            case(dir)
                `UP:if(down_but==0 && up_but)
                        dir <= `UP;
                    else if(right_but)
                        dir <= `RIGHT;
                    else if(left_but)
                        dir <= `LEFT;
                `RIGHT:if(left_but==0 && right_but)
                        dir <= `RIGHT;
                    else if(up_but)
                        dir <= `UP;
                    else if(down_but)
                        dir <= `DOWN;
                `DOWN:if(up_but==0 && down_but)
                        dir <= `DOWN;
                    else if(right_but)
                        dir <= `RIGHT;
                    else if(left_but)
                        dir <= `LEFT;
                `LEFT:if(right_but==0 && left_but)
                        dir <= `LEFT;
                    else if(up_but)
                        dir <= `UP;
                    else if(down_but)
                        dir <= `DOWN;
            endcase
        end
    end
                   
endmodule