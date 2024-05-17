#include "matrices.hpp"
#include <iostream>

matrix_t allocMatrix(size_t rows, size_t columns) {
  matrix_t res = std::make_shared<std::shared_ptr<double[]>[]>(rows);
  for (size_t i = 0; i < rows; ++i)
    res[i] = std::make_shared<double[]>(columns);

  return res;
}

void inputMatrix(matrix_t matrix, size_t rows, size_t columns) {
  for (size_t i = 0; i < rows; ++i)
    for (size_t j = 0; j < columns; ++j)
      std::cin >> matrix[i][j];
}

void printMatrix(matrix_t matrix, size_t rows, size_t columns) {
  for (size_t i = 0; i < rows; ++i) {
    for (size_t j = 0; j < columns; ++j)
      std::cout << matrix[i][j] << "\t";
    std::cout << std::endl;
  }
}

matrix_t getTransposed(matrix_t m, size_t rows, size_t columns) {
  matrix_t res = allocMatrix(columns, rows);

  for (size_t i = 0; i < rows; ++i)
    for (size_t j = 0; j < columns; ++j)
      res[j][i] = m[i][j];

  return res;
}

double getMulCell(std::shared_ptr<double[]> m1, std::shared_ptr<double[]> m2,
                  size_t length) {
  __float128 *pt1 = (__float128 *)(m1.get());
  __float128 *pt2 = (__float128 *)(m2.get());

  double res = 0.0, tmp = 0.0;

  // это неудачная попытка занести цикл в ассемблер
  //   asm(".intel_syntax noprefix   \n\t"   //
  //       "mov rsi, %1              \n\t"   //
  //       "mov rdi, %2 \n\t"                //
  //       "xor rbx, rbx             \n\t"   //
  //       "mov rcx, %3              \n\t"   //
  //       "iter_loop:               \n\t"   //
  //       "movapd xmm1, [rbx + rsi] \n\t"   //
  //       "movapd xmm2, [rbx + rdi] \n\t"   //
  //       "mulpd  xmm1, xmm2        \n\t"   //
  //       "haddpd xmm1, xmm1        \n\t"   //
  //       "haddpd xmm0, xmm1        \n\t"   //
  //       "add rbx, 8               \n\t"   //
  //       "loop iter_loop           \n\t"   //
  //       "movsd %0, xmm0           \n\t"   //
  //       : "=m"(res)                       // на выход %0
  //       : "r"(pt1), "r"(pt2), "r"(length) // на вход %1, %2, %3
  //       : "rsi", "rdi", "rbx", "rcx", "xmm0", "xmm1", "xmm2");

  for (size_t i = 0; i < length;
       i += sizeof(__float128) / sizeof(double), ++pt1, ++pt2) {
    asm("movapd xmm0, %1        \n"
        "movapd xmm1, %2        \n"
        "mulpd  xmm0, xmm1      \n"
        "haddpd xmm0, xmm0      \n"
        "movsd  %0,   xmm0      \n"
        : "=m"(tmp)
        : "m"(*pt1), "m"(*pt2)
        : "xmm0", "xmm1");

    res += tmp;
  }

  return res;
}

matrix_t mulMatrices(matrix_t m1, matrix_t m2, size_t l, size_t m, size_t n) {
  matrix_t transpm2 = getTransposed(m2, m, n);
  matrix_t res = allocMatrix(l, n);

  for (size_t i = 0; i < l; ++i)
    for (size_t j = 0; j < n; ++j)
      res[i][j] = getMulCell(m1.get()[i], transpm2.get()[j], m);

  return res;
}