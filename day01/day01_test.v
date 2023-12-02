module main

import os

fn test_part01() {
	lines := os.read_lines('input/01.txt')!
	assert part01(lines)! == 55834
}

fn test_part02_example() {
	lines := os.read_lines('input/01_example_2.txt')!
	assert part02(lines)! == 281
}

fn test_part02_real() {
	lines := os.read_lines('input/01.txt')!
	assert part02(lines)! != 52606
	assert part02(lines)! < 53254
	assert part02(lines)! == 53221
}
