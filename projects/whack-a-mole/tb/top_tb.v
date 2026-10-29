`timescale 1ns / 1ps
`define CYCLE    8.0 // 125Mhz

module top_tb();

integer i;

//  I/O port
reg clk;
reg rst;
// reg btn;
// wire led;
reg [3:0] btn;
wire [3:0] led;


always #(`CYCLE/2)    clk = ~clk;

initial begin
	$display("----------------------");
	$display("-- Simulation Start --");
	$display("----------------------");
	clk   = 1;
	rst = 1;
	btn = 0;
	@(posedge clk)
	#(12);
	rst = 0;
	
	#24 btn = 0;
	
	for(i = 0; i < 10; i = i + 1) begin
		#80 btn = 4'b1000;
		#8 btn = 4'b0000;
		#80 btn = 4'b0100;
		#8 btn = 4'b0000;
		#80 btn = 4'b0010;
		#8 btn = 4'b0000;
		#80 btn = 4'b0001;
		#8 btn = 4'b0000;
	end
	
	$display("----------------------");
	$display("--- Simulation End ---");
	$display("----------------------");
	$finish;
end

mole m1(
	.clk(clk),
	.rst(rst),
	.btn(btn),
	.led(led)
);

endmodule