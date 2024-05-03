#ifndef MATRICES_HPP
#define MATRICES_HPP

#include <cstdlib>
#include <memory>

using matrix_t = std::shared_ptr<std::shared_ptr<double[]>[]>;

matrix_t allocMatrix(size_t rows, size_t columns);
void inputMatrix(matrix_t matrix, size_t rows, size_t columns);
void printMatrix(matrix_t matrix, size_t rows, size_t columns);

matrix_t getTransposed(matrix_t m, size_t rows, size_t columns);
matrix_t mulMatrices(matrix_t m1, matrix_t m2, size_t l, size_t m, size_t n);

#endif