#ifndef lcthw_List_h
#define lcthw_List_h

#include <stdlib.h>

struct ListNode;

typedef struct ListNode {
    struct ListNode *next;
    struct ListNode *prev;
    void *value;
} ListNode;

typedef struct List {
    int count;
    ListNode *first;
    ListNode *last;
} List;

List *List_create();
void List_destroy(List *list);
void List_clear(List *list);
void List_clear_destroy(List *list);

#define List_count(A) ((A)->count)
#define List_first(A) ((A)->first != NULL ? (A)->first->value : NULL)
#define List_last(A) ((A)->last != NULL ? (A)->last->value : NULL)

void List_push(List *list, void *value);
void *List_pop(List *list);

void List_unshift(List *list, void *value);
void *List_shift(List *list);

void List_insert(List *list, ListNode *base, ListNode *front);

List *List_split(List *list, int index);
void List_join(List *front, List *back);

void *List_remove(List *list, ListNode *node);

// TODO 替换顺序：先执行#或##（若有），然后替换形参，再替换整个文本，再嵌套替换
// （文本）LIST_FOREACH -> （文本）GEN_VAR(_node_, __LINE__) -> （文本）CONNECT(_node_, line_number)
#define GEN_VAR(id, line) CONNECT(id, line)
#define CONNECT(s1, s2) s1##s2
// BUG use the macro more than once in a block will cause redefinitiao error
#define LIST_FOREACH(L, S, M, V) ListNode *GEN_VAR(_node_, __LINE__) = NULL;\
    ListNode *V = NULL;\
    for(V = GEN_VAR(_node_, __LINE__) = L->S; GEN_VAR(_node_, __LINE__) != NULL; V = GEN_VAR(_node_, __LINE__) = GEN_VAR(_node_, __LINE__)->M)

#endif