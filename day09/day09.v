module main

import os
import time as tme { new_stopwatch }
// import math
import arrays
// import maps

fn part01(lines []string) !i64 {
	mut sum := 0
	for line in lines {
		history := line.split(' ').map(it.int())
		mut differences := [][]int{}
		differences << history
		for (differences.last().any(it != 0)){
			differences << arrays.window(differences.last(), size: 2).map(it[1] - it[0])
		}
		differences.last() << 0
		for i in 1..differences.len {
			idx := differences.len-1-i
			differences[idx] << differences[idx].last() + differences[idx+1].last()
		}
		sum += differences[0].last()
	}
	
	
	return sum
}

fn part02(lines []string) !i64 {
	mut sum := 0
	for line in lines {
		history := line.split(' ').map(it.int())
		mut differences := [][]int{}
		differences << history
		for (differences.last().any(it != 0)){
			differences << arrays.window(differences.last(), size: 2).map(it[1] - it[0])
		}
		mut last_line := differences.last()
		last_line.prepend(0)
		for i in 1..differences.len {
			idx := differences.len-1-i
			differences[idx].prepend(differences[idx].first() - differences[idx+1].first())
		}
		sum += differences[0].first()
	}
	
	
	return sum
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/09.txt'
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
