module main

import os { read_file }

const file_example = 'input/19_example.txt'
const file_normal = 'input/19.txt'

fn test_part01_example_1() {
	lines := read_file(file_example)!
	assert part01(lines)! == 19114
}

fn test_part01() {
	lines := read_file(file_normal)!
	assert part01(lines)! == 398527
}

fn test_part02_example() {
	lines := read_file(file_example)!
	assert part02(lines)! == 167409079868000
}

fn test_part02() {
	lines := read_file(file_normal)!
	assert part02(lines)! == 133973513090020
}
