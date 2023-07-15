import dot_product
import time
import numpy as np

N = 1000000
N_ITER = 10000

def benchmark(f):
    print("Benchmark: " + f.__name__)
    a = np.arange(N, dtype=np.int32)
    b = 1 - 2 * (np.arange(N, dtype=np.int32) % 2)
    c = f(a, b)
    start = time.time()
    for _ in range(N_ITER):
        c = f(a, b)
        if c != -500000:
            print("FAILED")
            exit()
    end = time.time()
    print("Average runtime: " + str(round(10**6 * (end - start) / N_ITER)) + "μs per iteration")

benchmark(dot_product.dot_product_1)
benchmark(dot_product.dot_product_2)
benchmark(dot_product.dot_product_3)
benchmark(dot_product.dot_product_4)
benchmark(dot_product.dot_product_5)
benchmark(dot_product.dot_product_6)
