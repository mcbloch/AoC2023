module main

import os
import time
import math
import arrays

fn part01(lines []string) !int {
	time := lines[0].split(':')[1].split(' ').filter(it.len > 0).map(it.int())
	dist := lines[1].split(':')[1].split(' ').filter(it.len > 0).map(it.int())
	// println(time)
	// println(dist)

	mut can_win_counts := []int{}
	for race_i in 0 .. time.len {
		mut can_win_count := 0
		// println('Race: time=${time[race_i]}, dist=${dist[race_i]}')
		for hold_time in 0 .. time[race_i] {
			speed := hold_time
			mut curr_time := hold_time
			// println('  hold=${hold_time}')
			mut travelled := 0
			for (curr_time < time[race_i]) {
				//  println('    time=${curr_time}, speed=${speed}, dist=${travelled}')
				travelled += speed
				curr_time += 1
			}
			if travelled > dist[race_i] {
				// println('  Win')
				can_win_count += 1
			}
		}
		can_win_counts << can_win_count
	}
	// println(can_win_counts)

	return arrays.reduce(can_win_counts, fn (a int, b int) int {
		return a * b
	})
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
		match find_lower {
			true {
				match win {
					true { to = hold_time }
					false { from = hold_time }
				}
			}
			false {
				match win {
					true { from = hold_time }
					false { to = hold_time }
				}
			}
		}
	}
	return found_value
}

fn part02(lines []string) !i64 {
	time := lines[0].split(':')[1].split(' ').filter(it.len > 0).join('').i64()
	dist := lines[1].split(':')[1].split(' ').filter(it.len > 0).join('').i64()

	// we want to search for the first and last winning hold value. We do this with a binary search
	first_winning := bin_search(time, dist, true)
	last_winning := bin_search(time, dist, false)

	return last_winning - first_winning + 1
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
		sw := time.new_stopwatch()
		println(part01(lines)!)
		println('Part 01 took: ${sw.elapsed().microseconds()}us')

		sw2 := time.new_stopwatch()
		println(part02(lines)!)
		println('Part 02 took: ${sw2.elapsed().microseconds()}us')
	}
}