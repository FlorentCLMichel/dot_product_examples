const std = @import("std");

// A simple dot product function
//
// Parameters:
//  * T (comptime): type for the inputs and output
//  * N (comptime): number of elements in each array
//  * x (runtime): LHS
//  * y (runtime): RHS
pub fn dot_product_1(comptime T: type, comptime N: usize, x: []const T, y: []const T) T {
    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);
    
    var z: T = x[0] * y[0];
    for (1..N) |i| {
        z += x[i] * y[i];
    }
    return z;
}


// A simple dot product function with vector instructions
//
// Parameters:
//  * T (comptime): type for the inputs and output
//  * lanes (comptime): number of lanes to use
//  * N (comptime): number of elements in each array
//  * x (runtime): LHS
//  * y (runtime): RHS
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
