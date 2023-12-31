module main

import os
import time as tme { new_stopwatch }
// import math
import arrays

fn range(from int, to int) []int {
	return []int{len: (to - from) + 1, init: index + from}
}

fn part01(lines []string) !int {
	times := lines[0].split(':')[1].split(' ').filter(it.len > 0).map(it.int())
	dists := lines[1].split(':')[1].split(' ').filter(it.len > 0).map(it.int())

	mut score := 1
	for gr in arrays.group[int](times, dists) {
		score *= range(0, gr[0])
			.map((gr[0] - it) * it)
			.filter(it > gr[1]).len
	}

	return score
}

fn bin_search(time i64, dist i64, find_lower bool) i64 {
	mut from := i64(0)
	mut to := time
	mut found_value := i64(0)
	for {
		hold_time := i64((to + from) / 2)
		win := (time - hold_time) * hold_time > dist
		if from == hold_time || to == hold_time {
			found_value = match win {
				true { from }
				false { to }
			}
			break
		}
		match win != find_lower {
			true { from = hold_time }
			false { to = hold_time }
		}
	}
	return found_value
}

fn part02(lines []string) !i64 {
	time := lines[0].split(':')[1].split(' ').filter(it.len > 0).join('').i64()
	dist := lines[1].split(':')[1].split(' ').filter(it.len > 0).join('').i64()

	// we want to search for the first and last winning hold value. We do this with a binary search
	return bin_search(time, dist, false) - bin_search(time, dist, true) + 1
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/06.txt'
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
