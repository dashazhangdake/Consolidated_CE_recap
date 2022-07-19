#include <stdio.h>
#include "bit_ops.h"

/* Returns the Nth bit of X. Assumes 0 <= N <= 31. */
unsigned get_bit(unsigned x, unsigned n) {
    /* SOLUTION */
    /* 1) Shift right by n bits to move Nth bits to LSB
       2) a AND 1 keeps the original value of a, a AND 0 sets a to 0
       2) Use a mask (32'b01) and bitwise and to filter bits other than the LSB */
    return (x >> n) & 0x000000001;
}

/* Set the nth bit of the value of x to v. Assumes 0 <= N <= 31, and V is 0 or 1 */
void set_bit(unsigned *x, unsigned n, unsigned v) {
    /* SOLUTION */
    /*  0) a OR 1 sets a to 1, a OR 0 keeps the original value of a
        1) For this problem, one method is setting nth bit to 0 first, 0 OR v will 
           set nth bit to v, all other bit should be keep there initial value using 
           a AND 1 
        2) x & FF...0...FF handles set nth bit to 0, we can OR the x, in which the nth 
           bit was set to 0, with 00...v....00 to achieve the gola set nth bit to v */
    unsigned mask = ~(1 << n); // A mask with the nth bit be zero, other bits are 1s
    *x = (*x & mask) | (v << n);
}

/* Flips the Nth bit in X. Assumes 0 <= N <= 31.*/
void flip_bit(unsigned *x, unsigned n) {
    /* SOLUTION */
    /* EZ one, create a mask of 00....1....00, given bit a, a XOR 1 flips a */
    unsigned mask = 1 << n;
    *x = *x ^ mask;
}

