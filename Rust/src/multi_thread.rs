use crate::Number;
use std::thread;
use std::sync::Arc;
use rayon::prelude::*;

/// A simple multi-threaded dot product function
///
/// **NB:** Multithreading generally is not advantageous here as the computation is generally
/// memory bound.
///
/// # Arguments
///
/// * `x`: left input array
/// * `y`: right input array
/// * `n`: number of elements in each array
/// * `l`: number of threads
///
/// # Constraints
///
/// * `l` can not be equal to 0
///
/// # Example
///
/// ```
/// use dot_product::*;
/// use dot_product::multi_thread::*;
/// use std::sync::Arc;
///
/// let n: usize = 4;
/// let x = vec![1, 2, 3, 4];
/// let y = vec![1, 2, 1, 2];
/// let n_threads: usize = 2;
/// let z = dot_prod_1(Arc::new(x), Arc::new(y), n, n_threads);
///
/// assert_eq!(16, z);
/// ```
pub fn dot_prod_1<T: Number + 'static>(x: Arc<Vec<T>>, y: Arc<Vec<T>>, n: usize, l: usize) -> T 
{
    assert!(l > 0);

    // number of elements to be processed by each thread
    let m: usize = (n+l-1) / l;

    // process part of the arrays on each thread
    let n_threads: usize = std::cmp::min(n, l);
    let mut handlers = Vec::new();
    for i in 0 .. n_threads-1 {
        let x = x.clone();
        let y = y.clone();
        handlers.push(thread::spawn(move || {
            let mut res = 0.into();
            for j in 0 .. m {
                let index = i*m+j;
                res += x[index] * y[index];
            }
            res
        }));
    }
    handlers.push(thread::spawn(move || {
        let mut res = 0.into();
        for j in 0 .. (n - (n_threads-1) * m) {
            let index = (n_threads - 1) * m + j;
            res += x[index] * y[index];
        }
        res
    }));

    // sum the results
    let mut z = 0.into();
    for handler in handlers {
        z += handler.join().unwrap();
    }
    z
}


/// A multi-threaded dot product function using iterators
///
/// # Arguments
///
/// * `x`: left input array
/// * `y`: right input array
///
/// # Example
///
/// ```
/// use dot_product::*;
/// use dot_product::multi_thread::*;
///
/// let n: usize = 4;
/// let x = vec![1, 2, 3, 4];
/// let y = vec![1, 2, 1, 2];
/// let z = dot_prod_2(&x, &y);
///
/// assert_eq!(16, z);
/// ```
pub fn dot_prod_2<T: Number>(x: &[T], y: &[T]) -> T
{
    x.par_iter().zip(y.par_iter())
     .fold(|| <u8 as Into<T>>::into(0), |acc, (&e, &f)| acc + e * f)
     .sum::<T>()
}


/// A multi-threaded dot product function using iterators
///
/// # Arguments
///
/// * `x`: left input array
/// * `y`: right input array
///
/// # Example
///
/// ```
/// use dot_product::*;
/// use dot_product::multi_thread::*;
///
/// let n: usize = 4;
/// let x = vec![1, 2, 3, 4];
/// let y = vec![1, 2, 1, 2];
/// let z = dot_prod_3(&x, &y);
///
/// assert_eq!(16, z);
/// ```
pub fn dot_prod_3<T: Number>(x: &[T], y: &[T]) -> T
{
    x.par_iter().zip(y.par_iter())
     .map(|(&e, &f)| e * f)
     .sum::<T>()
}

/// A multi-threaded dot product function using `par_chunk`
///
/// # Arguments
///
/// * `x`: left input array
/// * `y`: right input array
///
/// # Example
///
/// ```
/// use dot_product::*;
/// use dot_product::multi_thread::*;
///
/// let n: usize = 4;
/// let x = vec![1, 2, 3, 4];
/// let y = vec![1, 2, 1, 2];
/// let z = dot_prod_4(&x, &y);
///
/// assert_eq!(16, z);
/// ```
pub fn dot_prod_4<T: Number, const N: usize>(x: &[T], y: &[T]) -> T
{
    x.par_chunks(N).zip(y.par_chunks(N))
     .map(|(e, f)| {
     	    e.iter().zip(f.iter()).map(|(&a, &b)| a * b).sum::<T>()
     })
     .sum::<T>()
}
