`timescale 1ns/1ps

module top(
    input           clk,
    input           rst,
    input           ps2_clk,
    input           ps2_data,
    output          CTRL,
    output          SHIFT,
    output          ALT,
    output          CAPS,
    output [7:0]    seg0,
    output [7:0]    seg1,
    output [7:0]    seg2,
    output [7:0]    seg3,
    output [7:0]    seg4,
    output [7:0]    seg5,
    output [7:0]    seg6,
    output [7:0]    seg7
);

    /* Add your logic blocks here */
    // keyboard interface
    wire nextdata_n;
    wire [7 : 0] kb_data;
    wire kb_ready, kb_overflow;

    ps2_keyboard inst_kb (
        .clk        (clk),
        .clrn       (~rst),
        .ps2_clk    (ps2_clk),
        .ps2_data   (ps2_data),
        .nextdata_n (nextdata_n),
        .data       (kb_data),
        .ready      (kb_ready),
        .overflow   (kb_overflow)
    );
    // keyboard controller
    keyboard_controller inst_kb_ctrl (
        .clk        (clk),
        .rst        (rst),
        .ready      (kb_ready),
        .overflow   (kb_overflow),
        .data       (kb_data),
        .nextdata_n (nextdata_n),
        .CTRL       (CTRL),
        .SHIFT      (SHIFT),
        .ALT        (ALT),
        .CAPS       (CAPS)
    );
    // always @(posedge clk) begin
    //     if (kb_ready) begin
    //         $display("Received Data: 0x%x", kb_data);
    //     end
    //     if (kb_overflow) begin
    //         $display("Keyboard overflowed!");
    //     end
    // end

    // display
    assign seg0 = 8'hff;
    assign seg1 = 8'hff;
    assign seg2 = 8'hff;
    assign seg3 = 8'hff;
    assign seg4 = 8'hff;
    assign seg5 = 8'hff;
    assign seg6 = 8'hff;
    assign seg7 = 8'hff;

endmodule
