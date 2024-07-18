#include <stdio.h>

void show_time() {
	printf("Info from source file <%s>:%d, function <%s>\n", __FILE__, __LINE__ + 1, __func__);
	printf("Compile time: %s, translate time: %s\n", __DATE__, __TIME__);
	return ;
}

int main() {
	show_time();
	printf("\nChecking host env\n");
	printf("__STDC__: %d\n", __STDC__);
	printf("__STDC_HOSTED__: %d\n", __STDC_HOSTED__);
#ifndef __STDC_NO_ATOMICS__
	printf("Compiler supports optional atomics lib\n");
#endif
#if !defined(__STDC_NO_COMPLEX__)
	printf("Compiler supports optional complex number lib\n");
#endif
#ifndef __STDC_NO_THREADS__
	printf("Compiler supports optional threads lib\n");
#endif
#ifndef __STDC_NO_VAL__
	printf("Compiler supports optional standard Variable Length Arrays\n");
#endif
	printf("__STDC_VERSION__: %ld\n", __STDC_VERSION__);

	return 0;
}
