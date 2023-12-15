module main

import os
import time { new_stopwatch }
// import math
import arrays
// import regex

struct Lens {
	label string
mut:
	focal_length int
}

fn (l Lens) str() string {
	return 'Lens(${l.label}, ${l.focal_length})'
}

fn part02(data string) !int {
	mut hashmap := [][]Lens{len: 256, init: []Lens{}}
	for step in data.split(',') {
		mut split := step.replace('\n', '').split_any('=-')

		key := arrays.fold(split[0].bytes(), 0, fn (acc int, elem u8) int {
			return ((acc + elem) * 17) % 256
		})

		if step.contains('=') {
			new_lens := Lens{split[0], split[1].int()}
			if hashmap[key].any(it.label == new_lens.label) {
				hashmap[key] = hashmap[key].map(if it.label == new_lens.label {
					new_lens
				} else {
					it
				})
			} else {
				hashmap[key] << new_lens
			}
		} else if step.contains('-') {
			hashmap[key] = hashmap[key].filter(it.label != split[0])
		}
	}

	return arrays.sum(arrays.map_indexed(hashmap, fn (k int, v []Lens) int {
		return arrays.sum(arrays.map_indexed(v, fn [k] (idx int, l Lens) int {
			return (k + 1) * (idx + 1) * l.focal_length
		})) or { 0 }
	})) or { 0 }
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
