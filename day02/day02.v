module main

import os
import time
import math

fn part01(lines []string) !int {
	// mean: 320
	bag_contents := {
		'red':   12
		'green': 13
		'blue':  14
	}
	mut sum := 0
	for line in lines {
		mut prefix_suffix := line.split(':')
		colors := prefix_suffix[1].split_any(';,')
		invalid_line := colors.map(it.trim_space().split(' ')).any(it[0].int() > bag_contents[it[1]])

		if !invalid_line {
			sum += prefix_suffix[0].split(' ')[1].int()
		}
	}
	return sum
}

fn part02(lines []string) !int {
	mut sum := 0
	for line in lines {
		mut minimal_bag := {
			'red':   0
			'green': 0
			'blue':  0
		}
		for color_str in line.split(':')[1].split_any(';,') {
			color_pair := color_str.trim_space().split(' ')
			minimal_bag[color_pair[1]] = math.max(minimal_bag[color_pair[1]], color_pair[0].int())
		}
		sum += minimal_bag['red'] * minimal_bag['blue'] * minimal_bag['green']
	}
	return sum
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/02.txt'
	} else {
		os.args[1]
	}
	println('Reading input: ${inputfile}')
	lines := os.read_lines(inputfile)!

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
