`timescale 1ns/1ps

module top(
    input           clk,
    input           rst,
    input           next,   // bind center button
    input           AL,     // bind SW15, ON for Arithmetic shift, OFF for Logic shift
    input [3 : 0]   btn,    // bind up, down, left and right button
    input [2 : 0]   shamt,  // bind SW2 ~ SW0
    output [7:0]    seg0,   // for LFSR, bind the rightmost two
    output [7:0]    seg1,
    output [7:0]    seg2,   // for Barrel Shifter, bind the leftmost two
    output [7:0]    seg3
);

    /* Add your logic blocks here */
    // Barrel Shifter
    reg LR, shift_en;
    reg [7 : 0] bsreg;
    wire [7 : 0] bsout;
    // LFSR
    wire [7 : 0] rand_out;
    // button
    reg [3 : 0] btn_r;
    reg next_r;

    LFSR inst_LFSR (
        .clk    (next_r),
        .rst    (rst),
        .dout   (rand_out)
    );

    BarrelShifter inst_BS (
        .AL     (AL),
        .LR     (LR),
        .shamt  (shamt & {3{shift_en}}),
        .din    (bsreg),
        .dout   (bsout)
    );
    // BS controller
    always @(posedge clk) begin
        if (rst) begin
            bsreg <= 'h0;
            LR <= 1'b0;
            shift_en <= 1'b0;
        end
        else begin
            // act when button released
            // update value
            if (btn_r[3] & ~btn[3]) begin
                bsreg <= bsreg + 1'b1;
            end
            else if (btn_r[2] & ~btn[2]) begin
                bsreg <= bsreg - 1'b1;
            end
            else begin
                bsreg <= bsout;
            end
            // set shifter config
            if (btn_r[1] & ~btn[1]) begin
                LR <= 1'b1;
                shift_en <= 1'b1;
            end
            else if (btn_r[0] & ~btn[0]) begin
                LR <= 1'b0;
                shift_en <= 1'b1;
            end
            else begin
                LR <= 1'b0;
                shift_en <= 1'b0;
            end
        end
    end
    // button controller
    always @(posedge clk) begin
        next_r <= next;
        btn_r <= btn;
    end

    // display
    bcd7seg seg_0 (
        .bcd    (rand_out[3 : 0]),
        .seg    (seg0[6 : 0])
    );
    bcd7seg seg_1 (
        .bcd    (rand_out[7 : 4]),
        .seg    (seg1[6 : 0])
    );
    bcd7seg seg_2 (
        .bcd    (bsreg[3 : 0]),
        .seg    (seg2[6 : 0])
    );
    bcd7seg seg_3 (
        .bcd    (bsreg[7 : 4]),
        .seg    (seg3[6 : 0])
    );

endmodule
