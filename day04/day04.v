module main

import os
import time
import datatypes
import arrays

fn convert_numbers(s string) []int {
	return s.trim_space().split(' ').filter(fn (s string) bool {
		return s != ''
	}).map(fn (s string) int {
		return s.int()
	})
}

fn part01(lines []string) !int {
	mut sum := 0
	for line in lines {
		temp := line.split_any(':|')
		str_wini := temp[1]
		str_mine := temp[2]

		winning := convert_numbers(str_wini)
		mine := convert_numbers(str_mine)

		mut mine_set := datatypes.Set[int]{}
		mine_set.add_all(mine)

		mut card_value := 0
		// for num in mine_set {
		for mine_set.size() > 0 {
			num := mine_set.pop()!
			if winning.contains(num) {
				// print(' win ')
				if card_value == 0 {
					card_value = 1
				} else {
					card_value *= 2
				}
			}
		}
		// println('${winning} - ${mine} - ${card_value}')
		sum += card_value
	}
	return sum
}

fn part02(lines []string) !int {
	mut card_count := []int{len: lines.len, init: 1}
	for line_i, line in lines {
		temp := line.split_any(':|')
		str_wini := temp[1]
		str_mine := temp[2]

		winning := convert_numbers(str_wini)
		mine := convert_numbers(str_mine)

		mut mine_set := datatypes.Set[int]{}
		mine_set.add_all(mine)

		mut match_count := 0
		// for num in mine_set {
		for mine_set.size() > 0 {
			num := mine_set.pop()!
			if winning.contains(num) {
				// print(' win ')
				match_count += 1
			}
		}
		for i in 1 .. match_count + 1 {
			card_count[line_i + i] += card_count[line_i]
		}
		// println(card_count)
		// println('${winning} - ${mine} - ${card_value}')
	}
	return arrays.sum(card_count)
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/04.txt'
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
