module main

import os
import time
import arrays
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
		mut valid_line := true
		mut prefix_suffix := line.split(':')
		for color_str in prefix_suffix[1].split_any(';,') {
			color_pair := color_str.trim_space().split(' ')
			amount := color_pair[0]
			color := color_pair[1]

			if amount.int() > bag_contents[color] {
				valid_line = false
				break
			}
		}
		if valid_line {
			id := prefix_suffix[0].split(' ')[1]
			sum += id.int()
		}
	}
	return sum
}

fn part02(lines []string) !int {
	mut sum := 0
	for line in lines {
		mut minimal_bag_contents := {
			'red':   0
			'green': 0
			'blue':  0
		}
		for draw in line.split(': ')[1].split('; ') {
			for color_str in draw.split(', ') {
				color_pair := color_str.split(' ')
				amount := color_pair[0].int()
				color := color_pair[1]
				minimal_bag_contents[color] = math.max(minimal_bag_contents[color], amount)
			}
		}
		power := arrays.reduce(minimal_bag_contents.values(), fn (t1 int, t2 int) int {
			return t1 * t2
		})!
		sum += power
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
