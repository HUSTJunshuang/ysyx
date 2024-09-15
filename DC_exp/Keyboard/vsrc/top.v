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
    wire [7 : 0] scan_code;
    wire [7 : 0] ascii_code;
    wire valid;
    wire [6 : 0] tmp_s0, tmp_s1, tmp_s2, tmp_s3, tmp_s6, tmp_s7;
    wire [7 : 0] press_cnt;
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
        .scan_code_r    (scan_code),
        .ascii_code_r   (ascii_code),
        .valid          (valid),
        .press_cnt  (press_cnt),
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
    bcd7seg S0 (
        .bcd    (scan_code[3 : 0]),
        .seg    (tmp_s0)
    );
    bcd7seg S1 (
        .bcd    (scan_code[7 : 4]),
        .seg    (tmp_s1)
    );

    bcd7seg S2 (
        .bcd    (ascii_code[3 : 0]),
        .seg    (tmp_s2)
    );
    bcd7seg S3 (
        .bcd    (ascii_code[7 : 4]),
        .seg    (tmp_s3)
    );

    bcd7seg S6 (
        .bcd    (press_cnt[3 : 0]),
        .seg    (seg6[6 : 0])
    );
    bcd7seg S7 (
        .bcd    (press_cnt[7 : 4]),
        .seg    (seg7[6 : 0])
    );
    assign seg0 = valid ? {1'b1, tmp_s0} : 8'hff;
    assign seg1 = valid ? {1'b1, tmp_s1} : 8'hff;
    assign seg2 = valid ? {1'b1, tmp_s2} : 8'hff;
    assign seg3 = valid ? {1'b1, tmp_s3} : 8'hff;
    assign seg4 = 8'hff;
    assign seg5 = 8'hff;
    // assign seg6 = 8'hff;
    // assign seg7 = 8'hff;

endmodule
