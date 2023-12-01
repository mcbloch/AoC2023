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
		// println('${nums} -> ${calibration_value}')
		sum += calibration_value
	}
	return sum
}

fn part02(lines []string) !int {
	// string_numbers := ['one', '1', 'two', '2', 'three', '3', 'four', '4', 'five', '5', 'six', '6',
	// 	'seven', '7', 'eight', '8', 'nine', '9']
	// string_numbers := [['one', '1'], ['two', '2'], ['three', '3'],
	// 	['four', '4'], ['five', '5'], ['six', '6'], ['seven', '7'],
	// 	['eight', '8'], ['nine', '9']]

	mut sum := 0
	for line in lines {
		// Does not replace in the order of the string but in the order of the replacements :(
		// line_editted := line.replace_each(string_numbers)

		// Does not allow overlap wich apprently needs to be supported
		// mut line_editted := line
		// mut keep_replacing := true
		// for keep_replacing {
		// 	mut first_replacement_idx := line.len
		// 	mut first_replacement_pair := []string{}
		// 	for replacement in string_numbers {
		// 		if idx := line_editted.index(replacement[0]) {
		// 			if idx < first_replacement_idx {
		// 				first_replacement_idx = idx
		// 				first_replacement_pair = replacement.clone()
		// 			}
		// 		}
		// 	}
		// 	if first_replacement_pair.len > 0 {
		// 		line_editted = line_editted.replace_once(first_replacement_pair[0], first_replacement_pair[1])
		// 	} else {
		// 		keep_replacing = false
		// 	}
		// }

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
		// println('${line} -> ${line_editted} -> ${calibration_value}')
		// println('${nums} -> ${calibration_value}')
		sum += calibration_value
	}
	return sum
}

fn main() {
	// mut f := os.open('input_1.txt') or { panic(err) }
	// defer {
	//     f.close()
	// }
	// content = f.read()
	lines := os.read_lines('input/input_1.txt')!

	println(part01(lines)!)
	println(part02(lines)!)
}
