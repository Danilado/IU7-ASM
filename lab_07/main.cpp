#include <cstdio>
#include <cstring>

#define STR_LEN 128

using str_t = char[STR_LEN + 1];

extern "C" {
void _copy_string(char *, char *, size_t);
}

// asm (
//      текст_вставки :
//      список_выходных_параметров :
//      список_входных_параметров :
//      список_разрушаемых_регистров
// )

int main(void) {

  str_t str = "test string";
  size_t len = 0;

  printf("BEFORE ASM(...)\n");
  printf("str: %s\n", str);
  printf("len: %zu\n", len);

  asm(".intel_syntax noprefix   \n\t" // я не знаю зачем, но на стаковерфлоу так
      "lea %%rdi, [%1]          \n\t" // положили в rdi указатель на начало
                                      // строки
      "xor %%al, %%al           \n\t" // Положили в al 0
      "mov %%rcx, 256           \n\t" // Положили в rcx 256
      "repne scasb              \n\t" // Цикл по строке из rdi пока не найдётся
                                      // 0 из al; каждый раз будет уменьшаться
                                      // cx
      "mov %%rax, 256           \n\t" //
      "sub %%rax, %%rcx         \n\t" // Получаем разницу между исходным и
                                      // конечным cx
      "dec %%rax                \n\t" // Уменьшаем на 1
      "mov %0, %%rax            \n\t" // Положить в %0 (выходной регистр)
                                      // результат
      : "=r"(len)          // на выход         %0
      : "r"(str)           // на вход          %1, %2...
      : "rcx", "al", "rdi" // что попортили
  );

  printf("AFTER ASM(...)\n");
  printf("str: %s\n", str);
  printf("len: %zu\n", len);

  /*
        "r" - переменную поместят в любой регистр общего назначения
        можно было написать "a" или "b" и т. д.
        тогда переменная хранилась бы в конкретном регистре

        "r" значение переменной будет синронизовано с содержимым регистра
        то есть "r"(len) значит, что при выполнении ассемблерной вставки в
        одном из регистров будет лежать значение переменной len и если мы этот
        регистр изменим, изменится и переменная

        "=r" - равно указывает, что у нас write-only режим для этого регистра

        %% перед регистрами, чтобы gcc было проще отличить регистры от операндов
  */

  str_t dup_str = "stroka nomer 2 ona tipa drugaya";

  printf("BEFORE CALL\n");
  printf("str:     %s\n", str);
  printf("dup_str: %s\n", dup_str);
  printf("len: %zu\n", len);

  _copy_string(dup_str, str, len);

  printf("AFTER CALL\n");
  printf("str:     %s\n", str);
  printf("dup_str: %s\n", dup_str);
  printf("len: %zu\n", len);

  str_t mo_test_str = "test string for memory overlap";

  printf("Memory overlap test\n");
  printf("str:      %s\n", mo_test_str);
  printf("str + 10: %s\n", mo_test_str + 10);

  _copy_string(mo_test_str, mo_test_str + 10, strlen(mo_test_str + 10));

  printf("Memory overlap res\n");
  printf("str:      %s\n", mo_test_str);
  printf("str + 10: %s\n", mo_test_str + 10);

  return 0;
}
