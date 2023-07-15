A few simple implementations of integer dot product functions.

## Make commands

The `Makefile` provides the following commands, which can be run with `make`: 

* **`rust_tests`**: run the Rust unit tests
* **`rust_benchs`**: run the Rust benchmarks
* **`rust_clippy`**: run the Clippy linter on the Rust code
* **`rust_doc`**: generate documentation for the Rust code
* **`zig_build`**: build the Zig benchmarks
* **`zig_run`**: build and run the Zig benchmarks
* **`cpp_build`**: build the C++ benchmarks
* **`cpp_run`**: build and run the C++ benchmarks
* **`python`**: run the Python benchmarks
* **`clean`**: delete temporary files

## To do

* Multi-threaded C++ implementation + benchmark
* Cuda implementation + benchmark
* Verilog implementation and Verilator tests
* SystemC implementation and simulation
* Rust-hdl implementation and simulation
