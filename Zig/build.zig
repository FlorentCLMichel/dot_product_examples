const std = @import("std");

pub fn build(b: *std.Build) void {
    const bench_1 = b.addExecutable(.{
        .name = "bench_1", 
        .root_source_file = b.path("bench/bench_1.zig"),
        .target = b.host,
        .optimize = .ReleaseSafe,
    });
    
    const dot_product = b.addModule("dot_product", .{
        .root_source_file = b.path("src/dot_product.zig"),
        .target = b.host,
        .optimize = .ReleaseSafe,
    });
    
    bench_1.root_module.addImport("dot_product", dot_product);
    b.installArtifact(bench_1);
}
