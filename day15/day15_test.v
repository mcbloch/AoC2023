module main

import os

fn test_part01_example_1() {
	lines := os.read_file('input/15_example.txt')!
	assert part01(lines)! == 1320
}

fn test_part01() {
	lines := os.read_file('input/15.txt')!
	assert part01(lines)! > 507667
	assert part01(lines)! == 507769
}

fn test_part02_example() {
	lines := os.read_file('input/15_example.txt')!
	assert part02(lines)! == 145
}

fn test_part02() {
	lines := os.read_file('input/15.txt')!
	assert part02(lines)! == 269747
}
