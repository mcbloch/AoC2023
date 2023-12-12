module main

import os
import time { new_stopwatch }
// import math
import arrays

fn part01(lines []string) !i64 {
	mut sum := 0
	for line in lines {
		temp := line.split(' ')
		mut springs := temp[0]
		temp_sizes := temp[1].split(',').map(it.int())
		mut sizes := temp_sizes.clone()
		// for i in 0 .. 2 {
		// 	springs += '?' + temp[0]
		// 	sizes << temp_sizes
		// }

		println('${springs} - ${sizes}')

		mut t := arrays.map_indexed(sizes, fn [springs, sizes] (idx int, elem int) []int {
			offset := arrays.sum(sizes[..idx].map(it + 1)) or { 0 }
			offset_end := arrays.sum(sizes[idx + 1..].map(it + 1)) or { 0 }
			return []int{len: (springs.len - elem + 1 - offset - offset_end), init: index + offset}
		})
		// Yeet pointers that we can exclude upfront.
		// Some conditions are dependent on the combinations. They will be looked at in THE loop itself.
		println(t)
		for pi, mut t_opts in t {
			mut delete_count := 0
			for so_i, spring_offset in t_opts.clone() {
				size := sizes[pi]
				if springs[spring_offset..spring_offset + size].contains('.') {
					t_opts.delete(so_i - delete_count)
					delete_count += 1
				}
			}
		}

		println(t)
		mut options := 0
		mut pointers := []int{len: sizes.len, init: 0}
		for {
			// println(pointers)
			mut valid_option := true
			offsets := arrays.map_indexed(pointers, fn [t] (idx int, elem int) int {
				return t[idx][elem]
			})
			if arrays.window(offsets, size: 2).any(it[0] >= it[1]) {
				valid_option = false
			}

			if valid_option {
				for pi, p in pointers {
					selection := springs.substr(t[pi][p], t[pi][p] + sizes[pi])
					// println('checking: size=${sizes[pi]}, at=${t[pi][p]}, ${selection}')
					if (pi > 0 && t[pi - 1][pointers[pi - 1]] >= t[pi][p] - 1)
						|| (pi < pointers.len - 1
						&& t[pi + 1][pointers[pi + 1]] <= (t[pi][p] + sizes[pi])) {
						valid_option = false
						break
					}
				}
			}

			if valid_option {
				mut result := []string{len: springs.len, init: '_'}
				for pi, p in pointers {
					for i in 0 .. sizes[pi] {
						result[t[pi][p] + i] = 'x'
					}
				}
				// Check if all fixed # characters are mapped
				for ci, c in springs {
					if c == `#` && result[ci] != 'x' {
						valid_option = false
						break
					}
				}
			}

			if valid_option {
				mut result := []string{len: springs.len, init: '_'}
				for pi, p in pointers {
					for i in 0 .. sizes[pi] {
						result[t[pi][p] + i] = 'x'
					}
				}
				println(pointers)
				println(springs)
				println(result.join(''))
				println('')
				options += 1
			}

			pointers[0] += 1
			for i in 1 .. pointers.len {
				if pointers[i - 1] >= t[i - 1].len {
					pointers[i - 1] = 0
					pointers[i] += 1
				}
			}
			if pointers[pointers.len - 1] >= t[t.len - 1].len {
				break
			}
			// println('---')
		}
		println(options)
		println('=====')
		sum += options
	}

	return sum
}

fn part02(lines []string) !i64 {
	return 0
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/12.txt' }
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
		println('Part 01 took: ${sw.elapsed().milliseconds()}ms')
		sw.restart()
		println(part02(lines)!)
		println('Part 02 took: ${sw.elapsed().milliseconds()}ms')
	}
}
