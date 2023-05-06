rust_tests:
	cd Rust && cargo test --offline

rust_benchs:
	cd Rust && cargo bench --offline

rust_clippy:
	cd Rust && cargo clippy --offline

rust_doc:
	cd Rust && cargo doc --offline

clean: 
	rm -rf Rust/target
	rm -f Rust/Cargo.lock
