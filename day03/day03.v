module main

import os
import time

fn part01(lines []string) !int {
	mut sum := 0
	directions := [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1],
		[-1, 1], [-1, -1]]
	for row_i, line in lines {
		mut indices := []int{}
		for col_i, c in line {
			if c.is_digit() {
				indices << col_i
			}

			if (!c.is_digit() && indices.len > 0)
				|| (c.is_digit() && col_i == line.len - 1 && indices.len > 0) {
				// Search for a special character surrounding one of the numbers
				mut valid_number := false
				outer: for idx in indices {
					for offset in directions {
						new_x := row_i + offset[0]
						new_y := idx + offset[1]
						if new_x < 0 || new_y < 0 || new_x >= lines.len || new_y >= lines[new_x].len {
							continue
						}

						if !(lines[new_x][new_y].is_digit()) && !(lines[new_x][new_y] == `.`) {
							valid_number = true
							break outer
						}
					}
				}
				slice := line[indices.first()..indices.last() + 1]
				if valid_number {
					sum += slice.int()
					// println('${slice} is valid')
				} else {
					// println('${slice} is not valid')
				}
				indices.clear()
			}
		}
	}
	return sum
}

struct Position {
	x int
	y int
}

fn part02(lines []string) !int {
	mut sum := 0
	directions := [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1],
		[-1, 1], [-1, -1]]
	mut gears := map[string][]int{}

	for row_i, line in lines {
		mut indices := []int{}
		for col_i, c in line {
			if c.is_digit() {
				indices << col_i
			}

			if (!c.is_digit() && indices.len > 0)
				|| (c.is_digit() && col_i == line.len - 1 && indices.len > 0) {
				// Search for a special character surrounding one of the numbers
				mut gear_location := ''
				mut gear_found := false
				outer: for idx in indices {
					for offset in directions {
						new_x := row_i + offset[0]
						new_y := idx + offset[1]
						if new_x < 0 || new_y < 0 || new_x >= lines.len || new_y >= lines[new_x].len {
							continue
						}

						if lines[new_x][new_y] == `*` {
							gear_location = '${new_x}-${new_y}'
							gear_found = true
							break outer
						}
					}
				}
				slice := line[indices.first()..indices.last() + 1].int()
				if gear_found {
					if gear_location !in gears {
						gears[gear_location] = []
					}
					gears[gear_location] << slice
					// println('${slice} is valid')
				} else {
					// println('${slice} is not valid')
				}
				indices.clear()
			}
		}
	}
	for _, parts in gears {
		if parts.len == 2 {
			sum += parts[0] * parts[1]
		}
	}
	// println(gears)
	return sum
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/03.txt'
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
