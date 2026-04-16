const std = @import("std");
const expect = std.testing.expect;
const dp = @import("dot_product");

// Number of elements
const N: usize = 1000000;

// Nmber of iterations
const N_ITER: usize = 10000;

pub fn main(init: std.process.Init) !void {
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

    const start1 = std.Io.Clock.Timestamp.now(init.io, .awake);
    i = 0;
    while (i < N_ITER) {
        // Compute the dot product
        const z: i32 = dp.dot_product_1(i32, N, x, y);
        try expect(z == -500000);
        i += 1;
    }
    const end1 = std.Io.Clock.Timestamp.now(init.io, .awake);
    const elapsed1 = start1.durationTo(end1);

    std.debug.print(
        "dot_product_1: PASSED in {d}μs on average ({d} iterations)\n",
        .{ @divFloor(elapsed1.raw.toNanoseconds(), N_ITER * 1000), N_ITER },
    );
        
    const start2 = std.Io.Clock.Timestamp.now(init.io, .awake);
    i = 0;
    while (i < N_ITER) : (i += 1) {
        const z: i32 = dp.dot_product_2(i32, N, x, y);
        try expect(z == -500000);
    }
    const end2 = std.Io.Clock.Timestamp.now(init.io, .awake);
    const elapsed2 = start2.durationTo(end2);

    std.debug.print(
        "dot_product_2: PASSED in {d}μs on average ({d} iterations)\n",
        .{ @divFloor(elapsed2.raw.toNanoseconds(), N_ITER * 1000), N_ITER },
    );
    
    const start3 = std.Io.Clock.Timestamp.now(init.io, .awake);
    i = 0;
    while (i < N_ITER) : (i += 1) {
        const z: i64 = dp.dot_product_3(N, x, y);
        try expect(z == -500000);
    }
    const end3 = std.Io.Clock.Timestamp.now(init.io, .awake);
    const elapsed3 = start3.durationTo(end3);

    std.debug.print(
        "dot_product_3: PASSED in {d}μs on average ({d} iterations)\n",
        .{ @divFloor(elapsed3.raw.toNanoseconds(), N_ITER * 1000), N_ITER },
    );
    
    const start4 = std.Io.Clock.Timestamp.now(init.io, .awake);
    i = 0;
    while (i < N_ITER) : (i += 1) {
        const z: i64 = dp.dot_product_4(N, x, y);
        try expect(z == -500000);
    }
    const end4 = std.Io.Clock.Timestamp.now(init.io, .awake);
    const elapsed4 = start4.durationTo(end4);

    std.debug.print(
        "dot_product_4: PASSED in {d}μs on average ({d} iterations)\n",
        .{ @divFloor(elapsed4.raw.toNanoseconds(), N_ITER * 1000), N_ITER },
    );
}
