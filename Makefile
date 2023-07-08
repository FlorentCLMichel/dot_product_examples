rust_tests:
	cd Rust && cargo test --offline

rust_benchs:
	cd Rust && cargo bench --offline

rust_clippy:
	cd Rust && cargo clippy --offline

rust_doc:
	cd Rust && cargo doc --offline

zig_build:
	cd Zig && zig build -Drelease-fast

zig_run: zig_build
	cd Zig && ./zig-out/bin/bench_1

cpp_build:
	cd C++ && mkdir -p build && cd build && cmake .. && make

cpp_benchs: cpp_build
	cd C++/build && ./bench_1 && ./bench_2 && ./bench_1 && ./bench_2

clean: 
	rm -rf Rust/target
	rm -f Rust/Cargo.lock
	rm -rf Zig/zig-cache
	rm -rf Zig/zig-out
	rm -rf C++/build
