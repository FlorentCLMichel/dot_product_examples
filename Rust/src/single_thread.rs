use crate::Number;

/// A simple single-threaded dot product function
///
/// # Arguments
///
/// * `x`: left input array
/// * `y`: right input array
/// * `n`: number of elements in each array
///
/// # Example
///
/// ```
/// use dot_product::*;
/// use dot_product::single_thread::*;
///
/// let n: usize = 4;
/// let x = vec![1, 2, 3, 4];
/// let y = vec![1, 2, 1, 2];
/// let z = dot_prod_1(&x, &y, n);
///
/// assert_eq!(16, z);
/// ```
pub fn dot_prod_1<T: Number>(x: &[T], y: &[T], n: usize) -> T 
{
    let mut z: T = 0.into();
    for i in 0 .. n {
        z += x[i] * y[i];
    }
    z
}

/// A single-threaded dot product function using iterators
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
/// use dot_product::single_thread::*;
///
/// let x = vec![1, 2, 3, 4];
/// let y = vec![1, 2, 1, 2];
/// let z = dot_prod_2(&x, &y);
///
/// assert_eq!(16, z);
/// ```
pub fn dot_prod_2<T: Number>(x: &[T], y: &[T]) -> T
{
    x.iter().zip(y.iter())
     .fold(0.into(), |acc, (&e, &f)| acc + e * f)
}

/// A simple single-threaded dot product function using some unsafe code
///
/// # Arguments
///
/// * `x`: left input array
/// * `y`: right input array
/// * `n`: number of elements in each array
///
/// # Example
///
/// ```
/// use dot_product::*;
/// use dot_product::single_thread::*;
///
/// let n: usize = 4;
/// let x = vec![1, 2, 3, 4];
/// let y = vec![1, 2, 1, 2];
/// unsafe {
///     let z = dot_prod_3(&x, &y, n);
///
///     assert_eq!(16, z);
/// }
/// ```
pub unsafe fn dot_prod_3<T: Number>(x: &[T], y: &[T], n: usize) -> T 
{
    let mut z: T = 0.into();
    for i in 0 .. n {
        z += *x.get_unchecked(i) * *y.get_unchecked(i);
    }
    z
}
