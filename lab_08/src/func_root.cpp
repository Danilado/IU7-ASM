#include "func_root.hpp"
#include <stdio.h>

double get_pi(void) {
  double res = 0;

  asm(".intel_syntax noprefix  \n\t" //
      "fldpi                   \n\t" // загрузить константу PI в стек FPU
      "fstp %0                 \n\t" // записать в операнд значение из ST и
                                     // вытолкнуть это значение из стека
      : "=m"(res) // на выход         %0 ; m -> адрес в памяти
  );

  return res;
}

double func(double x) {
  double res = 0;
  static const int five = 5;

  asm(".intel_syntax noprefix  \n\t" // STACK:
      "fld %1                  \n\t" // x
      "fild %2    \n\t"              // 5, x
      "fmulp                   \n\t" // 5*x
      "fld %1                  \n\t" // x, 5x
      "fld %1                  \n\t" // x, x, 5x
      "fmulp                   \n\t" // x^2, 5x
      "faddp                   \n\t" // x^2 + 5x
      "fsin                    \n\t" // sin(x^2 + 5x)
      "fstp %0                 \n\t" // записать в операнд значение из ST и
                                     // вытолкнуть это значение из стека
      : "=m"(res)         // на выход
      : "m"(x), "m"(five) // на вход
      : "eax"             //
  );

  return res;
}

double get_midpoint(double a, double b) {
  double res = 0;
  static const int two = 2;

  asm(".intel_syntax noprefix  \n\t" // STACK:
      "fld %1                  \n\t" // a
      "fld %2                  \n\t" // b, a
      "faddp                   \n\t" // a+b
      "fild %3                 \n\t" // 2, a+b
      "fdivp                   \n\t" // (a+b)/2
      "fstp %0                 \n\t" // записать в операнд значение из ST и
                                     // вытолкнуть это значение из стека
      : "=m"(res)                // на выход
      : "m"(a), "m"(b), "m"(two) // на вход
  );

  return res;
}

double find_root(double (*f)(double), double start, double end,
                 size_t iterations) {
  double left = start;
  double right = end;
  static const double zero = 0;

  for (size_t i = 0; i < iterations; ++i) {
    double mid = get_midpoint(left, right);

    double f_c = f(mid);

    asm(".intel_syntax noprefix  \n\t" // STACK:
        "fld %2                  \n\t" // f_c
        "fld %3                  \n\t" // 0, f_c
        "fcompp                  \n\t" // сравннить и вытолкнуть
        "fstsw ax                \n\t"
        "test ax, 16640          \n\t" // Сравнить флаги с 4100h
                                       // (если совпало,  то 0 больше f_c)
        "jz from_mid_to_b        \n\t"
        "fld %4                  \n\t" // mid
        "fstp %0                 \n\t" // mid -> left
        "jmp to_end              \n\t"
        "from_mid_to_b:          \n\t"
        "fld %4                  \n\t" // mid
        "fstp %1                 \n\t" // mid -> right
        "to_end:                 \n\t"
        : "=m"(left), "=m"(right)       // на выход %0, %1
        : "m"(f_c), "m"(zero), "m"(mid) // на вход %2, %3, %4
        : "ax");
  }
  //   printf("root from %lf to %lf\n", left, right);

  return get_midpoint(left, right);
}
