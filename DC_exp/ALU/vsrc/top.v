`timescale 1ns/1ps

module top(
    input clk,
    input rst,
    input [3 : 0]   A,
    input [3 : 0]   B,
    input [2 : 0]   opc,
    output          carry,
    output          zero,
    output          overflow,
    output [7:0]    seg0,
    output [7:0]    seg1
);

    /* Add your logic blocks here */
    wire [3 : 0] result;
    wire [3 : 0] bcd;

    // sign seg output
    assign seg0[7] = 1'b1;
    assign bcd = result == 4'b1000 ? 4'h8 :
                 result[3] ? ({1'b0, ~result[2 : 0] + 1'b1}) : result;
    assign seg1 = result[3] ? 8'b1011_1111 : 8'b1111_1111;
    bcd7seg seg_0 (
        .bcd    (bcd),
        .seg    (seg0[6 : 0])
    );

    ALU inst_ALU (
        .opc        (opc),
        .A          (A),
        .B          (B),
        .carry      (carry),
        .zero       (zero),
        .overflow   (overflow),
        .result     (result)
    );

endmodule
