module main

import os { read_file }

const file_example = 'input/15_example.txt'
const file_normal = 'input/15.txt'

fn test_part01_example_1() {
	lines := read_file(file_example)!
	assert part01(lines)! == 1320
}

fn test_part01() {
	lines := read_file(file_normal)!
	assert part01(lines)! > 507667
	assert part01(lines)! == 507769
}

fn test_part02_example() {
	lines := read_file(file_example)!
	assert part02(lines)! == 145
}

fn test_part02() {
	lines := read_file(file_normal)!
	assert part02(lines)! == 269747
}
