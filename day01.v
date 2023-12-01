module main

import os

fn part01(lines []string) !u64 {
	mut sum := u64(0)
	for line in lines {
		mut nums := []u64{}
		for c in line.split('') {
			if num := c.parse_uint(10, 64) {
				nums << num
			}
		}
		calibration_value := (nums[0] * 10) + nums#[-1..][0]
		sum += calibration_value
	}
	return sum
}

fn part02(lines []string) !int {
	mut sum := 0
	for line in lines {
		string_numbers := {
			'one':   1
			'two':   2
			'three': 3
			'four':  4
			'five':  5
			'six':   6
			'seven': 7
			'eight': 8
			'nine':  9
		}

		mut nums := []int{}
		for i in 0 .. line.len {
			if num := line.substr(i, i + 1).parse_uint(10, 64) {
				nums << int(num)
			} else {
				for key, value in string_numbers {
					if line.substr(i, line.len).starts_with(key) {
						nums << value
					}
				}
			}
		}

		calibration_value := (nums[0] * 10) + nums#[-1..][0]
		sum += calibration_value
	}
	return sum
}

fn main() {
	lines := os.read_lines('input/input_1.txt')!

	println(part01(lines)!)
	println(part02(lines)!)
}
