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
		for i in 0..2 {
			springs += '?'+temp[0]
			sizes << temp_sizes
		}

		println('${springs} - ${sizes}')

		t := arrays.map_indexed(sizes, fn [springs, sizes] (idx int, elem int) []int {
			offset := arrays.sum(sizes[..idx].map(it + 1)) or { 0 }
			offset_end := arrays.sum(sizes[idx + 1..].map(it + 1)) or { 0 }
			return []int{len: (springs.len - elem + 1 - offset - offset_end), init: index + offset}
		})
		// println(t)
		mut options := 0
		mut pointers := []int{len: sizes.len, init: 0}
		for {
			// println(pointers)
			mut valid_option := true
			for pi, p in pointers {
				selection := springs.substr(t[pi][p], t[pi][p] + sizes[pi])
				// println('checking: size=${sizes[pi]}, at=${t[pi][p]}, ${selection}')
				if selection.contains('.') || (pi > 0 && t[pi-1][pointers[pi-1]] >= t[pi][p] - 1) || (pi < pointers.len -1 && t[pi+1][pointers[pi+1]] <= (t[pi][p]+sizes[pi])) {
					valid_option = false
					break
				}
			}
			mut result := []string{len: springs.len, init: '_'}
			for pi, p in pointers {
				for i in 0..sizes[pi] {
					result[t[pi][p] + i] = 'x'
				}
			}
			for ci, c in springs {
				if c == `#` && result[ci] != 'x' {
					valid_option = false
					break
				}
			}

			if valid_option {
				// println(pointers)
				// println(springs)
				// println(result.join(''))
				// println('')
				options += 1
			}

			pointers[0] += 1
			for i in 1 .. pointers.len {
				if pointers[i - 1] >= t[i - 1].len {
					pointers[i - 1] = 0
					pointers[i] += 1
				}
			}
			if pointers[pointers.len-1] >= t[t.len - 1].len {
				break
			}
			// println('---')
		}
		// println(options)
		// println('=====')
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
