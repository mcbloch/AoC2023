module main

import os
import io

fn test_part01_example() {
	lines := os.read_lines('input/09_example.txt')!
	assert part01(lines)! == 114
}

fn test_part01() {
	lines := os.read_lines('input/09.txt')!
	assert part01(lines)! == 1637452029
}

fn test_part02_example() {
	inputfile := 'input/09_example.txt'
	mut f := os.open(inputfile) or { panic(err) }
	defer {
		f.close()
	}
	mut r := io.new_buffered_reader(reader: f, cap: 128 * 1024)
	assert part02(mut r)! == 2
}

fn test_part02() {
	inputfile := 'input/09.txt'
	mut f := os.open(inputfile) or { panic(err) }
	defer {
		f.close()
	}
	mut r := io.new_buffered_reader(reader: f, cap: 128 * 1024)
	assert part02(mut r)! == 908
}
