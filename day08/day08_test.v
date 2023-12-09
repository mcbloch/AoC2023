module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/08_example.txt')!
	assert part01(lines)! == 2
}

fn test_part01_example_2() {
	lines := os.read_lines('input/08_example_2.txt')!
	assert part01(lines)! == 6
}

fn test_part01() {
	lines := os.read_lines('input/08.txt')!
	assert part01(lines)! == 19099
}

fn test_part02_example() {
	lines := os.read_lines('input/08_example_3.txt')!
	assert part02(lines)! == 6
}

fn test_part02() {
	lines := os.read_lines('input/08.txt')!
	assert part02(lines)! == 17099847107071
}
