module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/03_example.txt')!
	assert part01(lines)! == 4361
}

fn test_part01() {
	lines := os.read_lines('input/03.txt')!
	assert part01(lines)! > 517752
	assert part01(lines)! == 519444
}

fn test_part02_example() {
	lines := os.read_lines('input/03_example.txt')!
	assert part02(lines)! == 467835
}

fn test_part02() {
	lines := os.read_lines('input/03.txt')!
	assert part02(lines)! == 74528807
}
