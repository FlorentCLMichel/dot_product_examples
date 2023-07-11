use criterion::{criterion_group, criterion_main, Criterion};
use dot_product::single_thread::*;
    
const N: usize = 1000000; // number of elements

fn criterion_benchmark(c: &mut Criterion) 
{
    
    // define the inputs
    let x: Vec<i32> = (0..N).map(|x| x as i32).collect();
    let y: Vec<i32> = (0..N).map(|x| 1 - 2 * ((x as i32) % 2)).collect();

    // compute the dot product
    let mut z: i32 = 0;
    c.bench_function("dot_product_single_thread_1", |b| b.iter(|| z = dot_prod_1(&x, &y, N)));

    // check the result
    assert_eq!(-500000, z);
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
