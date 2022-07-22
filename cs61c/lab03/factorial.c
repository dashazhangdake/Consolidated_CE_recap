#include <stdio.h>

int factorial(int n) {
    int res = 1;
    for (int i = 1; i <= n; i++) {
        res = res * i;
    }
    return res;
}

int main() {
    int n = 8;
    int f_res = 0;
    f_res = factorial(n);
    printf("factorial of %d = %d\n", n, f_res);
    
    return 0;
} 