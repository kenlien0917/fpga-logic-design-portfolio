`include "FA.v"
module RCA_4 (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
wire c1, c2, c3;

FA f0(
    .A(A[0]),
    .B(B[0]),
    .Cin(Cin),
    .sum(Sum[0]),
    .Cout(c1)
);
FA f1(
    .A(A[1]),
    .B(B[1]),
    .Cin(c1),
    .sum(Sum[1]),
    .Cout(c2)
);
FA f2(
    .A(A[2]),
    .B(B[2]),
    .Cin(c2),
    .sum(Sum[2]),
    .Cout(c3)
);
FA f3(
    .A(A[3]),
    .B(B[3]),
    .Cin(c3),
    .sum(Sum[3]),
    .Cout(Cout)
);

endmodule