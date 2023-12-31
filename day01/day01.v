module main

import os
import time

fn part01(lines []string) !int {
	mut sum := 0
	mut nums := []int{}
	for line in lines {
		nums << line
			.bytes()
			.filter(it.is_digit())
			.map(it.ascii_str().int())

		calibration_value := (nums.first() * 10) + nums.last()
		nums.clear()
		sum += calibration_value
	}
	return sum
}

fn part02(lines []string) !int {
	string_numbers := [
		'one',
		'o1e',
		'two',
		't2o',
		'three',
		't3e',
		'four',
		'f4r',
		'five',
		'f5e',
		'six',
		's6x',
		'seven',
		's7n',
		'eight',
		'e8t',
		'nine',
		'n9e',
	]

	mut sum := 0
	for line in lines {
		eddited_line := line.replace_each(string_numbers).replace_each(string_numbers)
		for i in 0 .. eddited_line.len {
			if eddited_line[i].is_digit() {
				sum += (eddited_line[i] - u8(`0`)) * 10
				break
			}
		}

		for i := eddited_line.len - 1; i >= 0; i -= 1 {
			if eddited_line[i].is_digit() {
				sum += (eddited_line[i] - u8(`0`))
				break
			}
		}
	}
	return sum
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/01.txt'
	} else {
		os.args[1]
	}
	println('Reading input: ${inputfile}')

	// swfile := time.new_stopwatch()
	lines := os.read_lines(inputfile)!
	// println('fileread took: ${swfile.elapsed().microseconds()}us')

	if os.args.len >= 3 {
		part := os.args[2]
		if part == '1' {
			print(part01(lines)!)
		} else if part == '2' {
			print(part02(lines)!)
		} else {
			println('Unknown part specified')
		}
	} else {
		sw := time.new_stopwatch()
		println(part01(lines)!)
		println('Part 01 took: ${sw.elapsed().microseconds()}us')

		sw2 := time.new_stopwatch()
		println(part02(lines)!)
		println('Part 02 took: ${sw2.elapsed().microseconds()}us')
	}
}
