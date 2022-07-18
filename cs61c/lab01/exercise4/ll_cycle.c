#include <stddef.h>
#include "ll_cycle.h"
// #include <stdbool.h>
int ll_has_cycle(node *head) {
    /* TODO: Implement ll_has_cycle */
    node **faster_ptr = &head;
    node **slower_ptr = &head;
    if (head == NULL) {
        return 0;
    }

    while ((*faster_ptr)->next!=NULL)
    {
        if ((*faster_ptr)->next->next == NULL) {
            return 0;
        } else {
            faster_ptr = &((*faster_ptr)->next->next);
            slower_ptr = &((*slower_ptr)->next);
            if (*slower_ptr == *faster_ptr) {
                return 1;
            }
        }
    }
}
