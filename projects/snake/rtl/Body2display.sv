`define ROW 8+
`define COL 0+
module Body2display(
    input rst,
    input clk,
    input [5:0] food_place,
    input [63:0] snake_map,
    output [15:0] display
);
    
    reg [2:0] row;
    reg [5:0] cnt;
    wire [15:0] col_row_display_format;
    always@(posedge clk)begin
        if(rst) begin
            row <= 3'b0;
            cnt <= 6'b0;
        end
        else begin
            row <= row + 1;
            cnt <= (cnt == 6'h6)? 0 : cnt + 1;
        end
    end

    assign col_row_display_format = {(8'b1 << row), ~(snake_map[8*row+:8])} & {8'hff,~({7'h0,((food_place[5:3] == row) && (cnt == 0))} << food_place[2:0])};  //{y, x}
    /*                                              Snake Body                     |         food, food freq 1/2                                            */
    /*                                                       The col that needs to shine should be set to 0                                                 */
                                    // pos   neg      logic
    // assign col_row_display_format = {(8'h1),~(8'h1)};
    /*
        9   R6      R8
        0   R3      C5
        0   C4      C3
        4   R1      R5
        .   C6      C8
        .   C7      R7
        .   R2      C2
        .   R4      C1
    */

    //the '~' is because "Cathode Row, Anode Column" 
    assign display = {
        col_row_display_format[`ROW 1 - 1], 
        col_row_display_format[`ROW 2 - 1], 
        col_row_display_format[`ROW 3 - 1], 
        col_row_display_format[`ROW 4 - 1], 
        col_row_display_format[`COL 5 - 1], 
        col_row_display_format[`COL 6 - 1], 
        col_row_display_format[`COL 7 - 1], 
        col_row_display_format[`COL 8 - 1], 
        col_row_display_format[`COL 1 - 1], 
        col_row_display_format[`COL 2 - 1], 
        col_row_display_format[`COL 3 - 1], 
        col_row_display_format[`COL 4 - 1], 
        col_row_display_format[`ROW 5 - 1], 
        col_row_display_format[`ROW 6 - 1], 
        col_row_display_format[`ROW 7 - 1], 
        col_row_display_format[`ROW 8 - 1]  
    };//connect to LED PIN 



endmodule
