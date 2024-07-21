`timescale 1ns/1ps

module switch_tb ();

    /* ---------- parameter definition ---------- */
    parameter real CLK_PERIOD_PS = 5;   // 200 MHz

    /* ------------ port declaration ------------ */
    // input declaration
    reg clk = 0;
    reg a;
    reg b;
    // outout declaration
    wire f;
    // test status
    logic test_pass;

    /* ----------- Clock and Test case ---------- */
    // clock
    initial begin : CLK
        forever begin
            clk = #(CLK_PERIOD_PS / 2) ~clk;
        end
    end

    initial begin : TEST
        # 30;
        test_pass = 1;
        test_switch(1'b0, 1'b0);
        test_switch(1'b0, 1'b1);
        test_switch(1'b1, 1'b0);
        test_switch(1'b1, 1'b1);
        repeat (10) @(posedge clk);
        if (test_pass) begin
            $display("Test passed, finished @%t", $time);
        end
        else begin
            $display("Test failed, finished @%t", $time);
        end
        $finish;
    end

    /* ------------- module instance ------------ */
    switch dut(
        .a  (a),
        .b  (b),

        .f  (f)
    );

    /* ---------- test task definition ---------- */
    task automatic test_switch(
        input a_in,
        input b_in
    );
        @(posedge clk) begin
            // set input
            a = a_in;
            b = b_in;
            // check output
            if (f != a ^ b) begin
                $error("f get %0d, expected %0d(a = %0d, b = %0d)", f, a ^ b, a, b);
                test_pass = 0;
            end
        end
    endtask

endmodule
