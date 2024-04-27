#ifndef LDOUBLE_FUNCS_HPP
#define LDOUBLE_FUNCS_HPP

#include <cstdlib>

size_t sizeofldouble(void);

long double ldouble_sum_c(long double x, long double y);
long double ldouble_sum_asm(long double x, long double y);

long double ldouble_mul_с(long double x, long double y);
long double ldouble_mul_asm(long double x, long double y);

#endif