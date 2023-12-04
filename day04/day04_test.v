module main

import os

fn test_part01_example() {
	lines := os.read_lines('input/04_example.txt')!
	assert part01(lines)! == 13
}

fn test_part01() {
	lines := os.read_lines('input/04.txt')!
	assert part01(lines)! < 78364
	assert part01(lines)! < 31349
	assert part01(lines)! == 21138
}

fn test_part02_example() {
	lines := os.read_lines('input/04_example.txt')!
	assert part02(lines)! == 30
}

fn test_part02() {
	lines := os.read_lines('input/04.txt')!
	assert part02(lines)! == 7185540
}
