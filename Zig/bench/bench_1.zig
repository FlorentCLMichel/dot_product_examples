const std = @import("std");
const expect = std.testing.expect;
const dp = @import("dot_product");

// Number of elements
const N: usize = 1000000;

// Nmber of iterations
const N_ITER: usize = 10000;

pub fn main() !void {
    // Define the allocator
    const allocator = std.heap.page_allocator;

    // Variable for the loops
    var i: usize = 0;

    // Define the inputs
    var x = try allocator.alloc(i32, N);
    defer allocator.free(x);
    var y = try allocator.alloc(i32, N);
    defer allocator.free(y);
    i = 0;
    while (i < N) {
        x[i] = @intCast(i);
        y[i] = 1 - 2 * @as(i32, @intCast(i % 2));
        i += 1;
    }

    const start = std.time.nanoTimestamp();
    i = 0;
    while (i < N_ITER) {
        // Compute the dot product
        const z: i32 = dp.dot_product_1(i32, N, x, y);
        try expect(z == -500000);
        i += 1;
    }
    const end = std.time.nanoTimestamp();
    std.debug.print("PASSED in {d}μs on average ({d} iterations)\n", .{ @divFloor(end - start, N_ITER * 1000), N_ITER });
}
