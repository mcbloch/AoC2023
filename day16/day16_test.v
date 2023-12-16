module main

import os { read_lines }

const file_example = 'input/16_example.txt'
const file_normal = 'input/16.txt'

fn test_part01_example_1() {
	lines := read_lines(file_example)!
	assert part01(lines)! == 46
}

fn test_part01() {
	lines := read_lines(file_normal)!
	assert part01(lines)! == 7477
}

fn test_part02_example() {
	lines := read_lines(file_example)!
	assert part02(lines)! == 51
}

fn test_part02() {
	lines := read_lines(file_normal)!
	assert part02(lines)! == 7853
}
