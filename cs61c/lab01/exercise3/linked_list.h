#ifndef LINKED_LIST_H
#define LINKED_LIST_H

typedef struct Node {
    int data;
    struct Node *next;
} Node;

Node *create_node(int data);
void free_list(Node *head);
void add_to_front(struct Node **head, int data);
void print_list(struct Node *head);
void reverse_list(struct Node **head);
void add_to_back(Node **head, int data);

/* use ptr if we want to update in-place. If we use plain int, only the copy will be updated */
// void update_integer(int * int_to_upgrade); 
/* How to call update_integer to update data filed in a LList node  */
// update_integer(&(node1->data))

/* if we want to update the node->data directly, recall the note is a pointer, we want to update that
pointer, then we need a Node** data type */
// void update_head(Node **head_to_update);
/* How to call update_integer to update data filed in a LList node  */
// update_head(&(head_to_update));
// As head_to_update itself is a pointer, we just need to get the address of that pointer


#endif // LINKED_LIST_H
