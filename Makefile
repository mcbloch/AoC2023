.PHONY: run run_fast run_faster test fmt

NUMBERS = 1 2 3 4 5 6

run:
	$(foreach var,$(NUMBERS),v run day0$(var)/day0$(var).v;)

# run_fast:
# 	v -cc clang -skip-unused -prod -d no_segfault_handler -showcc -cflags "-march=native -ffast-math" day01.v
# 	./day01 input/01.txt

# run_faster:
# 	./pgo_compile.sh
# 	./optimized_program

test:
	$(foreach var,$(NUMBERS),v -stats test day0$(var);)

fmt:
	v fmt -w .