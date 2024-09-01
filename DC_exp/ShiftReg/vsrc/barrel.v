`timescale 1ns/1ps

module barrel #(
    parameter DWIDTH = 8,
    parameter STEP_SIZE = 1
) (
    input                   LR,
    input                   shamt,
    input                   sign_bit,
    input [DWIDTH - 1 : 0]  din,
    output [DWIDTH - 1 : 0] dout
);

    genvar i;
    generate
        wire [4 * (2 + 1) - 1 : 0] lut [DWIDTH - 1 : 0];
        for (i = 0; i < DWIDTH; i = i + 1) begin : barrel_muxes
            assign lut[i] = {{2'b11, (i < STEP_SIZE) ? 1'b0 : din[i - STEP_SIZE]}, {2'b10, din[i]},
                            {2'b01, (i + STEP_SIZE >= DWIDTH) ? sign_bit : din[i + STEP_SIZE]},
                            {2'b00, din[i]}};
            MuxTemplate #(
                .KEY_NUM    (4),
                .KEY_LEN    (2),
                .DATA_LEN   (1)
            ) barrel_MUX (
                .key            ({LR, shamt}),
                .lut            (lut[i]),
                .default_data   (),
                .out            (dout[i])
            );
        end
    endgenerate

endmodule
