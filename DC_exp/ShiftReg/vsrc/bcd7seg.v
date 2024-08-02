`timescale 1ns/1ps

module bcd7seg (
    input [3 : 0]       bcd,
    output reg [6 : 0]  seg
);

    always @(*) begin
        case (bcd)
            4'h0 : begin
                seg = ~7'b0111111;
            end
            4'h1 : begin
                seg = ~7'b0000110;
            end
            4'h2 : begin
                seg = ~7'b1011011;
            end
            4'h3 : begin
                seg = ~7'b1001111;
            end
            4'h4 : begin
                seg = ~7'b1100110;
            end
            4'h5 : begin
                seg = ~7'b1101101;
            end
            4'h6 : begin
                seg = ~7'b1111101;
            end
            4'h7 : begin
                seg = ~7'b0000111;
            end
            4'h8 : begin
                seg = ~7'b1111111;
            end
            4'h9 : begin
                seg = ~7'b1101111;
            end
            4'ha : begin
                seg = ~7'b1110111;
            end
            4'hb : begin
                seg = ~7'b1111100;
            end
            4'hc : begin
                seg = ~7'b0111001;
            end
            4'hd : begin
                seg = ~7'b1011110;
            end
            4'he : begin
                seg = ~7'b1111001;
            end
            4'hf : begin
                seg = ~7'b1110001;
            end
            default : begin
                seg = 7'b1111111;
            end
        endcase
    end

endmodule
