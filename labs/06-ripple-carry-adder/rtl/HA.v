module HA (
    input A, B,
    output Carry, Sum
);
assign Carry = A & B;
assign Sum = A ^ B;
endmodule