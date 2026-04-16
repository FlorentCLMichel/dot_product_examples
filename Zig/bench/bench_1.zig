const std = @import("std");
const expect = std.testing.expect;
const dp = @import("dot_product");

// Number of elements
const N: usize = 1000000;

// Number of iterations
const N_ITER: usize = 10000;

// Numbers of lanes to try for vector operations
const lanes_list = [_]usize{ 1, 2, 4, 8, 16 }; 

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

    var start = std.Io.Clock.Timestamp.now(init.io, .awake);
    i = 0;
    while (i < N_ITER) {
        // Compute the dot product
        const z: i32 = dp.dot_product_1(i32, N, x, y);
        try expect(z == -500000);
        i += 1;
    }
    var end = std.Io.Clock.Timestamp.now(init.io, .awake);
    var elapsed = start.durationTo(end);

    std.debug.print(
        "dot_product_1: PASSED in {d}μs on average ({d} iterations)\n",
        .{ @divFloor(elapsed.raw.toNanoseconds(), N_ITER * 1000), N_ITER },
    );
    
    inline for (lanes_list) |lanes| {
        start = std.Io.Clock.Timestamp.now(init.io, .awake);
        i = 0;
        while (i < N_ITER) : (i += 1) {
            const z: i64 = dp.dot_product_2(i32, lanes, N, x, y);
            try expect(z == -500000);
        }
        end = std.Io.Clock.Timestamp.now(init.io, .awake);
        elapsed = start.durationTo(end);

        std.debug.print(
            "dot_product_2 ({d} lanes): PASSED in {d}μs on average ({d} iterations)\n",
            .{ lanes, @divFloor(elapsed.raw.toNanoseconds(), N_ITER * 1000), N_ITER },
        );
        
        start = std.Io.Clock.Timestamp.now(init.io, .awake);
        i = 0;
        while (i < N_ITER) : (i += 1) {
            const z: i64 = dp.dot_product_3(i32, lanes, N, x, y);
            try expect(z == -500000);
        }
        end = std.Io.Clock.Timestamp.now(init.io, .awake);
        elapsed = start.durationTo(end);

        std.debug.print(
            "dot_product_3 ({d} lanes): PASSED in {d}μs on average ({d} iterations)\n",
            .{ lanes, @divFloor(elapsed.raw.toNanoseconds(), N_ITER * 1000), N_ITER },
        );
    }    
}
