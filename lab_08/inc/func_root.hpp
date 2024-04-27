#ifndef FUNC_ROOT_HPP
#define FUNC_ROOT_HPP

#ifndef EPS
#define EPS 1e-6
#endif

#include <cstdlib>

double get_pi(void);

double func(double x);

double find_root(double (*f)(double), double start, double end,
                 size_t iterations);

#endif
