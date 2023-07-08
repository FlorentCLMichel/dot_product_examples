#include "dot_product.h"
#include <thread>
#include <mutex>
#include <omp.h>


template<BasicArithmetic T, size_t N>
T dot_product_1(const std::span<const T, N> a, const std::span<const T, N> b) {
    T c = static_cast<T>(0);
    for (size_t i = 0; i < N; i++) {
        c += a[i] * b[i];
    }
    return c;
}


template<BasicArithmetic T, size_t N>
void dot_product_2_inplace(
    const T* a, 
    const T* b, 
    T& c,
    std::mutex& m) 
{
    T d = static_cast<T>(0);
    for (size_t i = 0; i < N; i++) {
        d += a[i] * b[i];
    }
    std::lock_guard<std::mutex> guard(m);
    c += d;
}


template<BasicArithmetic T, size_t N, size_t N_THREADS, size_t N_PER_THREAD = N / N_THREADS>
T dot_product_2(const std::vector<T>& a, const std::vector<T>& b) {

    // create the thread pool
    std::vector<std::thread> thread_pool;
    thread_pool.reserve(N_THREADS);
    
    // variable that will store the result and mutex
    T c = static_cast<T>(0);
    std::mutex m_c;

    // run the relevant calculation on each thread
    for (size_t i = 0; i < N_THREADS; i++) {
        thread_pool.push_back(std::thread(
            dot_product_2_inplace<T, N_PER_THREAD>, 
            a.data() + i * N_PER_THREAD, 
            b.data() + i * N_PER_THREAD, 
            std::ref(c),
            std::ref(m_c)
        ));
    }

    // get and sum the results
    for (size_t i = 0; i < N_THREADS; i++) {
        thread_pool[i].join();
    }

    return c;
}


template<BasicArithmetic T, size_t N>
T dot_product_3(const std::span<const T, N> a, const std::span<const T, N> b) {
    T c = static_cast<T>(0);
    #pragma omp parallel for \
        schedule(static) \
        reduction(+:c)
    for (size_t i = 0; i < N; i++) {
        c += a[i] * b[i];
    }
    return c;
}


// template instantiations
#define INSTANCIATE_1(T,N) \
    template T dot_product_1(const std::span<const T, N>, const std::span<const T, N>); \
    template T dot_product_3(const std::span<const T, N>, const std::span<const T, N>);
#define INSTANCIATE_2(T,N,N_THREADS) \
    template T dot_product_2<T,N,N_THREADS>(const std::vector<T>&, const std::vector<T>&);

INSTANCIATE_1(DOT_PRODUCT_INT_TYPE, DOT_PRODUCT_SIZE)

#ifdef DOT_PRODUCT_N_THREADS
#if DOT_PRODUCT_N_THREADS != 1
INSTANCIATE_2(DOT_PRODUCT_INT_TYPE, DOT_PRODUCT_SIZE, DOT_PRODUCT_N_THREADS)
#endif
#endif

#undef INSTANCIATE_1
#undef INSTANCIATE_2
