`timescale 1ns/1ps

module MuxTemplate #(
    parameter KEY_NUM = 2,
    parameter KEY_LEN = 1,
    parameter DATA_LEN = 1,
    parameter HAS_DEFAULT = 0
) (
    input [KEY_LEN - 1 : 0]     key,
    input [KEY_NUM * (KEY_LEN + DATA_LEN) - 1 : 0]  lut,
    input [DATA_LEN - 1 : 0]                        default_data,
    output reg [DATA_LEN - 1 : 0]                   out
);

    localparam PAIR_LEN = KEY_LEN + DATA_LEN;
    integer i;
    genvar gen_i;
    // wire [PAIR_LEN - 1 : 0] pair_list   [KEY_NUM - 1 : 0];
    wire [KEY_LEN - 1 : 0]  key_list    [KEY_NUM - 1 : 0];
    wire [DATA_LEN - 1 : 0] data_list   [KEY_NUM - 1 : 0];

    reg [DATA_LEN - 1 : 0]  lut_out;
    reg hit;

    always @(*) begin
        lut_out = 'h0;
        hit = 0;
        for (i = 0; i < KEY_NUM; i = i + 1) begin
            lut_out = lut_out | ({DATA_LEN{key == key_list[i]}} & data_list[i]);
            hit = hit | (key == key_list[i]);
        end
        if (!HAS_DEFAULT) begin
            out = lut_out;
        end
        else begin
            out = hit ? lut_out : default_data;
        end
    end

    generate
        for (gen_i = 0; gen_i < KEY_NUM; gen_i = gen_i + 1) begin : dispatcher
            assign {key_list[gen_i], data_list[gen_i]} = lut[PAIR_LEN * gen_i +: PAIR_LEN];
        end
    endgenerate

endmodule
