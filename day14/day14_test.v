module main

import os

fn test_part01_example_1() {
	lines := os.read_lines('input/14_example.txt')!
	assert part01(lines)! == 136
}

fn test_part01() {
	lines := os.read_lines('input/14.txt')!
	assert part01(lines)! == 105623
}

fn test_part02_example() {
	lines := os.read_lines('input/14_example.txt')!
	assert part02(lines)! == 64
}

// fn test_part02() {
// 	lines := os.read_lines('input/14.txt')!
// 	assert part02(lines)! < 57741
// 	assert part02(lines)! < 39095
// 	assert part02(lines)! == 31947
// }
