module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/02_example.txt')!
	assert part01(lines)! == 8
}

fn test_part01() {
	lines := os.read_lines('input/02.txt')!
	assert part01(lines)! == 2600
}

fn test_part02_example() {
	lines := os.read_lines('input/02_example.txt')!
	assert part02(lines)! == 2286
}

fn test_part02() {
	lines := os.read_lines('input/02.txt')!
	assert part02(lines)! < 273293
	assert part02(lines)! == 86036
}
