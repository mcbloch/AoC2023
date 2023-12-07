module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/07_example.txt')!
	assert part01(lines)! == 6440
}

fn test_part01() {
	lines := os.read_lines('input/07.txt')!
	assert part01(lines)! < 249991352
	assert part01(lines)! == 248179786
}

fn test_part02_example() {
	lines := os.read_lines('input/07_example.txt')!
	assert part02(lines)! == 5905
}

fn test_part02() {
	lines := os.read_lines('input/07.txt')!
	assert part02(lines)! < 247959728
	assert part02(lines)! == 247885995
}
