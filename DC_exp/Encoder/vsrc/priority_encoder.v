`timescale 1ns/1ps

module priority_encoder #(
    parameter OUTPUT_WIDTH = 3
) (
    input [(1 << OUTPUT_WIDTH) - 1 : 0] in,
    input                               en,
    output reg [OUTPUT_WIDTH - 1 : 0]   out,
    output reg                          valid
);

    localparam INPUT_WIDTH = 1 << OUTPUT_WIDTH;
    integer i;

    always @(*) begin
        if (en) begin
            out = 'h0;
            valid = |in;
            for (i = 0; i < INPUT_WIDTH; i = i + 1) begin
                if (in[i])  out = i[OUTPUT_WIDTH - 1 : 0];
            end
        end
        else begin
            out = 'h0;
            valid = 1'b0;
        end
    end

endmodule
