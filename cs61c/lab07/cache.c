#include <stdio.h>
#include <stdlib.h>

void accessWords(int* arr, int array_size, int step_size, int rep_count, int option) {
     for (int k = 0; k < rep_count; k++) { 
         for (int index = 0; index < array_size; index += step_size) {
             if (option == 0)
                 arr[index] = 0; // Option 0: One cache access - write
             else
                 arr[index] = arr[index] + 1; // Option 1: Two cache accesses - read AND write
         }
     }
}

int main() {
     int array_size = 256;
     int step_size = 2;
     int rep_count = 1;
     int option = 1;
     int * arr = (int *)malloc(sizeof(int) * array_size);
     accessWords(arr, array_size, step_size, rep_count, option);
     printf("access_done\n");
     return 0;
}