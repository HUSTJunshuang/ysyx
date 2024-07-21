`timescale 1ns/1ps

module switch(
	input a,
	input b,
	output f
);

	assign f = a ^ b;

endmodule
