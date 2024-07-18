#ifndef lcthw_Stack_h
#define lcthw_Stack_h

#include <stdlib.h>
#include <lcthw/list.h>

#define Stack List
#define Stack_create List_create

#define Stack_destroy(stack) List_destroy(stack)

#define Stack_push(stack, value) List_push(stack, value)
#define Stack_pop(stack) List_pop(stack)

#define Stack_count(stack) List_count(stack)
#define Stack_peek(stack) List_last(stack)

#define STACK_FOREACH(stack, cur) ListNode *cur = NULL;\
    for(cur = stack->last; cur != NULL; cur = cur->prev)

#endif