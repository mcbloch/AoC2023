module main

import os
import time { new_stopwatch }
import arrays { reduce, sum, window }

fn part01(lines []string) !i64 {
	return sum(lines
		.map(it.split(' ').map(it.int()))
		.map(fn (line_int []int) int {
			mut diffs := line_int.clone()
			mut last := [diffs.last()]
			for (diffs.any(it != 0)) {
				diffs = window(diffs, size: 2).map(it[1] - it[0])
				last << diffs.last()
			}
			return reduce(last.reverse(), fn (acc int, elem int) int {
				return elem + acc
			}) or { 0 }
		}))!
}

fn part02(lines []string) !int {
	return sum(lines
		.map(it.split(' ').map(it.int()))
		.map(fn (line_int []int) int {
			mut diffs := line_int.clone()
			mut first := [diffs.first()]
			for (diffs.any(it != 0)) {
				diffs = window(diffs, size: 2).map(it[1] - it[0])
				first << diffs.first()
			}
			return reduce(first.reverse(), fn (acc int, elem int) int {
				return elem - acc
			}) or { 0 }
		}))!
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/09.txt' }
	}
	println('Reading input: ${inputfile}')
	lines := os.read_lines(inputfile)!

	if os.args.len >= 3 {
		match os.args[2] {
			'1' { println(part01(lines)!) }
			'2' { println(part02(lines)!) }
			else { println('Unknown part specified') }
		}
	} else {
		mut sw := new_stopwatch()
		println(part01(lines)!)
		println('Part 01 took: ${sw.elapsed().microseconds()}us')
		sw.restart()
		println(part02(lines)!)
		println('Part 02 took: ${sw.elapsed().microseconds()}us')
	}
}
