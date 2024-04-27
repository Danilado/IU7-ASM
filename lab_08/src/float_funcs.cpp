#include "float_funcs.hpp"

size_t sizeoffloat(void) { return sizeof(float) * __CHAR_BIT__; }

float float_sum_c(float x, float y) { return x + y; }

float float_sum_asm(float x, float y) {
  float res;

  asm(".intel_syntax noprefix   \n\t" //
      "fld %1                   \n\t" // загрузить float значние в стек FPU
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

float float_mul_с(float x, float y) { return x * y; }

float float_mul_asm(float x, float y) {
  float res = 0;

  asm(".intel_syntax noprefix   \n\t" //
      "fld %1                   \n\t" // загрузить float значние в стек FPU
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
