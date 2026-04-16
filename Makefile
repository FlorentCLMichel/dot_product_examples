.PHONY: rust-tests rust-benchs rust-clippy rust-doc zig-build cpp-build cpp-benchs python clean

rust-tests:
	cd Rust && cargo test --offline

rust-benchs:
	cd Rust && RUSTFLAGS="-C target-cpu=native" cargo bench --offline

rust-clippy:
	cd Rust && cargo clippy --offline

rust-doc:
	cd Rust && cargo doc --offline

zig-build:
	cd Zig && zig build --release=fast

zig-run: zig-build
	cd Zig && ./zig-out/bin/bench_1

cpp-build:
	cd C++ && mkdir -p build && cd build && cmake .. && make

cpp-benchs: cpp-build
	cd C++/build \
		&& ./bench_1 && ./bench_2 && ./bench_3 && ./bench_4 && ./bench_5 \
		&& ./bench_1 && ./bench_2 && ./bench_3 && ./bench_4 && ./bench_5

python: 
	cd Python && python3 ./benchs.py

clean: 
	rm -rf Rust/target
	rm -f Rust/Cargo.lock
	rm -f Zig/build.zig.zon
	rm -rf Zig/.zig-cache
	rm -rf Zig/zig-out
	rm -rf C++/build
	rm -rf Python/__pycache__
