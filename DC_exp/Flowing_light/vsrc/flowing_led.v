`timescale 1ns/1ps

module flowing_led(
	input 				clk,
	input 				rst,
	output reg [15 : 0]	led
);

	reg [31 : 0] cnt;

	always @(posedge clk) begin
		if (rst) begin
			led <= 'h1;
			cnt <= 'h1;
		end
		else begin
			if (cnt == 0)	led <= {led[14 : 0], led[15]};
			cnt <= (cnt >= 5000000 ? 'h0 : cnt + 1);
		end
	end

endmodule
