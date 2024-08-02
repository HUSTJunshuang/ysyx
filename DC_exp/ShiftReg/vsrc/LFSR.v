`timescale 1ns/1ps

module LFSR (
    input           clk,
    input           rst,
    output [7 : 0]  dout
);

    reg [7 : 0] shift_reg = 'h1;
    wire x8 = (^shift_reg[4 : 2]) ^ shift_reg[0];

    assign dout = shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 'h1;
        end
        else begin
            shift_reg <= {x8, shift_reg[7 : 1]};
        end
    end

endmodule
