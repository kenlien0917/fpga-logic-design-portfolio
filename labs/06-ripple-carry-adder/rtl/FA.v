`include "HA.v"

module FA (
    input A, B,
    input Cin,
    output Cout, sum
);
wire w1, w2, w3;

HA h0(
    .A(A),
    .B(B),
    .Sum(w1),
    .Carry(w2)
);
HA h1(
    .A(w1),
    .B(Cin),
    .Sum(sum),
    .Carry(w3)
);
assign Cout = w2 | w3;

endmodule