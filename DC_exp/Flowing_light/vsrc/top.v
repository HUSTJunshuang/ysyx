`timescale 1ns/1ps

module top(
    input           clk,
    input           rst,
    output [15 : 0] led
);

    flowing_led inst_fled(
        .clk    (clk),
        .rst    (rst),

        .led    (led)
    );

endmodule
