#include "util.h"

static char* itoa_base(int val, int base)
{
    static char buf[32] = {0};
    char is_minus = 0;
    int i = 30;

    // Special case
    if ( val == 0 ) {
        buf[1] = '0';
        return &buf[1];
    }

    if ( val < 0 ) {
        val = -val;
        is_minus = 1 ;
    }

    // general cases
    for (; val && (i-1);--i, val /=base)
        buf[i] = "0123456789abcdef"[val % base];

    // if the val is negative
    if (is_minus) {
        buf[i] = '-';
        return &buf[i];
    }
    return &buf[i+1];
}

char *itoa(int val)
{
    return itoa_base(val,10);
}

char *htoa(int val)
{
    return itoa_base(val,16);
}
