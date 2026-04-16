const I32x4 = @Vector(4, i32);

// A simple dot product function
//
// Parameters:
//  * x (runtime): LHS
//  * y (runtime): RHS
//  * n (comptime): number of elements in each array
pub fn dot_product_1(comptime T: type, comptime N: usize, x: []T, y: []T) T {
    var z: T = x[0] * y[0];
    for (1..N) |i| {
        z += x[i] * y[i];
    }
    return z;
}

// A simple dot product function with vector operations
//
// Parameters:
//  * x (runtime): LHS
//  * y (runtime): RHS
//  * n (comptime): number of elements in each array
pub fn dot_product_2(comptime T: type, comptime N: usize, x: []T, y: []T) T {
    var z: T = 0;
    for (0 .. (N >> 2)) |i| {
        const v0 = I32x4 { x[4*i], x[4*i+1], x[4*i+2], x[4*i+3] };
        const v1 = I32x4 { y[4*i], y[4*i+1], y[4*i+2], y[4*i+3] };
        const v2 = v0 * v1;
        z += v2[0] + v2[1] + v2[2] + v2[3];
    }
    for (0 .. (N % 4)) |i| {
        z += x[((N >> 2) << 2) + i] * y[((N >> 2) << 2) + i];
    }
    return z;
}
