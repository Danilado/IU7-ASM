#include <iostream>
#include <random>

#define MAX_STRING_LEN 128
using my_string_t = char[MAX_STRING_LEN + 1];

template <size_t Deg> class Vector {
public:
  double data[Deg + Deg % 2];

  void print();
  Vector operator+(Vector &second);
};

template <size_t Deg>
std::ostream &operator<<(std::ostream &out, const Vector<Deg> &vec) {
  for (size_t i = 0; i < Deg; ++i)
    out << vec.data[i] << ' ';
  out << std::endl;
  return out;
}

template <size_t Deg> Vector<Deg> Vector<Deg>::operator+(Vector<Deg> &second) {
  Vector<Deg> res;

  for (int i = 0; i < Deg / 2 + Deg % 2; i++) {
    asm volatile("ld1 {v0.2d}, [%0]        \n" // ld1 загружает 2 значения типа
                                               // doble в регистр NEON v0
                 "ld1 {v1.2d}, [%1]        \n" // ld1 загружает 2 значения типа
                                               // doble в регистр NEON v1
                 "fadd v2.2d, v0.2d, v1.2d \n" // Выполняется сложение векторов
                 "st1 {v2.2d}, [%2]        \n" // Выгрузить
                 :
                 : "r"(this->data + 2 * i), "r"(second.data + 2 * i),
                   "r"(res.data + 2 * i)
                 : "v0", "v1", "v2");
  }

  return res;
}

size_t my_strlen(my_string_t str) {
  size_t res;

  asm volatile("mov x0, %1              \n"
               "mov w1, 0               \n"

               "strlen_loop:            \n"
               "  LDRB w2, [x0],        \n" // Положить в W5 то, на что
                                            // указывает x0, а затем x0++
               "  cmp w2, w1            \n"
               "  bne strlen_loop       \n"

               "sub x0, x0, %1          \n" // x0 = x0 - %1
               "sub x0, x0, #1          \n" // x0 = x0 - 1
               "mov %0, x0              \n" // ну тут понятно
               : "=r"(res)
               : "r"(str)
               : "r0", "r1", "r2");

  return res;
}

int main(void) {
  my_string_t str = "Test string";
  size_t len = my_strlen(str);

  std::cout << "String: " << str << std::endl;
  std::cout << "Length: " << len << std::endl << std::endl;

  Vector<5> vec1{};
  Vector<5> vec2{};

  std::random_device dev;
  std::mt19937 rng(dev());
  std::uniform_real_distribution<double> randgen(0., 10.);

  for (size_t i = 0; i < 5; ++i) {
    vec1.data[i] = randgen(rng);
    vec2.data[i] = randgen(rng);
  }

  std::cout << "Vector 1:" << std::endl;
  std::cout << vec1;
  std::cout << "Vector 2:" << std::endl;
  std::cout << vec2;
  std::cout << "Vector sum:" << std::endl;
  std::cout << vec1 + vec2;

  return 0;
}