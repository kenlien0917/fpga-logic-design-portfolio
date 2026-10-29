`define zero  7'b1000000
`define one   7'b1111001
`define two   7'b0100100
`define three 7'b0110000
`define four  7'b0011001
`define five  7'b0010010
`define six   7'b0000010
`define seven 7'b1111000
`define eight 7'b0000000
`define nine  7'b0010000

module display(
	input [7:0] coin,
	output reg [13:0] coin_7seg
);

	always @(*) begin
		case(coin)
			10'd5	: coin_7seg = {`zero, `five};
			10'd10	: coin_7seg = {`one, `zero};
			10'd15	: coin_7seg = {`one, `five};
			10'd20	: coin_7seg = {`two, `zero};
			10'd25	: coin_7seg = {`two, `five};
			10'd30	: coin_7seg = {`three, `zero};
			10'd35	: coin_7seg = {`three, `five};
			10'd40	: coin_7seg = {`four, `zero};
			10'd45	: coin_7seg = {`four, `five};
			10'd50	: coin_7seg = {`five, `zero};
			10'd55	: coin_7seg = {`five, `five};
			10'd60	: coin_7seg = {`six, `zero};
			10'd65	: coin_7seg = {`six, `five};
			10'd70	: coin_7seg = {`seven, `zero};
			10'd75	: coin_7seg = {`seven, `five};
			10'd80	: coin_7seg = {`eight, `zero};
			10'd85	: coin_7seg = {`eight, `five};
			10'd90	: coin_7seg = {`nine, `zero};
			10'd95	: coin_7seg = {`nine, `five};
			10'd99	: coin_7seg = {`nine, `nine};
			default : coin_7seg = {`zero, `zero};
		endcase
	end
endmodule
