`timescale 1ns/1ps

module BarrelShifter #(
    parameter DWIDTH = 8
) (
    input                   AL,
    input                   LR,
    input [SDEPTH - 1 : 0]  shamt,
    input [DWIDTH - 1 : 0]  din,
    output [DWIDTH - 1 : 0] dout
);

    localparam SDEPTH = $clog2(DWIDTH);

    wire sign_bit;
    wire [DWIDTH - 1 : 0] barrel_out [SDEPTH : 0];
    assign barrel_out[0] = din;
    assign dout = barrel_out[SDEPTH];

    generate
        for (genvar i = 0; i < SDEPTH; i = i + 1) begin : shifter
            barrel #(
                .DWIDTH     (DWIDTH),
                .STEP_SIZE  (1 << i)
            ) barrel_layer (
                .LR         (LR),
                .shamt      (shamt[i]),
                .sign_bit   (sign_bit),
                .din        (barrel_out[i]),
                .dout       (barrel_out[i + 1])
            );
        end
    endgenerate

    MuxTemplate #(
        .KEY_NUM    (2),
        .KEY_LEN    (1),
        .DATA_LEN   (1)
    ) AL_MUX (
        .key            (AL),
        .lut            ({{1'b1, din[DWIDTH - 1]}, {1'b0, 1'b0}}),
        .default_data   (),
        .out            (sign_bit)
    );

endmodule
