`timescale 1ns/1ps

module keyboard_controller (
    input               clk,
    input               rst,
    input               ready,
    input               overflow,
    input [7 : 0]       data,
    output              nextdata_n,
    // just for check
    output reg [7 : 0]  scan_code_r,
    output reg [7 : 0]  ascii_code_r,
    output reg          valid,
    output reg [7 : 0]  press_cnt,
    output reg          CTRL,
    output reg          SHIFT,
    output reg          ALT,
    output reg          CAPS
);

    // special key
    // reg CTRL, SHIFT, ALT, CAPS;
    reg RELEASE, EXT;
    // decoder
    wire [7 : 0] ascii_code;

    // read data
    assign nextdata_n = ~ready;

    // RELEASE & EXT & counter
    always @(posedge clk) begin
        if (rst) begin
            RELEASE <= 1'b0;
            EXT <= 1'b0;
            press_cnt <= 'h0;
        end
        else begin
            if (~nextdata_n) begin
                // RELEASE
                if (data == 8'hf0) begin
                    RELEASE <= 1'b1;
                    press_cnt <= press_cnt + 1'b1;
                end
                else if (data == 8'he0) RELEASE <= RELEASE;
                else                    RELEASE <= 1'b0;
                // EXT
                if (data == 8'he0)      EXT <= 1'b1;
                else                    EXT <= 1'b0;
            end
        end
    end

    // special key
    always @(posedge clk) begin
        if (rst) begin
            CTRL <= 1'b0;
            SHIFT <= 1'b0;
            ALT <= 1'b0;
            CAPS <= 1'b0;
        end
        else begin
            if (~nextdata_n) begin
                if (data == 8'h14) begin
                    CTRL <= ~RELEASE;
                end
                if (data == 8'h12) begin
                    SHIFT <= ~RELEASE;
                end
                if (data == 8'h11) begin
                    ALT <= ~RELEASE;
                end
                if (data == 8'h58 && ~RELEASE) begin
                    CAPS <= ~CAPS;
                end
            end
        end
    end

    // basic key
    ascii_lut decoder (
        .scan_code  (data),
        .ascii_code (ascii_code)
    );
    always @(posedge clk) begin
        if (rst) begin
            scan_code_r <= 'h0;
            ascii_code_r <= 'h0;
            valid <= 1'b0;
        end
        else begin
            if (~nextdata_n && ~RELEASE) begin
                if (EXT) begin
                    case (data)
                        8'h6b : $display("<←>");
                        8'h72 : $display("<↓>");
                        8'h74 : $display("<→>");
                        8'h75 : $display("<↑>");
                        8'h70 : $display("<Ins>");
                        8'h71 : $display("<Del>(0x7f)");
                        8'h6c : $display("<Home>");
                        8'h69 : $display("<End>");
                        8'h7d : $display("<Page Up>");
                        8'h7a : $display("<Page Down>");
                        default : begin
                            $display("%0c(0x%0x)", ascii_code, ascii_code);
                            scan_code_r <= data;
                            ascii_code_r <= ascii_code;
                            valid <= 1'b1;
                        end
                    endcase
                end
                else if (SHIFT) begin
                    case (data)
                        // top number
                        8'h0e : $display("%0c(0x%0x)", 8'h7e, 8'h7e);
                        8'h16 : $display("%0c(0x%0x)", 8'h21, 8'h21);
                        8'h1e : $display("%0c(0x%0x)", 8'h40, 8'h40);
                        8'h26 : $display("%0c(0x%0x)", 8'h23, 8'h23);
                        8'h25 : $display("%0c(0x%0x)", 8'h24, 8'h24);
                        8'h2e : $display("%0c(0x%0x)", 8'h25, 8'h25);
                        8'h36 : $display("%0c(0x%0x)", 8'h5e, 8'h5e);
                        8'h3d : $display("%0c(0x%0x)", 8'h26, 8'h26);
                        8'h3e : $display("%0c(0x%0x)", 8'h2a, 8'h2a);
                        8'h46 : $display("%0c(0x%0x)", 8'h28, 8'h28);
                        8'h45 : $display("%0c(0x%0x)", 8'h29, 8'h29);
                        8'h4e : $display("%0c(0x%0x)", 8'h5f, 8'h5f);
                        8'h55 : $display("%0c(0x%0x)", 8'h2b, 8'h2b);
                        // middle symbol
                        8'h41 : $display("%0c(0x%0x)", 8'h3c, 8'h3c);
                        8'h49 : $display("%0c(0x%0x)", 8'h3e, 8'h3e);
                        8'h4a : $display("%0c(0x%0x)", 8'h3f, 8'h3f);
                        8'h4c : $display("%0c(0x%0x)", 8'h3a, 8'h3a);
                        8'h52 : $display("%0c(0x%0x)", 8'h22, 8'h22);
                        8'h54 : $display("%0c(0x%0x)", 8'h7b, 8'h7b);
                        8'h5b : $display("%0c(0x%0x)", 8'h7d, 8'h7d);
                        8'h5d : $display("%0c(0x%0x)", 8'h7c, 8'h7c);
                        // letter and others
                        default : begin
                            if (ascii_code >= 8'h61 && ascii_code <= 8'h7a) begin
                                $display("%0c(0x%0x)", CAPS ? ascii_code : (ascii_code - 8'h20), CAPS ? ascii_code : (ascii_code - 8'h20));
                                scan_code_r <= data;
                                ascii_code_r <= CAPS ? ascii_code : (ascii_code - 8'h20);
                                valid <= 1'b1;
                            end
                            else begin
                                $display("%0c(0x%0x)", ascii_code, ascii_code);
                                scan_code_r <= data;
                                ascii_code_r <= ascii_code;
                                valid <= 1'b1;
                            end
                        end
                    endcase
                end
                else begin
                    if (ascii_code >= 8'h61 && ascii_code <= 8'h7a) begin
                        $display("%0c(0x%0x)", CAPS ? (ascii_code - 8'h20) : ascii_code, CAPS ? (ascii_code - 8'h20) : ascii_code);
                        scan_code_r <= data;
                        ascii_code_r <= CAPS ? (ascii_code - 8'h20) : ascii_code;
                        valid <= 1'b1;
                    end
                    else begin
                        $display("%0c(0x%0x)", ascii_code, ascii_code);
                        scan_code_r <= data;
                        ascii_code_r <= ascii_code;
                        valid <= 1'b1;
                    end
                end
            end
            else begin
                if (RELEASE) begin
                    scan_code_r <= 'h0;
                    ascii_code_r <= 'h0;
                    valid <= 1'b0;
                end
            end
        end
    end

endmodule
