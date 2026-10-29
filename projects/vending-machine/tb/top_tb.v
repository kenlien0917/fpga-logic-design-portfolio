`timescale 1ns/1ps
`define CYCLE 8.0
`define WAIT  88

module top_tb();

	integer i, j, k, m, n;

	// inputs
	reg clk, rst;
	reg [3:0] btn_drink;
	reg [2:0] btn_coin;

	// outputs
	wire [13:0] coin_7seg;
	wire [7:0]  disp_coin;
	wire [3:0]  disp_led;

	// tb signal
	reg [31:0] error_coin;
	reg [31:0] error_drink;
	
	reg [7:0]  golden_coin;
	reg [3:0]  golden_led;

	reg [7:0]  money_in;
	reg testcase;

	integer data_drink_case1, data_drink_case2, data_coin_case1, data_coin_case2;

	top top(
		.clk(clk), .rst(rst),
	 	.btn_drink(btn_drink),
	 	.btn_coin(btn_coin),
		.disp_coin(disp_coin),
		.disp_led(disp_led),
		.coin_7seg(coin_7seg),
		.out_valid(out_valid)
	);

	// clock
	initial clk = 1;
	always #(`CYCLE/2) clk = ~clk;

	// reset
    initial begin
        rst = 1;
        repeat (10) @(posedge clk); // 多等幾拍，讓同步器收斂
        rst = 0;
        repeat (50) @(posedge clk); // ✅ 再空跑 50 拍再開始丟按鈕事件
        error_coin = 0;
        error_drink = 0;
    end


	// waveform
	//initial begin
		//$fsdbDumpfile("vm.fsdb");
		//$fsdbDumpvars(0);
	//end

	// input data
	initial begin
		data_drink_case1 = $fopen("data_drink_case1.data","r");
		data_drink_case2 = $fopen("data_drink_case2.data","r");
		data_coin_case1  = $fopen("data_coin_case1.data","r");
		data_coin_case2  = $fopen("data_coin_case2.data","r");
	end

	initial begin
		#(`WAIT);
		for(i=0; i<200; i=i+1) begin
			money_in	= 0;
			btn_coin	= 3'b000;
			btn_drink	= 4'b0000;
			k = 0;
			if (i<100) begin

				// Insert Coin
				testcase = 0;
				for (j=0; j<10; j=j+1) begin
					$fscanf(data_coin_case1,"%d",btn_coin);
					case(btn_coin)
						3'b100: money_in = (money_in+7'd50>7'd95)? 7'd95: money_in+7'd50;
						3'b010: money_in = (money_in+7'd10>7'd95)? 7'd95: money_in+7'd10;
						3'b001: money_in = (money_in+7'd5 >7'd95)? 7'd95: money_in+7'd5;
						default:money_in = money_in;
					endcase
					if(j==9) begin 
						#(`WAIT);
						btn_coin = 3'b000; 
						#(`WAIT);
					end
					else begin
						#(12*`CYCLE);
						btn_coin = 3'b000; 
						#(`WAIT);
					end
				end
				#(`WAIT)

				// Select Drink
				$fscanf(data_drink_case1,"%d", btn_drink);
				case(btn_drink)
					4'b1000: golden_coin = (money_in>=7'd75)? money_in-7'd75: money_in;
					4'b0100: golden_coin = (money_in>=7'd60)? money_in-7'd60: money_in;
					4'b0010: golden_coin = (money_in>=7'd25)? money_in-7'd25: money_in;
					4'b0001: golden_coin = (money_in>=7'd10)? money_in-7'd10: money_in;
					default: golden_coin = money_in;
				endcase
				case(btn_drink)
					4'b1000: golden_led = (money_in>=7'd75)? 4'b1000: 4'b0111;
					4'b0100: golden_led = (money_in>=7'd60)? 4'b0100: 4'b0011;
					4'b0010: golden_led = (money_in>=7'd25)? 4'b0010: 4'b0001;
					4'b0001: golden_led = (money_in>=7'd10)? 4'b0001: 4'b0000;
					default: golden_led = money_in;
				endcase

				for(k=0; k<1000; k=k+1) begin
					if(out_valid) begin
						if(golden_coin != disp_coin) error_coin=error_coin+1;
						if(golden_led != disp_led) error_drink=error_drink+1;
						k=1000000;
					end
					else #`CYCLE;
				end
				for(m=0; m<1000000; m=m+1) begin
					if(out_valid) #`CYCLE;
					else m=1000000;
				end
			end
			else begin

				// Insert Coin
				testcase = 1;
				for (j=0; j<5; j=j+1) begin
					$fscanf(data_coin_case2,"%d",btn_coin);
					case(btn_coin)
						3'b100: money_in = (money_in+7'd50>7'd95)? 7'd95: money_in+7'd50;
						3'b010: money_in = (money_in+7'd10>7'd95)? 7'd95: money_in+7'd10;
						3'b001: money_in = (money_in+7'd5 >7'd95)? 7'd95: money_in+7'd5;
						default:money_in = money_in;
					endcase
					if(j==3 && i%2==0) begin 
						#96;
						btn_coin = 3'b000; 
						btn_drink= 4'b1000;
						#96;
						btn_drink= 4'b0000;
						#96;
					end
					else if (j==3 && i%2==1) begin
						#96;
						btn_coin = 3'b000; 
						btn_drink= 4'b0100;
						#96;
						btn_drink= 4'b0000;
						#96;
					end
					else if (j==4) begin
						#88;
						btn_coin = 3'b000;
						#8;
					end
					else begin 
						#96;
						btn_coin = 3'b000;
						#8;
					end
				end
				#(`WAIT)

				// Select Drink
				$fscanf(data_drink_case2,"%d", btn_drink);
				case(btn_drink)
					4'b1000: golden_coin = (money_in>=7'd75)? money_in-7'd75: money_in;
					4'b0100: golden_coin = (money_in>=7'd60)? money_in-7'd60: money_in;
					4'b0010: golden_coin = (money_in>=7'd25)? money_in-7'd25: money_in;
					4'b0001: golden_coin = (money_in>=7'd10)? money_in-7'd10: money_in;
					default: golden_coin = money_in;
				endcase
				case(btn_drink)
					4'b1000: golden_led = (money_in>=7'd75)? 4'b1000: 4'b0111;
					4'b0100: golden_led = (money_in>=7'd60)? 4'b0100: 4'b0011;
					4'b0010: golden_led = (money_in>=7'd25)? 4'b0010: 4'b0001;
					4'b0001: golden_led = (money_in>=7'd10)? 4'b0001: 4'b0000;
					default: golden_led = money_in;
				endcase

				for(k=0; k<10000; k=k+1) begin
					if(out_valid) begin
						if(golden_coin != disp_coin) error_coin=error_coin+1;
						if(golden_led != golden_led) error_drink=error_drink+1;
						k=10000;
					end
					else #`CYCLE;
				end
				for(m=0; m<10000; m=m+1) begin
					if(out_valid) #`CYCLE;
					else m=10000;
				end
			end
		end

	if (error_coin == 0 && error_drink == 0) begin
        $display("\n");
        $display("\n");
        $display("        ****************************    _._     _,-'\"\"`-._        ");
        $display("        **  Congratulations !!    **   (,-.`._,'(       |\\`-/|     ");
        $display("        **  Simulation1 PASS!!    **       `-.-' \\ )-`( , o o)     ");
        $display("        ****************************             `-    \\`_`\"'-    ");
        $display("\n");
    end
    else begin
		$display("\n");
		$display("\n");
		$display("        ****************************         |\\      _,,,---,,_     ");
		$display("        **  OOPS!!                **   ZZZzz /,`.-'`'    -.  ;-;;,_  ");
		$display("        **  Simulation1 Failed!!  **        |,4-  ) )-,_. ,\\ (  `'-'");
		$display("        ****************************       '---''(_/--'  `-'\\_)     ");
		$display("         Totally has %d money_err & %d product_err  ", error_coin, error_drink);
		$display("\n");
    end
    $fclose(data_drink_case1);
    $fclose(data_drink_case2);
    $fclose(data_coin_case1);
    $fclose(data_coin_case2);
    $finish;
	end
endmodule
