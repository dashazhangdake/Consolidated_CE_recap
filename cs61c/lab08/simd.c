#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "simd.h"

long long int sum(int vals[NUM_ELEMS]) {
    clock_t start = clock();

    long long int sum = 0;
    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS; i++) {
            if(vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    long long int sum = 0;

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
            if(vals[i] >= 128) sum += vals[i];
            if(vals[i + 1] >= 128) sum += vals[i + 1];
            if(vals[i + 2] >= 128) sum += vals[i + 2];
            if(vals[i + 3] >= 128) sum += vals[i + 3];
        }

        // TAIL CASE, for when NUM_ELEMS isn't a multiple of 4
        // NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
        // Order is important, since (NUM_ELEMS / 4) effectively rounds down first
        for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
            if (vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127); // This is a vector with 127s in it... Why might you need this?
    long long int result = 0; // This is where you should put your final result!
    /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        /* YOUR CODE GOES HERE */
        int sum_arr[4] = {0, 0, 0, 0};
        __m128i res_vec = _mm_setzero_si128();
        for (unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i+=4) {
            // load from source vectors to generate a mask
            __m128i source_values = _mm_loadu_si128((__m128i*) &(vals[i]));

            __m128i mask_vec = _mm_cmpgt_epi32(source_values, _127);
            __m128i masked_source_vec = _mm_and_si128(source_values, mask_vec); 
        
            res_vec = _mm_add_epi32(res_vec, masked_source_vec);
        }
        
        _mm_storeu_si128((__m128i *) sum_arr, res_vec);
        /* Hint: you'll need a tail case. */
        for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
            if (vals[i] > 127) {
                result += vals[i];
            }
        }

        result = result + (long long int) sum_arr[0] + 
        (long long int) sum_arr[1] + 
        (long long int) sum_arr[2] + 
        (long long int) sum_arr[3];
    }
    
    /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}

// Unfortunately, Vectorized loop unrolling got slowed down on my MacBook
long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127);
    long long int result = 0;
    /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        /* YOUR CODE GOES HERE */
        /* Copy your sum_simd() implementation here, and unroll it */
        int sum_arr[4] = {0, 0, 0, 0};
        __m128i res_vec = _mm_setzero_si128();
        for (unsigned int i = 0; i < NUM_ELEMS / 16 * 4; i+=16) {
            // Basically, we repeat the procedure we developed for four times
            // First group 
            __m128i source_values = _mm_loadu_si128((__m128i*) &(vals[i]));
            __m128i mask_vec = _mm_cmpgt_epi32(source_values, _127);
            __m128i masked_source_vec = _mm_and_si128(source_values, mask_vec); 
            res_vec = _mm_add_epi32(res_vec, masked_source_vec);

            // Second group 
            source_values = _mm_loadu_si128((__m128i*) &(vals[i + 4]));
            mask_vec = _mm_cmpgt_epi32(source_values, _127);
            masked_source_vec = _mm_and_si128(source_values, mask_vec); 
            res_vec = _mm_add_epi32(res_vec, masked_source_vec);

            // Third group 
            source_values = _mm_loadu_si128((__m128i*) &(vals[i + 8]));
            mask_vec = _mm_cmpgt_epi32(source_values, _127);
            masked_source_vec = _mm_and_si128(source_values, mask_vec); 
            res_vec = _mm_add_epi32(res_vec, masked_source_vec);

            // Fourth group 
            source_values = _mm_loadu_si128((__m128i*) &(vals[i + 12]));
            mask_vec = _mm_cmpgt_epi32(source_values, _127);
            masked_source_vec = _mm_and_si128(source_values, mask_vec); 
            res_vec = _mm_add_epi32(res_vec, masked_source_vec);
        }
        
        _mm_storeu_si128((__m128i *) sum_arr, res_vec);

        /* Hint: you'll need 1 or maybe 2 tail cases here. */
        // Let's use one tail case
        for(unsigned int i = NUM_ELEMS / 16 * 4; i < NUM_ELEMS; i++) {
            if (vals[i] > 127) {
                result += vals[i];
            }
        }

        result = result + sum_arr[0] + sum_arr[1] + sum_arr[2] + sum_arr[3];
    }

    /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}
