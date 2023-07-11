import numpy as np
import numba
import cupy as cp

def dot_product_1(a, b): 
    return (a * b).sum()

def dot_product_2(a, b): 
    return a.dot(b)

@numba.jit
def dot_product_3(a, b):
    c = 0
    for i in range(0, len(a)):
        c += a[i] * b[i]
    return c

@numba.jit
def dot_product_4(a, b):
    c = 0
    for (x, y) in zip(a, b):
        c += x * y
    return c

@numba.jit(parallel=True)
def dot_product_5(a, b):
    return (a * b).sum()
