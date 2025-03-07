#include <lcthw/list.h>
#include <lcthw/dbg.h>

List *List_create()
{
    return calloc(1, sizeof(List));
}

void List_destroy(List *list)
{
    LIST_FOREACH(list, first, next, cur) {
        if(cur->prev) {
            free(cur->prev);
        }
    }

    free(list->last);
    free(list);
}


void List_clear(List *list)
{
    LIST_FOREACH(list, first, next, cur) {
        free(cur->value);
    }
}


void List_clear_destroy(List *list)
{
    // List_clear(list);
    // List_destroy(list);
    LIST_FOREACH(list, first, next, cur) {
        free(cur->value);
        if (cur->prev) {
            free(cur->prev);
        }
    }

    free(list->last);
    free(list);
}


void List_push(List *list, void *value)
{
    ListNode *node = calloc(1, sizeof(ListNode));
    check_mem(node);

    node->value = value;

    if(list->last == NULL) {
        list->first = node;
        list->last = node;
    } else {
        list->last->next = node;
        node->prev = list->last;
        list->last = node;
    }

    list->count++;

error:
    return;
}

void *List_pop(List *list)
{
    ListNode *node = list->last;
    return node != NULL ? List_remove(list, node) : NULL;
}

void List_unshift(List *list, void *value)
{
    ListNode *node = calloc(1, sizeof(ListNode));
    check_mem(node);

    node->value = value;

    if(list->first == NULL) {
        list->first = node;
        list->last = node;
    } else {
        node->next = list->first;
        list->first->prev = node;
        list->first = node;
    }

    list->count++;

error:
    return;
}

void *List_shift(List *list)
{
    ListNode *node = list->first;
    return node != NULL ? List_remove(list, node) : NULL;
}

List *List_split(List *list, int index) {
    List *res = List_create();
    check(index >= 0, "The split index must be a positive integer.");
    check(index < list->count, "Split index out of range.");
    if (index == 0) {
        void *tmp = list;
        list = res;
        res = tmp;
    }
    else {
        int cnt = 0;
        LIST_FOREACH(list, first, next, cur) {
            if (++cnt == index) break;
        }
        // attatch res to the splited List
        res->last = list->last;
        res->first = cur->next;
        res->first->prev = NULL;
        res->count = list->count - index;
        // fix the tail of original List
        list->last = cur;
        list->last->next = NULL;
        list->count = index;
    }
    
error:
    return res;
}

void List_insert(List *list, ListNode *base, ListNode *front) {
    if (base->prev == NULL)  list->first = front;
    else    base->prev->next = front;
    front->prev = base->prev;
    front->next = base;
    base->prev = front;
    list->count++;

    return ;
}

void List_join(List *front, List *back) {
    if (back->last == NULL) return ;
    front->count += back->count;
    if (front->last != NULL) {
        back->first->prev = front->last;
        front->last->next = back->first;
    }
    else {
        front->first = back->first;
    }
    front->last = back->last;
    free(back);

    return ;
}

void *List_remove(List *list, ListNode *node)
{
    void *result = NULL;

    check(list->first && list->last, "List is empty.");
    check(node, "node can't be NULL");

    if(node == list->first && node == list->last) {
        list->first = NULL;
        list->last = NULL;
    } else if(node == list->first) {
        list->first = node->next;
        check(list->first != NULL, "Invalid list, somehow got a first that is NULL.");
        list->first->prev = NULL;
    } else if (node == list->last) {
        list->last = node->prev;
        check(list->last != NULL, "Invalid list, somehow got a next that is NULL.");
        list->last->next = NULL;
    } else {
        ListNode *after = node->next;
        ListNode *before = node->prev;
        after->prev = before;
        before->next = after;
    }

    list->count--;
    result = node->value;
    free(node);

error:
    return result;
}