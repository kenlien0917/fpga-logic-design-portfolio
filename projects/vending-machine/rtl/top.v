module top(
	input clk, rst,
	input [3:0] btn_drink,
	input [2:0] btn_coin,
	//output [7:0] disp_coin,
	output [3:0] disp_led,
	output [13:0] coin_7seg//,
	//output out_valid
);

wire [3:0] cln_drink_btn;
wire [2:0] cln_coin_btn;
wire out_valid;
wire [7:0] disp_coin;
BTN_DEB d1(
    .clk(clk),
    .rst(rst),
    .btn(btn_drink[0]),
    .btn_deb(cln_drink_btn[0]));
BTN_DEB d2(
    .clk(clk),
    .rst(rst),
    .btn(btn_drink[1]),
    .btn_deb(cln_drink_btn[1]));
BTN_DEB d3(
    .clk(clk),
    .rst(rst),
    .btn(btn_drink[2]),
    .btn_deb(cln_drink_btn[2]));
BTN_DEB d4(
    .clk(clk),
    .rst(rst),
    .btn(btn_drink[3]),
    .btn_deb(cln_drink_btn[3]));
    
BTN_DEB c1(
    .clk(clk),
    .rst(rst),
    .btn(btn_coin[0]),
    .btn_deb(cln_coin_btn[0]));
BTN_DEB c2(
    .clk(clk),
    .rst(rst),
    .btn(btn_coin[1]),
    .btn_deb(cln_coin_btn[1]));
BTN_DEB c3(
    .clk(clk),
    .rst(rst),
    .btn(btn_coin[2]),
    .btn_deb(cln_coin_btn[2]));    

vending_machine v1(
	.clk(clk),
	.rst(rst),
	.btn_drink(cln_drink_btn),
	.btn_coin(cln_coin_btn),
	.disp_coin(disp_coin),
	.disp_led(disp_led),
	.out_valid(out_valid)
);

display disp1(
	.coin(disp_coin),
	.coin_7seg(coin_7seg)
);        

endmodule 