`timescale 1ns/1ps

module ALU (
    input [2 : 0]   opc,
    input [3 : 0]   A,
    input [3 : 0]   B,
    output          carry,
    output          zero,
    output          overflow,
    output [3 : 0]  result
);

    wire carry_adder, zero_adder, overflow_adder;
    wire carry_suber, zero_suber, overflow_suber;
    wire [3 : 0] result_adder, result_suber;
    wire [8 * (3 + 4) - 1 : 0] result_lut = {{3'b111, 3'b0, zero_suber},
                                            {3'b110, 3'b0, result_suber[3] ^ overflow_suber},
                                            {3'b101, A ^ B}, {3'b100, A | B}, {3'b011, A & B},
                                            {3'b010, ~A}, {3'b001, result_suber},
                                            {3'b000, result_adder}};

    adder inst_adder (
        .A          (A),
        .B          (B),
        .sub        (1'b0),
        .carry      (carry_adder),
        .zero       (zero_adder),
        .overflow   (overflow_adder),
        .result     (result_adder)
    );
    adder inst_suber (
        .A          (A),
        .B          (B),
        .sub        (1'b1),
        .carry      (carry_suber),
        .zero       (zero_suber),
        .overflow   (overflow_suber),
        .result     (result_suber)
    );

    // result MUX
    MuxTemplate #(
        .KEY_NUM    (8),
        .KEY_LEN    (3),
        .DATA_LEN   (4),
        .HAS_DEFAULT(0)
    ) result_MUX (
        .key            (opc),
        .lut            (result_lut),
        .default_data   ('h0),
        .out            (result)
    );
    assign carry = (opc == 3'b000) ? carry_adder : (opc == 3'b001) ? carry_suber : 1'b0;
    assign zero = (opc == 3'b000) ? zero_adder : (opc == 3'b001) ? zero_suber : 1'b0;
    assign overflow = (opc == 3'b000) ? overflow_adder : (opc == 3'b001) ? overflow_suber : 1'b0;

endmodule
