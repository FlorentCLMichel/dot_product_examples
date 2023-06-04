// A simple doc product function
//
// Parameters:
//  * x (runtime): LHS
//  * y (runtime): RHS
//  * n (comptime): number of elements in each array
pub fn dot_product_1(comptime T: type, comptime N: usize, x: []T, y: []T) T {
    var z: T = x[0] * y[0];
    var i: usize = 1;
    while (i < N) {
        z += x[i] * y[i];
        i += 1;
    }
    return z;
}
