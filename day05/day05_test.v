module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/05_example.txt')!
	assert part01(lines)! == 35
}

fn test_part01() {
	lines := os.read_lines('input/05.txt')!
	assert part01(lines)! == 424490994
}

fn test_part02_example() {
	lines := os.read_lines('input/05_example.txt')!
	assert part02(lines)! == 46
}

fn test_part02() {
	lines := os.read_lines('input/05.txt')!
	assert part02(lines)! == 15290096
}
