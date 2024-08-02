`timescale 1ns/1ps

module adder (
    input [3 : 0]   A,
    input [3 : 0]   B,
    input           sub,
    output          carry,
    output          zero,
    output          overflow,
    output [3 : 0]  result
);

    wire [3 : 0] Bext = ({4{sub}} ^ B);

    assign {carry, result} = A + Bext + {{3'h0}, sub};
    assign zero = ~(|result);
    assign overflow = (A[3] == Bext[3]) && (result[3] != A[3]);

endmodule