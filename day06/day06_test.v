module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/06_example.txt')!
	assert part01(lines)! == 288
}

fn test_part01() {
	lines := os.read_lines('input/06.txt')!
	assert part01(lines)! == 1312850
}

fn test_part02_example() {
	lines := os.read_lines('input/06_example.txt')!
	assert part02(lines)! == 71503
}

fn test_part02() {
	lines := os.read_lines('input/06.txt')!
	assert part02(lines)! == 36749103
}
