const std = @import("std");

// A simple dot product function
//
// Parameters:
//  * x (runtime): LHS
//  * y (runtime): RHS
//  * N (comptime): number of elements in each array
pub fn dot_product_1(comptime T: type, comptime N: usize, x: []const T, y: []const T) T {
    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);
    
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
//  * N (comptime): number of elements in each array
pub fn dot_product_2(comptime T: type, comptime N: usize, x: []T, y: []T) T {
    const lanes = 4;
    const VecI32 = @Vector(lanes, i32);
    var z: T = 0;
    for (0 .. (N >> 2)) |i| {
        const v0 = VecI32 { x[4*i], x[4*i+1], x[4*i+2], x[4*i+3] };
        const v1 = VecI32 { y[4*i], y[4*i+1], y[4*i+2], y[4*i+3] };
        const v2 = v0 * v1;
        z += v2[0] + v2[1] + v2[2] + v2[3];
    }
    for (0 .. (N % 4)) |i| {
        z += x[((N >> 2) << 2) + i] * y[((N >> 2) << 2) + i];
    }
    return z;
}


pub fn dot_product_3(comptime N: usize, x: []const i32, y: []const i32) i64 {
    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);

    const lanes = 4;
    const VecI32 = @Vector(lanes, i32);
    const VecI64 = @Vector(lanes, i64);

    var acc: VecI64 = @splat(0);

    const vec_count = N / lanes;
    const tail_start = vec_count * lanes;

    for (0..vec_count) |i| {
        const base = i * lanes;

        const vx_i32: VecI32 = x[base..][0..lanes].*;
        const vy_i32: VecI32 = y[base..][0..lanes].*;

        const vx: VecI64 = @as(VecI64, vx_i32);
        const vy: VecI64 = @as(VecI64, vy_i32);

        acc += vx * vy;
    }

    var z: i64 = @reduce(.Add, acc);

    for (tail_start..N) |i| {
        z += @as(i64, x[i]) * @as(i64, y[i]);
    }

    return z;
}


pub fn dot_product_4(comptime N: usize, x: []const i32, y: []const i32) i64 {
    std.debug.assert(x.len >= N);
    std.debug.assert(y.len >= N);

    const lanes = 4;
    const VecI32 = @Vector(lanes, i32);
    const VecI64 = @Vector(lanes, i64);

    var acc0: VecI64 = @splat(0);
    var acc1: VecI64 = @splat(0);
    var acc2: VecI64 = @splat(0);
    var acc3: VecI64 = @splat(0);

    const block = lanes * 4;
    const block_count = N / block;
    const main_end = block_count * block;

    for (0..block_count) |b| {
        const base = b * block;

        const x0_i32: VecI32 = x[base + 0..][0..lanes].*;
        const y0_i32: VecI32 = y[base + 0..][0..lanes].*;
        const x1_i32: VecI32 = x[base + 4..][0..lanes].*;
        const y1_i32: VecI32 = y[base + 4..][0..lanes].*;
        const x2_i32: VecI32 = x[base + 8..][0..lanes].*;
        const y2_i32: VecI32 = y[base + 8..][0..lanes].*;
        const x3_i32: VecI32 = x[base + 12..][0..lanes].*;
        const y3_i32: VecI32 = y[base + 12..][0..lanes].*;

        const x0: VecI64 = @as(VecI64, x0_i32);
        const y0: VecI64 = @as(VecI64, y0_i32);
        const x1: VecI64 = @as(VecI64, x1_i32);
        const y1: VecI64 = @as(VecI64, y1_i32);
        const x2: VecI64 = @as(VecI64, x2_i32);
        const y2: VecI64 = @as(VecI64, y2_i32);
        const x3: VecI64 = @as(VecI64, x3_i32);
        const y3: VecI64 = @as(VecI64, y3_i32);

        acc0 += x0 * y0;
        acc1 += x1 * y1;
        acc2 += x2 * y2;
        acc3 += x3 * y3;
    }

    var z: i64 = @reduce(.Add, acc0 + acc1 + acc2 + acc3);

    for (main_end..N) |i| {
        z += @as(i64, x[i]) * @as(i64, y[i]);
    }

    return z;
}
