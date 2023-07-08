#include "dot_product.h"
#include <iostream>
#include <chrono>

// Number of elements
constexpr size_t N = DOT_PRODUCT_SIZE;

// Number of iterations
const unsigned int N_ITER = 10000;

int main() 
{
    std::cout << "dot_product_2 benchmark..." << std::endl;
    
    std::vector<int> x(N), y(N);
    for (size_t i = 0; i < N; i++) {
        x[i] = static_cast<int>(i);
        y[i] = 1 - 2 * (static_cast<int>(i) % 2);
    }

    auto start = std::chrono::high_resolution_clock::now();
    for (size_t i = 0; i < N_ITER; i++) {
        const int z = dot_product_2<int, N, DOT_PRODUCT_N_THREADS>(x, y);
        if (z != -500000) {
            std::cout << "FAILED" << std::endl;
            return 1;
        }
    }
    auto end = std::chrono::high_resolution_clock::now();
    auto runtime_ns = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();

    std::cout << "PASSED in " 
              << (runtime_ns + N_ITER - 1) / N_ITER
              << "μs on average ("
              << N_ITER
              << " iterations)" 
              << std::endl;
    
    return 0;
}
