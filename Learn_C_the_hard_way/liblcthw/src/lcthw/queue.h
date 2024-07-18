#ifndef lcthw_Queue_h
#define lcthw_Queue_h

#include <stdlib.h>
#include <lcthw/list.h>

#define Queue List
#define Queue_create List_create

#define Queue_destroy(queue) List_destroy(queue)

#define Queue_send(queue, value) List_push(queue, value)
#define Queue_recv(queue) List_shift(queue)

#define Queue_count(queue) List_count(queue)
#define Queue_peek(queue) List_first(queue)

#define QUEUE_FOREACH(queue, cur) ListNode *cur = NULL;\
    for(cur = queue->first; cur != NULL; cur = cur->next)

#endif