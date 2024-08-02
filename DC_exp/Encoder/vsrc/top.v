`timescale 1ns/1ps

module top(
    input           clk,
    input           rst,
    input [8 : 0]   sw,
    output [3 : 0]  ledr,
    output [7 : 0]  seg0
);

    /* Add your logic blocks here */
    wire [2 : 0] bcd;
    wire bcd_valid;

    assign ledr = {bcd_valid, bcd};

    priority_encoder encoder83 (
        .in     (sw[7 : 0]),
        .en     (sw[8]),
        .out    (bcd),
        .valid  (bcd_valid)
    );

    bcd7seg seg_0(
        .bcd    ({1'b0, bcd}),
        .seg    (seg0[6 : 0])
    );

endmodule
