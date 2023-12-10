module main

import os

fn test_part01_example_1() {
	lines := os.read_lines('input/10_example_1.txt')!
	assert part01(lines)! == 4
}

fn test_part01_example_2() {
	lines := os.read_lines('input/10_example_2.txt')!
	assert part01(lines)! == 8
}

fn test_part01() {
	lines := os.read_lines('input/10.txt')!
	assert part01(lines)! == 6815
}

fn test_part02_example_3() {
	lines := os.read_lines('input/10_example_3.txt')!
	assert part02(lines)! == 4
}

fn test_part02_example_4() {
	lines := os.read_lines('input/10_example_4.txt')!
	assert part02(lines)! == 8
}

fn test_part02_example_5() {
	lines := os.read_lines('input/10_example_5.txt')!
	assert part02(lines)! == 10
}

fn test_part02() {
	lines := os.read_lines('input/10.txt')!
	assert part02(lines)! == 269
}
