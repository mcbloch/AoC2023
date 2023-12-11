module main

import os

fn test_part01_example_1() {
	lines := os.read_lines('input/11_example.txt')!
	assert part01(lines)! == 374
}

fn test_part01() {
	lines := os.read_lines('input/11.txt')!
	assert part01(lines)! == 9724940
}

fn test_part02_example() {
	lines := os.read_lines('input/11_example.txt')!
	assert part02(lines, Part2Args{10})! == 1030
	assert part02(lines, Part2Args{100})! == 8410
}

fn test_part02() {
	lines := os.read_lines('input/11.txt')!
	assert part02(lines, Part2Args{})! == 569052586852
}
