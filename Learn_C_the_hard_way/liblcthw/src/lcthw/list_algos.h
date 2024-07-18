#ifndef list_algos_h
#define list_algos_h

#include <lcthw/list.h>

typedef int (*List_compare)(const char *s1, const char *s2);

int List_bubble_sort(List *list, List_compare cmp_func);
List *List_merge_sort(List *list, List_compare cmp_func);

#endif