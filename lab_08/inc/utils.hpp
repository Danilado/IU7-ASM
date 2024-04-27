#ifndef UTILS_HPP
#define UTILS_HPP

#include <chrono>
#include <concepts>
#include <functional>
#include <utility>

using TimePrecision = std::chrono::nanoseconds;

template <typename Func, typename... Args>
auto measure_time(Func f, Args &&...args) {
  using RetType = decltype(std::invoke(f, std::forward<Args>(args)...));

  const auto start = std::chrono::high_resolution_clock::now();

  // если void -> возвращаем только время выполнения
  if constexpr (std::is_same_v<void, RetType>) {
    std::invoke(f, std::forward<Args>(args)...);
    auto end = std::chrono::high_resolution_clock::now();
    return std::chrono::duration_cast<TimePrecision>(end - start);
  }

  RetType ret = std::invoke(f, std::forward<Args>(args)...);
  auto end = std::chrono::high_resolution_clock::now();
  return std::tuple<RetType, TimePrecision>{
      ret, std::chrono::duration_cast<TimePrecision>(end - start)};
}

template <typename Func, typename... Args>
auto measure_n_times(size_t n, Func f, Args &&...args) {
  size_t res = 0;

  using RetType = decltype(std::invoke(f, std::forward<Args>(args)...));

  if constexpr (std::is_same_v<void, RetType>)
    for (size_t i = 0; i < n; ++i)
      res += measure_time(f, std::forward<Args>(args)...).count();

  else
    for (size_t i = 0; i < n; ++i)
      res += std::get<1>(measure_time(f, std::forward<Args>(args)...)).count();

  return res;
}

#endif