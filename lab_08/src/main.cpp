#include <cstdlib>

#include <cmath>
#include <iostream>
using std::cin;
using std::cout;
using std::endl;

#include "double_funcs.hpp"
#include "float_funcs.hpp"
#include "func_root.hpp"
#include "utils.hpp"

#ifdef X87
#include "ldouble_funcs.hpp"
#endif

int main(void) {

#ifndef NO_TEST
  const size_t run_count = 1000000;

  {
    float x = 10.123f;
    float y = 14.000456f;
    float res = 0.0f;

    cout << "FLOAT" << endl << endl;
    cout << "BEFORE SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = float_sum_c(x, y);
    cout << "AFTER CPP SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = float_sum_asm(x, y);
    cout << "AFTER ASM SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = float_mul_с(x, y);
    cout << "AFTER CPP MUL" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = float_mul_asm(x, y);
    cout << "AFTER ASM MUL" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    cout << "TIME FOR " << run_count << " ITERATIONS" << endl;
    cout << "CPP SUM: " << measure_n_times(run_count, float_sum_c, x, y)
         << endl;
    cout << "ASM SUM: " << measure_n_times(run_count, float_sum_asm, x, y)
         << endl;
    cout << "CPP MUL: " << measure_n_times(run_count, float_mul_с, x, y)
         << endl;
    cout << "ASM MUL: " << measure_n_times(run_count, float_mul_asm, x, y)
         << endl
         << endl;
  }

  {
    double x = 10.123345789;
    double y = 14.987654321;
    double res = 0.0;

    cout << "DOUBLE" << endl << endl;
    cout << "BEFORE SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = double_sum_c(x, y);
    cout << "AFTER CPP SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = double_sum_asm(x, y);
    cout << "AFTER ASM SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = double_mul_с(x, y);
    cout << "AFTER CPP MUL" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = double_mul_asm(x, y);
    cout << "AFTER ASM MUL" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    cout << "TIME FOR " << run_count << " ITERATIONS" << endl;
    cout << "CPP SUM: " << measure_n_times(run_count, double_sum_c, x, y)
         << endl;
    cout << "ASM SUM: " << measure_n_times(run_count, double_sum_asm, x, y)
         << endl;
    cout << "CPP MUL: " << measure_n_times(run_count, double_mul_с, x, y)
         << endl;
    cout << "ASM MUL: " << measure_n_times(run_count, double_mul_asm, x, y)
         << endl
         << endl;
  }

#ifdef X87
  {
    long double x = 10.123345789;
    long double y = 14.987654321;
    long double res = 0.0;

    cout << "LONG DOUBLE" << endl << endl;
    cout << "BEFORE SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = ldouble_sum_c(x, y);
    cout << "AFTER CPP SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = ldouble_sum_asm(x, y);
    cout << "AFTER ASM SUM" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = ldouble_mul_с(x, y);
    cout << "AFTER CPP MUL" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    res = ldouble_mul_asm(x, y);
    cout << "AFTER ASM MUL" << endl;
    cout << "x: " << x << endl;
    cout << "y: " << y << endl;
    cout << "res: " << res << endl;
    cout << endl;

    cout << "TIME FOR " << run_count << " ITERATIONS" << endl;
    cout << "CPP SUM: " << measure_n_times(run_count, ldouble_sum_c, x, y)
         << endl;
    cout << "ASM SUM: " << measure_n_times(run_count, ldouble_sum_asm, x, y)
         << endl;
    cout << "CPP MUL: " << measure_n_times(run_count, ldouble_mul_с, x, y)
         << endl;
    cout << "ASM MUL: " << measure_n_times(run_count, ldouble_mul_asm, x, y)
         << endl
         << endl;
  }
#endif

  {
    double pi = 3.14;

    cout << "SIN 3.14" << endl;
    cout << "sin(pi):   " << sin(pi) << endl;
    cout << "sin(pi/2): " << sin(pi / 2) << endl;
    cout << endl;

    pi = 3.141596;
    cout << "SIN 3.141596" << endl;
    cout << "sin(pi):   " << sin(pi) << endl;
    cout << "sin(pi/2): " << sin(pi / 2) << endl;
    cout << endl;

    pi = get_pi();
    cout << "SIN " << pi << endl;
    cout << "sin(pi):   " << sin(pi) << endl;
    cout << "sin(pi/2): " << sin(pi / 2) << endl;
    cout << endl;
  }

#endif

  double s, e;
  size_t iters;

  cout << "input start x: ";
  cin >> s;
  cout << "input end x: ";
  cin >> e;
  cout << "input iteration count: ";
  cin >> iters;

  double root = find_root(func, s, e, iters);
  cout << "f(" << root << ") = " << func(root) << endl;

  return 0;
}