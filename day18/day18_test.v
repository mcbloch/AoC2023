module main

import os { read_lines }

const file_example = 'input/18_example.txt'
const file_normal = 'input/18.txt'

fn test_part01_example_1() {
	lines := read_lines(file_example)!
	assert part01(lines)! == 62
}

fn test_part01() {
	lines := read_lines(file_normal)!
	assert part01(lines)! > 94792
	assert part01(lines)! < 95405
	assert part01(lines)! == 95356
}

fn test_part02_example() {
	lines := read_lines(file_example)!
	assert part02(lines)! == 952408144115
}

// fn test_part02() {
// 	lines := read_lines(file_normal)!
// 	assert part02(lines)! == 7853
// }
