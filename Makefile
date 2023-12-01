run:
	v run day01.v

run_fast:
	v -cc clang -skip-unused -prod -d no_segfault_handler -showcc -cflags "-march=native -ffast-math" day01.v
	./day01

run_faster:
	./pgo_compile.sh
	./optimized_program

test:
	v -stats test .

fmt:
	v fmt -w .