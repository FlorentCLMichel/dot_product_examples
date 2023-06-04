const Builder = @import("std").build.Builder;
const Pkg = @import("std").build.Pkg;
const FileSource = @import("std").build.FileSource;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const bench_1 = b.addExecutable("bench_1", "bench/bench_1.zig");

    const dot_product = Pkg{
        .name = "dot_product",
        .source = FileSource{
            .path = "src/dot_product.zig",
        },
    };
    bench_1.addPackage(dot_product);

    bench_1.setBuildMode(mode);
    b.installArtifact(bench_1);
}
