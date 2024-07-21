#include <stdio.h>
#include <nvboard.h>
#include <Vtop.h>

// set top module name
static TOP_NAME dut;

// declaration of bind func
void nvboard_bind_all_pins(TOP_NAME *top);

// func to go on to next cycle
static void single_cycle() {
	dut.clk = 0; dut.eval();
	dut.clk = 1; dut.eval();
}

// reset func
static void reset(int n) {
	dut.rst = 1;
	while (n-- > 0)	single_cycle();
	dut.rst = 0;
}

int main() {
	// bind port and init board
	nvboard_bind_all_pins(&dut);
	nvboard_init();
	reset(10);

	// main loop
	while (true) {
		nvboard_update();
		single_cycle();
	}

	return 0;
}
