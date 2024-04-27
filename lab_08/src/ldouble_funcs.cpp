#include "ldouble_funcs.hpp"

size_t sizeofldouble(void) { return sizeof(long double) * __CHAR_BIT__; }

long double ldouble_sum_c(long double x, long double y) { return x + y; }

long double ldouble_sum_asm(long double x, long double y) {
  long double res;

  asm(".intel_syntax noprefix   \n\t" //
      "fld %1                   \n\t" // загрузить long double значние в стек
                                      // FPU
      "fld %2                   \n\t" //
      "faddp                    \n\t" // сложение с извлечением из стека
                                      // складывает ST(1) и ST и выталкивает
                                      // верхний элемент из стека
      "fstp %0                  \n\t" // записать в операнд значение из ST и
                                      // вытолкнуть это значение из стека
      : "=m"(res) // на выход         %0 ; m -> адрес в памяти
      : "m"(x), "m"(y) // на вход          %1, %2...
  );

  return res;
}

long double ldouble_mul_с(long double x, long double y) { return x * y; }

long double ldouble_mul_asm(long double x, long double y) {
  long double res = 0;

  asm(".intel_syntax noprefix   \n\t" //
      "fld %1                   \n\t" // загрузить long double значние в стек
                                      // FPU
      "fld %2                   \n\t" //
      "fmulp                    \n\t" // умножение с извлечением из стека
                                      // умножает ST(1) и ST и выталкивает
                                      // верхний элемент из стека
      "fstp %0                  \n\t" // записать в операнд значение из ST и
                                      // вытолкнуть это значение из стека
      : "=m"(res) // на выход         %0 ; m -> адрес в памяти
      : "m"(x), "m"(y) // на вход          %1, %2...
  );

  return res;
}
