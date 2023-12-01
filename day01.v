module main

import os
import time

fn part01(lines []string) !int {
	mut sum := 0
	mut nums := []int{}
	for line in lines {
		for c in line {
			if c.is_digit() {
				nums << int(c.ascii_str().int())
			}
		}
		calibration_value := (nums.first() * 10) + nums.last()
		nums.clear()
		sum += calibration_value
	}
	return sum
}

fn part02(lines []string) !int {
	mut sum := 0

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
	mut nums := []int{}
	for line in lines {
		eddited_line := line.replace_each(string_numbers).replace_each(string_numbers)
		for c in eddited_line {
			if c.is_digit() {
				nums << int(c.ascii_str().int())
			}
		}
		calibration_value := (nums.first() * 10) + nums.last()
		nums.clear()
		sum += calibration_value
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

	swfile := time.new_stopwatch()
	lines := os.read_lines(inputfile)!
	println('fileread took: ${swfile.elapsed().microseconds()}us')

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
