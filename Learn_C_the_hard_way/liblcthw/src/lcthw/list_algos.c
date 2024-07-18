#include <lcthw/list_algos.h>
#include <lcthw/dbg.h>

inline void ListNode_swap(ListNode *a, ListNode *b) {
    void *tmp = a->value;
    a->value = b->value;
    b->value = tmp;
}

int List_bubble_sort(List *list, List_compare cmp_func) {
    if (list->count <= 1) return 0;
    int sorted = 1;
    do {
        sorted = 1;
        LIST_FOREACH(list, first, next, cur) {
            if (cur->next) {
                if (cmp_func(cur->value, cur->next->value) > 0) {
                    ListNode_swap(cur, cur->next);
                    sorted = 0;
                }
            }
        }
    } while(!sorted);

    return 0;
}

// inline List *List_merge(List *left, List *right, List_compare cmp_func) {
//     List *result = List_create();
//     void *val = NULL;

//     while (left->count > 0 && right->count > 0) {
//         if (cmp_func(List_first(left), List_first(right)) <= 0) {
//             val = List_shift(left);
//         }
//         else {
//             val = List_shift(right);
//         }
//         List_push(result, val);
//     }
//     while (left->count > 0) {
//         val = List_shift(left);
//         List_push(result, val);
//     }
//     while (right->count > 0) {
//         val = List_shift(right);
//         List_push(result, val);
//     }

//     List_destroy(left);
//     List_destroy(right);

//     return result;
// }

inline void List_merge(List *left, List *right, List_compare cmp_func) {
    ListNode *L = left->first;
    ListNode *R = right->first;

    while (L != NULL && R != NULL) {
        if (cmp_func(L->value, R->value) <= 0)    L = L->next;
        else {
            // pop the first
            right->first = R->next;
            if (right->first != NULL) right->first->prev = NULL;
            else    right->last = NULL;
            right->count--;
            // insert R
            List_insert(left, L, R);
            // update R
            R = right->first;
        }
    }
    // if left completed sort
    if (L == NULL) {
        List_join(left, right);
    }
    else {
        // else - right completed sort, the sort is also completed
        List_destroy(right);
    }

    return ;
}

// List *List_merge_sort(List *list, List_compare cmp_func) {
//     if (list->count <= 1)   return list;
//     List *left = List_create();
//     List *right = List_create();
//     int mid = list->count / 2;
//     LIST_FOREACH(list, first, next, cur) {
//         if (mid > 0)    List_push(left, cur->value);
//         else            List_push(right, cur->value);
//         mid--;
//     }

//     List *sorted_Left = List_merge_sort(left, cmp_func);
//     List *sorted_Right = List_merge_sort(right, cmp_func);
//     if (sorted_Left != left)    List_destroy(left);
//     if (sorted_Right != right)  List_destroy(right);

//     return List_merge(sorted_Left, sorted_Right, cmp_func);
// }

List *List_merge_sort(List *list, List_compare cmp_func) {
    if (list->count <= 1)   return list;
    List *new_list = List_split(list, List_count(list) / 2);

    List *sorted_Left = List_merge_sort(list, cmp_func);
    List *sorted_Right = List_merge_sort(new_list, cmp_func);

    // new version using List_insert
    List_merge(sorted_Left, sorted_Right, cmp_func);
    return sorted_Left;

}