#include "double_funcs.hpp"

size_t sizeofdouble(void) { return sizeof(double) * __CHAR_BIT__; }

double double_sum_c(double x, double y) { return x + y; }

double double_sum_asm(double x, double y) {
  double res;

  asm(".intel_syntax noprefix   \n\t" //
      "fld %1                   \n\t" // загрузить double значние в стек FPU
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

double double_mul_с(double x, double y) { return x * y; }

double double_mul_asm(double x, double y) {
  double res = 0;

  asm(".intel_syntax noprefix   \n\t" //
      "fld %1                   \n\t" // загрузить double значние в стек FPU
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
