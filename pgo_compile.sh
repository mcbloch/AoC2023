#!/usr/bin/env bash

# Get the full path to the current directory
CUR_DIR=$(pwd)

# Remove existing PGO data
rm -f *.profraw
rm -f default.profdata

# Initial build with PGO instrumentation
v -cc clang -skip-unused -prod -cflags -fprofile-generate -o pgo_gen .

# Run the instrumented executable 10 times
for i in {1..10}; do
    ./pgo_gen
done

# Merge the collected data
llvm-profdata merge -o default.profdata *.profraw

# Compile the optimized version using the PGO data
v -cc clang -skip-unused -prod -cflags "-fprofile-use=${CUR_DIR}/default.profdata" -o optimized_program .

# Remove PGO data and instrumented executable
rm *.profraw
rm pgo_gen