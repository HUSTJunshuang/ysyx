// stringizer.cpp
#include <stdio.h>
#define stringer( x ) printf( #x "\n" )
int main() {
   stringer( In quotes in the printf     function call );
   stringer( "In quotes when printed to the screen" );
   stringer( test more composition       "This: \"          prints an escaped double quote" );
}
