#ifndef DOT_PRODUCT_H
#define DOT_PRODUCT_H

#include <concepts>
#include <span>
#include <vector>

// A concept for types implementing the required operations
template<typename T>
concept BasicArithmetic = requires(T a, T b, char c)
{
    { static_cast<T>(c) } -> std::convertible_to<T>; 
    { a * b } -> std::convertible_to<T>;
    { a += b };
};


// A simple single-threaded dot product function
template<BasicArithmetic T, size_t N>
T dot_product_1(const std::span<const T, N> a, const std::span<const T, N> b);

// A simple multi-threaded dot product function
//
// N_THREADS must be  adivisor of N
template<BasicArithmetic T, size_t N, size_t N_THREADS, size_t N_PER_THREAD = N / N_THREADS>
T dot_product_2(const std::vector<T>& a, const std::vector<T>& b);

// A simple multi-threaded dot product function using OpenMP
template<BasicArithmetic T, size_t N>
T dot_product_3(const std::span<const T, N> a, const std::span<const T, N> b);

// A simple multi-threaded dot product function using OpenMP
template<BasicArithmetic T, size_t N>
T dot_product_4(const std::span<const T, N> a, const std::span<const T, N> b);

// A simple simgle-threaded dot product function using OpenMP
template<BasicArithmetic T, size_t N>
T dot_product_5(const std::span<const T, N> a, const std::span<const T, N> b);

#endif
