#ifndef FLOAT_FUNCS_HPP
#define FLOAT_FUNCS_HPP

#include <cstdlib>

size_t sizeoffloat(void);

float float_sum_c(float x, float y);
float float_sum_asm(float x, float y);

float float_mul_с(float x, float y);
float float_mul_asm(float x, float y);

#endif