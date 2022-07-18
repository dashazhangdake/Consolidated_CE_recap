#include <string.h>
#include "ex1.h"

/* Returns the number of times LETTER appears in STR.
There are two different ways to iterate through a string.
1st way hint: strlen() may be useful
2nd way hint: all strings end in a null terminator */
int num_occurrences(char *str, char letter) {
    /* TODO: implement num_occurances */
    int occurrence = 0; // Anyway, we need a variable to store the returned value
    /* First way, using strlen and for loop */
    // int str_len = strlen(str);

    // for (int i = 0; i < str_len; i++) {
    //     if (str[i] == letter) {
    //         occurrence = occurrence + 1;
    //     }
    // }

    /* Second way, looking for the null terminator using a while loop, use the pointer 
    arithmetic to traverse the char string*/
    while (*str != '\0')
    {
        if (*str == letter) {
            occurrence += 1;
        }
        str = str + 1;
    }
    return occurrence;
}

/* Populates DNA_SEQ with the number of times each nucleotide appears.
Each sequence will end with a NULL terminator and will have up to 20 nucleotides.
All letters will be upper case. */
void compute_nucleotide_occurrences(DNA_sequence *dna_seq) {
    /* TODO: implement compute_nucleotide_occurances */
    dna_seq->A_count = num_occurrences(dna_seq, 'A');
    dna_seq->C_count = num_occurrences(dna_seq, 'C');
    dna_seq->T_count = num_occurrences(dna_seq, 'T');
    dna_seq->G_count = num_occurrences(dna_seq, 'G');
    return;
}
