#include <stdint.h>

uint32_t pow(uint32_t a0, uint32_t a1) {
    uint32_t s0 = 1;
    while (a1 != 0)
    {
        s0 *= a0;
        a1 -= 1;
    }
    return s0;
}