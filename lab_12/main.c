#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_STRING_LEN 128
typedef char my_string_t[MAX_STRING_LEN + 1];

#define Deg 5

typedef struct {
  double data[Deg + Deg % 2];
} vector_t;

void print_vector(vector_t *vec) {
  for (size_t i = 0; i < Deg; ++i)
    printf("%.6lf ", vec->data[i]);
  printf("\n");
}

vector_t vector_sum(vector_t *first, vector_t *second) {
  vector_t res;

  for (int i = 0; i < Deg / 2 + Deg % 2; i++) {
    asm("ld1 {v0.2d}, [%0]        \n" // ld1 загружает 2 значения типа
                                      // doble в регистр NEON v0
        "ld1 {v1.2d}, [%1]        \n" // ld1 загружает 2 значения типа
                                      // doble в регистр NEON v1
        "fadd v2.2d, v0.2d, v1.2d \n" // Выполняется сложение векторов
        "st1 {v2.2d}, [%2]        \n" // Выгрузить
        :
        : "r"(first->data + 2 * i), "r"(second->data + 2 * i),
          "r"(res.data + 2 * i)
        : "v0", "v1", "v2");
  }

  return res;
}

size_t my_strlen(my_string_t str) {
  size_t res;

  asm("mov x0, %1              \n"
      "mov w1, 0               \n"

      "strlen_loop:            \n"
      "  ldrb w2, [x0], #1     \n" // Положить в W5 то, на что
                                   // указывает x0, а затем x0+=1
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

  printf("String: %s\n", str);
  printf("Length: %zu\n\n", len);

  vector_t vec1;
  vector_t vec2;

  srand(time(NULL)); // Initialization, should only be called once.
  for (size_t i = 0; i < 5; ++i) {
    vec1.data[i] = (double)rand() / RAND_MAX * 50.;
    vec2.data[i] = (double)rand() / RAND_MAX * 50.;
  }

  vector_t vec3 = vector_sum(&vec1, &vec2);

  printf("Vector 1:\n");
  print_vector(&vec1);
  printf("Vector 2:\n");
  print_vector(&vec2);
  printf("Vector sum:\n");
  print_vector(&vec3);

  return 0;
}