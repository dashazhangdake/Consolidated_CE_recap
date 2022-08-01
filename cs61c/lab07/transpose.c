#include "transpose.h"
#include <stdio.h>
/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
    // blockable section
    int blocking_upperbound;
    blocking_upperbound = n - n % blocksize;

    int blocking_dim_x, blocking_dim_y;
    blocking_dim_x = blocking_upperbound / blocksize;
    blocking_dim_y = blocking_upperbound / blocksize;

    for (int block_idx_x = 0; block_idx_x < blocking_dim_x; block_idx_x++) {
        for (int block_idx_y = 0; block_idx_y < blocking_dim_y; block_idx_y++) {
            for (int x = block_idx_x * blocksize; x < block_idx_x * blocksize + blocksize; x++) {
                for (int y = block_idx_y * blocksize; y < block_idx_y * blocksize + blocksize; y++) {
                    dst[y + x * n] = src[x  + y * n];
                }
            }
        }
    }

    if (blocking_upperbound != n) {
        // printf("handing special cases\n, upperbound: %d\n", blocking_upperbound);
        for (int x = blocking_upperbound; x < n; x++) {
            for (int y = 0 ; y < n; y++) {
                dst[y + x * n] = src[x  + y * n];
            }
        }

        for (int x = 0; x < blocking_upperbound; x++) {
            for (int y = blocking_upperbound ; y < n; y++) {
                dst[y + x * n] = src[x  + y * n];
            }
        }
    }
}


/*  Additional Comments: 
On my machine (i7-8700K) you may not always observe "sufficent speed up" if matrix size is set to 10000. 
Therefore, I tried the following setup: n = 40000, blocksize = 10
    Result is as follows:
        testing n = 40000, blocksize = 10
        naive: 18231.1 milliseconds
        student: 4987.35 milliseconds
        Speedup sufficient

One more thing:
    Segment faults may appear if n = 100000, but it might not be relevant to this specific task. Because segfaults also appear 
    even before I implemented the blocking transpose
*/