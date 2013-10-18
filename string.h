#ifndef __STRING_UTIL_H__
#define __STRING_UTIL_H__

#include <stddef.h>
#include <stdint.h>
#include <limits.h>

#define ALIGN       (sizeof(size_t))
#define ONES        ((size_t)-1/UCHAR_MAX)
#define HIGHS       (ONES * (UCHAR_MAX/2+1))
#define HASZERO(x)  ((x)-ONES & ~(x) & HIGHS)
#define SS          (sizeof(size_t))

char *strncpy(char *dest, const char *src, size_t n);
char *strcpy(char *dest, const char *src);
char *strchr(const char *s, int c);
void *memcpy(void *dest, const void *src, size_t n);
void *memset(void *dest, int c, size_t n);
size_t strlen(const char *string);
int strcmp(const char *str_a, const char *str_b);
int strncmp(const char *str_a, const char *str_b, size_t n);
char *strcat(char *dest, const char *src);

#endif
