module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/09_example.txt')!
	assert part01(lines)! == 114
}

fn test_part01() {
	lines := os.read_lines('input/09.txt')!
	assert part01(lines)! == 1637452029
}

fn test_part02_example() {
	lines := os.read_lines('input/09_example.txt')!
	assert part02(lines)! == 2
}

fn test_part02() {
	lines := os.read_lines('input/09.txt')!
	assert part02(lines)! == 908
}
