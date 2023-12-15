module main

import os
import time { new_stopwatch }
// import math
import arrays
// import regex

struct Lens {
	label        string
	focal_length int
}

fn (l Lens) str() string {
	return 'Lens(${l.label}, ${l.focal_length})'
}

fn part02(data string) !int {
	mut hashmap := map[int][]Lens{}
	for stepp in data.split(',') {
		mut step := stepp.replace('\n', '')

		mut split := step.split_any('=-')
		prefix := split[0]

		key := arrays.fold(prefix.bytes(), 0, fn(acc int, elem u8) int {
			return ((acc + elem) * 17) % 256
		})

		if step.contains('=') {
			if key !in hashmap {
				hashmap[key] = []Lens{}
			}

			length := split[1].int()
			if hashmap[key].any(it.label == prefix) {
				hashmap[key] = hashmap[key].map(fn [prefix, length] (it Lens) Lens {
					if it.label == prefix {
						return Lens{prefix, length}
					} else {
						return it
					}
				})
			} else {
				hashmap[key] << Lens{prefix, length}
			}
		}

		if step.contains('-') {
			hashmap[key] = hashmap[key].filter(it.label != prefix)
		}
	}

	mut sum := 0
	for k, v in hashmap {
		for li, l in v {
			l_value := ((k+1) * (li+1) * l.focal_length)
			sum += l_value
		}
	}

	return sum
}

fn part01(data string) !int {
	mut sum := 0

	for step in data.split(',') {
		mut current_value := 0
		for c in step {
			if c == `\n` {
				continue
			}
			current_value += c
			current_value *= 17
			current_value %= 256
		}
		sum += current_value
	}

	return sum
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/15.txt' }
	}
	println('Reading input: ${inputfile}')
	data := os.read_file(inputfile)!

	if os.args.len >= 3 {
		match os.args[2] {
			'1' { println(part01(data)!) }
			'2' { println(part02(data)!) }
			else { println('Unknown part specified') }
		}
	} else {
		mut sw := new_stopwatch()
		println(part01(data)!)
		println('Part 01 took: ${sw.elapsed().milliseconds()}ms')
		sw.restart()
		println(part02(data)!)
		println('Part 02 took: ${sw.elapsed().milliseconds()}ms')
	}
}
