.PHONY: run run_fast run_faster test fmt

run:
	v run day01/day01.v
	v run day02/day02.v
	v run day02/day03.v

# run_fast:
# 	v -cc clang -skip-unused -prod -d no_segfault_handler -showcc -cflags "-march=native -ffast-math" day01.v
# 	./day01 input/01.txt

# run_faster:
# 	./pgo_compile.sh
# 	./optimized_program

test:
	v -stats test day01
	v -stats test day02
	v -stats test day03

fmt:
	v fmt -w .