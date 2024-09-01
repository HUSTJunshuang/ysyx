`timescale 1ns/1ps

module top(
    input           clk,
    input           rst,
    input [9 : 0]   sw,
    output [1 : 0]  ledr
);

    /* Add your logic blocks here */
    wire [1 : 0] y = sw[1 : 0];
    wire [1 : 0] x [3 : 0];
    wire [15 : 0] lut;

    genvar i;

    generate
        for (i = 0; i < 4; i = i + 1) begin : dispatcher
            assign x[i] = sw[(i + 1) * 2 +: 2];
            assign lut[i * 4 +: 4] = {i[1 : 0], x[i]};
        end
    endgenerate

    MuxTemplate #(
        .KEY_NUM        (4),
        .KEY_LEN        (2),
        .DATA_LEN       (2),
        .HAS_DEFAULT    (0)
    ) mux4to1 (
        .key            (y),
        .lut            (lut),
        .default_data   ('h0),
        .out            (ledr)
    );

endmodule
