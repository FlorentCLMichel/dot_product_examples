const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .ReleaseFast,
    });

    const dot_product = b.addModule("dot_product", .{
        .root_source_file = b.path("src/dot_product.zig"),
        .target = target,
        .optimize = optimize,
    });

    const bench_1 = b.addExecutable(.{
        .name = "bench_1",
        .root_module = b.createModule(.{
            .root_source_file = b.path("bench/bench_1.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    bench_1.root_module.addImport("dot_product", dot_product);
    b.installArtifact(bench_1);
}
