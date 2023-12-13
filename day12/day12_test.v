module main

import os

fn test_part01_example_1() {
	lines := os.read_lines('input/12_example.txt')!
	assert part01(lines)! == 21
}

fn test_part01() {
	lines := os.read_lines('input/12.txt')!
	assert part01(lines)! == 7716
}

fn test_part02_example() {
	lines := os.read_lines('input/12_example.txt')!
	assert part02(lines)! == 525152
}

fn test_part02() {
	lines := os.read_lines('input/12.txt')!
	assert part02(lines)! > 2935121703
}
