#include "matrices.hpp"
#include <iostream>

using std::cin;
using std::cout;
using std::endl;

int main(void) {
  size_t l, m, n;

  cout << "Введите размеры l, m и n\n>";
  cin >> l >> m >> n;

  matrix_t m1, m2, m3;

  m1 = allocMatrix(l, m);
  m2 = allocMatrix(m, n);

  cout << "Введите матрицу " << l << " на " << m << endl;
  inputMatrix(m1, l, m);
  cout << "Введите матрицу " << m << " на " << n << endl;
  inputMatrix(m2, m, n);

  cout << endl << "Вы ввели" << endl;
  printMatrix(m1, l, m);
  cout << endl;
  printMatrix(m2, m, n);

  m3 = mulMatrices(m1, m2, l, m, n);

  cout << endl << "Результат умножения: " << endl;
  printMatrix(m3, l, n);

  return 0;
}
