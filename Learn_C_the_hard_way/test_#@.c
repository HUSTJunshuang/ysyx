#include <stdio.h>

#define TO_CHAR(x) #@x

int main() {
	char a = TO_CHAR(a);
	printf("%c\n", a);
	return 0;
}
