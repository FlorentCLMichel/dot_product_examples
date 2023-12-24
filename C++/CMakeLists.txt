project(dot_product_cpp)
cmake_minimum_required(VERSION 3.18)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_FLAGS "-Wall -Wextra -march=native -fopenmp")
include_directories(src/include)
set(sources
    src/lib/dot_product.cpp)

add_executable(bench_1 ${sources} bench/bench_1.cpp)
target_compile_options(bench_1 PUBLIC 
    "-DDOT_PRODUCT_INT_TYPE=int" 
    "-DDOT_PRODUCT_SIZE=1000000"
    "-O3"
)

add_executable(bench_2 ${sources} bench/bench_2.cpp)
target_compile_options(bench_2 PUBLIC 
    "-DDOT_PRODUCT_INT_TYPE=int" 
    "-DDOT_PRODUCT_SIZE=1000000"
    "-DDOT_PRODUCT_N_THREADS=4" 
    "-O3"
)

add_executable(bench_3 ${sources} bench/bench_3.cpp)
target_compile_options(bench_3 PUBLIC 
    "-DDOT_PRODUCT_INT_TYPE=int" 
    "-DDOT_PRODUCT_SIZE=1000000"
    "-O3"
)

add_executable(bench_4 ${sources} bench/bench_4.cpp)
target_compile_options(bench_4 PUBLIC 
    "-DDOT_PRODUCT_INT_TYPE=int" 
    "-DDOT_PRODUCT_SIZE=1000000"
    "-O3"
)

add_executable(bench_5 ${sources} bench/bench_5.cpp)
target_compile_options(bench_5 PUBLIC 
    "-DDOT_PRODUCT_INT_TYPE=int" 
    "-DDOT_PRODUCT_SIZE=1000000"
    "-O3"
)
