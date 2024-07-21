#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "Vswitch.h"
#include "verilated_vcd_c.h"

int main() {
	// define context pointer and top module pointer
	VerilatedContext* cp = new VerilatedContext;
	Vswitch* top = new Vswitch{cp};
	// enable trace and define VerilatedVcdC object
	Verilated::traceEverOn(true);
	VerilatedVcdC *tfp = new VerilatedVcdC;
	// set trace level and output file
	top->trace(tfp, 3);
	Verilated::mkdir("logs");
	tfp->open("logs/sim.vcd");

	char input = '0';
	while (input !=  'c') {
		int a = rand() & 1;
		int b = rand() & 1;
		top->a = a;
		top->b = b;
		top->eval();
		// dump waveforms after eval()
		tfp->dump(cp->time());
		assert(top->f == (a ^ b));
		printf("a = %d, b = %d, f = %d @%4ldps", a, b, top->f, cp->time());
		cp->timeInc(5);
		
		scanf("%c", &input);
	}
	top->final();
	// close dump file
	tfp->close();
	delete top;
	delete cp;
	return 0;
}
