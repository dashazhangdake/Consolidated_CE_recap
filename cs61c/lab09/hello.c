#include <stdio.h>
#include <omp.h>

int main() {
    int nthreads, tid;
    int activethreads = 6;
    omp_set_num_threads(activethreads);
    
    #pragma omp parallel private(tid)
    {
        tid = omp_get_thread_num();
        printf(" hello world %d\n", tid);

        if (tid == 0) {
            nthreads = omp_get_num_threads();
            printf("Total Number of threads = %d\n", nthreads);
        }        
    }
}