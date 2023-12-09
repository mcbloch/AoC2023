module main

import os
import time as tme { new_stopwatch }
// import math
import arrays { reduce, window }
// import maps

fn part01(lines []string) !i64 {
	mut sum := 0
	for line in lines {
		mut diffs := line.split(' ').map(it.int())
		mut last := [diffs.last()]
		for (diffs.any(it != 0)) {
			diffs = window(diffs, size: 2).map(it[1] - it[0])
			last << diffs.last()
		}
		sum += reduce(last.reverse(), fn (acc int, elem int) int {
			return elem + acc
		})!
	}

	return sum
}

fn part02(lines []string) !i64 {
	mut sum := 0
	for line in lines {
		mut diffs := line.split(' ').map(it.int())
		mut first := [diffs.first()]
		for (diffs.any(it != 0)) {
			diffs = window(diffs, size: 2).map(it[1] - it[0])
			first << diffs.first()
		}
		sum += reduce(first.reverse(), fn (acc int, elem int) int {
			return elem - acc
		})!
	}

	return sum
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/09.txt'
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
		sw := new_stopwatch()
		println(part01(lines)!)
		println('Part 01 took: ${sw.elapsed().microseconds()}us')

		sw2 := new_stopwatch()
		println(part02(lines)!)
		println('Part 02 took: ${sw2.elapsed().microseconds()}us')
	}
}
