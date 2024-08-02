`timescale 1ns/1ps

module ascii_lut(
    input [7 : 0]       scan_code,
    output reg [7 : 0]  ascii_code
);

    always @(*) begin
        case (scan_code)
            // letter
            8'h1c : ascii_code = 8'h61;
            8'h32 : ascii_code = 8'h62;
            8'h21 : ascii_code = 8'h63;
            8'h23 : ascii_code = 8'h64;
            8'h24 : ascii_code = 8'h65;
            8'h2b : ascii_code = 8'h66;
            8'h34 : ascii_code = 8'h67;
            8'h33 : ascii_code = 8'h68;
            8'h43 : ascii_code = 8'h69;
            8'h3b : ascii_code = 8'h6a;
            8'h42 : ascii_code = 8'h6b;
            8'h4b : ascii_code = 8'h6c;
            8'h3a : ascii_code = 8'h6d;
            8'h31 : ascii_code = 8'h6e;
            8'h44 : ascii_code = 8'h6f;
            8'h4d : ascii_code = 8'h70;
            8'h15 : ascii_code = 8'h71;
            8'h2d : ascii_code = 8'h72;
            8'h1b : ascii_code = 8'h73;
            8'h2c : ascii_code = 8'h74;
            8'h3c : ascii_code = 8'h75;
            8'h2a : ascii_code = 8'h76;
            8'h1d : ascii_code = 8'h77;
            8'h22 : ascii_code = 8'h78;
            8'h35 : ascii_code = 8'h79;
            8'h1a : ascii_code = 8'h7a;
            // number
            8'h45 : ascii_code = 8'h30;
            8'h16 : ascii_code = 8'h31;
            8'h1e : ascii_code = 8'h32;
            8'h26 : ascii_code = 8'h33;
            8'h25 : ascii_code = 8'h34;
            8'h2e : ascii_code = 8'h35;
            8'h36 : ascii_code = 8'h36;
            8'h3d : ascii_code = 8'h37;
            8'h3e : ascii_code = 8'h38;
            8'h46 : ascii_code = 8'h39;
            8'h70 : ascii_code = 8'h30;
            8'h69 : ascii_code = 8'h31;
            8'h72 : ascii_code = 8'h32;
            8'h7a : ascii_code = 8'h33;
            8'h6b : ascii_code = 8'h34;
            8'h73 : ascii_code = 8'h35;
            8'h74 : ascii_code = 8'h36;
            8'h6c : ascii_code = 8'h37;
            8'h75 : ascii_code = 8'h38;
            8'h7d : ascii_code = 8'h39;
            // symbol
            8'h41 : ascii_code = 8'h2c;   // ,
            8'h49 : ascii_code = 8'h2e;   // .
            8'h4a : ascii_code = 8'h2f;   // /
            8'h4c : ascii_code = 8'h3b;   // ;
            8'h52 : ascii_code = 8'h27;   // '
            8'h54 : ascii_code = 8'h5b;   // [
            8'h5b : ascii_code = 8'h5d;   // ]
            8'h5d : ascii_code = 8'h5c;   // \
            8'h0e : ascii_code = 8'h60;   // `
            8'h4e : ascii_code = 8'h2d;   // -
            8'h55 : ascii_code = 8'h3d;   // =
            8'h71 : ascii_code = 8'h2e;   // .(small pad)
            8'h79 : ascii_code = 8'h2b;   // +
            8'h7b : ascii_code = 8'h2d;   // -
            8'h7c : ascii_code = 8'h2a;   // *
            // control
            8'h66 : ascii_code = 8'h08;   // BackSpace
            8'h0d : ascii_code = 8'h09;   // Tab
            8'h5a : ascii_code = 8'h0d;   // Enter
            8'h76 : ascii_code = 8'h1b;   // Esc
            8'h29 : ascii_code = 8'h20;   // Space
            // others
            default : ascii_code = 8'h0;
        endcase
    end

endmodule
