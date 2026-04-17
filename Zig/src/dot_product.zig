const std = @import("std");

/// A simple dot product function
///
/// Parameters:
///  * T (comptime): type for the inputs and output
///  * N (comptime): number of elements in each array
///  * x (runtime): LHS
///  * y (runtime): RHS
pub fn dot_product_1(comptime T: type, comptime N: usize, x: []const T, y: []const T) T {
    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);
    
    var z: T = x[0] * y[0];
    for (1..N) |i| {
        z += x[i] * y[i];
    }
    return z;
}


/// A simple dot product function with vector instructions
///
/// Parameters:
///  * T (comptime): type for the inputs and output
///  * lanes (comptime): number of lanes to use
///  * N (comptime): number of elements in each array
///  * x (runtime): LHS
///  * y (runtime): RHS
pub fn dot_product_2(comptime T: type, comptime lanes: usize, comptime N: usize, x: []const T, y: []const T) T {
    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);

    const Vec = @Vector(lanes, T);

    var acc: Vec = @splat(0);

    const vec_count = N / lanes;
    const tail_start = vec_count * lanes;

    for (0..vec_count) |i| {
        const base = i * lanes;

        const vx: Vec = x[base..][0..lanes].*;
        const vy: Vec = y[base..][0..lanes].*;

        acc += vx * vy;
    }

    var z: T = @reduce(.Add, acc);

    for (tail_start..N) |i| {
        z += x[i] * y[i];
    }

    return z;
}


pub fn dot_product_3(comptime T: type, comptime lanes: usize, comptime N: usize, x: []const T, y: []const T) T {
    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);

    const Vec = @Vector(lanes, T);

    var acc0: Vec = @splat(0);
    var acc1: Vec = @splat(0);
    var acc2: Vec = @splat(0);
    var acc3: Vec = @splat(0);

    const block = lanes * 4;
    const block_count = N / block;
    const main_end = block_count * block;

    for (0..block_count) |b| {
        const base = b * block;

        const x0: Vec = x[base..][0..lanes].*;
        const y0: Vec = y[base..][0..lanes].*;
        const x1: Vec = x[base..][lanes..2*lanes].*;
        const y1: Vec = y[base..][lanes..2*lanes].*;
        const x2: Vec = x[base..][2*lanes..3*lanes].*;
        const y2: Vec = y[base..][2*lanes..3*lanes].*;
        const x3: Vec = x[base..][3*lanes..4*lanes].*;
        const y3: Vec = y[base..][3*lanes..4*lanes].*;

        acc0 += x0 * y0;
        acc1 += x1 * y1;
        acc2 += x2 * y2;
        acc3 += x3 * y3;
    }

    var z: T = @reduce(.Add, acc0 + acc1 + acc2 + acc3);

    for (main_end..N) |i| {
        z += x[i] * y[i];
    }

    return z;
}


fn dot_product_chunk(
    comptime T: type,
    comptime lanes: usize,
    x: []const T,
    y: []const T,
) T {
    std.debug.assert(x.len == y.len);

    const Vec = @Vector(lanes, T);

    var acc: Vec = @splat(0);

    const vec_count = x.len / lanes;
    const tail_start = vec_count * lanes;

    for (0..vec_count) |i| {
        const base = i * lanes;

        const vx: Vec = x[base..][0..lanes].*;
        const vy: Vec = y[base..][0..lanes].*;

        acc += vx * vy;
    }

    var z: T = @reduce(.Add, acc);

    for (tail_start..x.len) |i| {
        z += x[i] * y[i];
    }

    return z;
}

/// A dot product function with vector instructions and multithreading
///
/// Parameters:
///  * T (comptime): type for the inputs and output
///  * lanes (comptime): number of SIMD lanes to use in each thread
///  * n_threads (comptime): number of threads to spawn
///  * N (comptime): number of elements in each array
///  * x (runtime): LHS
///  * y (runtime): RHS
pub fn dot_product_4(
    comptime T: type,
    comptime lanes: usize,
    comptime n_threads: usize,
    comptime N: usize,
    x: []const T,
    y: []const T,
) !T {
    comptime std.debug.assert(lanes > 0);
    comptime std.debug.assert(n_threads > 0);

    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);

    if (N == 0) return 0;

    if (n_threads == 1) {
        return dot_product_chunk(T, lanes, x[0..N], y[0..N]);
    }

    const Worker = struct {
        fn run(
            comptime T_: type,
            comptime lanes_: usize,
            x_: []const T_,
            y_: []const T_,
            out: *T_,
        ) void {
            out.* = dot_product_chunk(T_, lanes_, x_, y_);
        }
    };

    var partials: [n_threads]T = [_]T{@as(T, 0)} ** n_threads;
    var threads: [n_threads]std.Thread = undefined;

    const actual_threads = @min(n_threads, N);
    const chunk_size = std.math.divCeil(usize, N, actual_threads) catch unreachable;

    var spawned: usize = 0;

    for (0..actual_threads) |tid| {
        const start = tid * chunk_size;
        const end = @min(start + chunk_size, N);

        threads[spawned] = try std.Thread.spawn(
            .{},
            Worker.run,
            .{ T, lanes, x[start..end], y[start..end], &partials[tid] },
        );
        spawned += 1;
    }

    for (0..spawned) |i| {
        threads[i].join();
    }

    var z: T = 0;
    for (0..actual_threads) |i| {
        z += partials[i];
    }

    return z;
}
