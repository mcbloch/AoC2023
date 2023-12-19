module main

import os { read_lines }
import time { new_stopwatch }
import arrays
import math { min }

struct Position {
mut:
	row int
	col int
}

fn part01(data []string) !int {
	mut holes := []Position{}
	mut current := Position{0, 0}
	holes << current

	println('Digging outer ring')

	for line in data {
		splits := line.split(' ')
		direction := splits[0]
		length := splits[1]
		// color := splits[3]

		for _ in 0 .. length.int() {
			match direction {
				'U' { current.row -= 1 }
				'D' { current.row += 1 }
				'L' { current.col -= 1 }
				'R' { current.col += 1 }
				else { panic('unknown character') }
			}
			holes << Position{
				...current
			}
		}
	}

	lowest_row := arrays.min(holes.map(it.row)) or { 0 }
	lowest_col := arrays.min(holes.map(it.col)) or { 0 }
	highest_row := arrays.max(holes.map(it.row)) or { 0 }
	highest_col := arrays.max(holes.map(it.col)) or { 0 }

	width := highest_col + 1 - lowest_col
	height := highest_row + 1 - lowest_row
	println('${width} - ${height}')

	println('Filling in new holes')

	// mut new_holes := []Position{}
	mut hole_grid := [][]bool{len: height, init: []bool{len: width, init: false}}
	mut hole_orig := [][]bool{len: height, init: []bool{len: width, init: false}}
	for hole in holes {
		hole_orig[hole.row - lowest_row][hole.col - lowest_col] = true
	}

	println('Start')

	for row in 0 .. height {
		mut inside := false
		mut prev_wall := false
		for col in 0 .. width {
			if hole_orig[row][col] {
				prev_wall = true
			} else if prev_wall {
				if !inside && (row > 0 && (hole_grid[row - 1][col] || (col > 0
					&& hole_orig[row - 1][col] && hole_orig[row][col - 1]))) {
					inside = true
					prev_wall = false
				} else if inside && (!hole_grid[row - 1][col] || hole_orig[row - 1][col]) {
					inside = false
					prev_wall = false
				}
			}

			if inside && !hole_orig[row][col] {
				hole_grid[row][col] = true
			}
		}
	}

	println('Calculating total amount of holes')
	filled_count := arrays.sum(hole_grid.map(it.filter(it).len)) or { 0 }
	println(filled_count)
	original_count := arrays.sum(hole_orig.map(it.filter(it).len)) or { 0 }
	println(original_count)
	count_holes := filled_count + original_count

	// for row in 0 .. height {
	// 	for col in 0 .. width {
	// 		if hole_orig[row][col] {
	// 			print('#')
	// 		} else if hole_grid[row][col] {
	// 			print('-')
	// 		} else {
	// 			print(' ')
	// 		}
	// 		print('')
	// 	}
	// 	print('\n')
	// }

	return count_holes
}

fn set(mut m map[int]map[int]bool, row int, col int) {
	if row !in m {
		m[row] = map[int]bool{}
		m[row][col] = true
	} else {
		m[row][col] = true
	}
}

fn get(m map[int]map[int]bool, row int, col int) bool {
	if row !in m {
		return false
	}
	return m[row][col]
}

struct Range {
mut:
	from int
	len  int
}

fn (r Range) str() string {
	return '[${r.from} -> ${r.from + r.len}]'
}

fn (r Range) contains(i int) bool {
	return r.from <= i && i < r.from + r.len
}

fn is_in_ranges(rs []Range, col int) bool {
	return rs.any(it.contains(col))
}

fn has(rs [][]Range, row int, col int){
	return rs[row].any(it.contains(col))
}
fn get(rs [][]Range, row int, col int){
	return rs[row].filter(it.contains(col))[0]
}

fn part02(data []string) !int {
	mut holes := []Position{}
	mut current := Position{0, 0}
	// holes << current

	println('Digging outer ring')

	mut walls := [][]Range{}
	mut start_pos := [0, 0]

	for line in data {
		instruction := line.split(' ')[2]
		distance := instruction[2..7].parse_int(16, 64)!
		direction_num := instruction[7]

		for _ in 0 .. distance {
			match direction_num {
				`3` { current.row -= 1 }
				`1` { current.row += 1 }
				`2` { current.col -= 1 }
				`0` { current.col += 1 }
				else { panic('unknown direction number') }
			}

			if has(walls, current.row, current.col - 1){
				get(walls, current.row, current.col - 1).len += 1
			}
			if has(walls, current.row, current.col + 1){
				mut r := get(walls, current.row, current.col - 1)
				r.from -= 1
				r.len += 1
			}

			// holes << Position{
			// 	...current
			// }
		}
	}

	// PART 1!
	// for line in data {
	// 	splits := line.split(' ')
	// 	direction := splits[0]
	// 	length := splits[1]
	// 	// color := splits[3]

	// 	for _ in 0 .. length.int() {
	// 		match direction {
	// 			'U' { current.row -= 1 }
	// 			'D' { current.row += 1 }
	// 			'L' { current.col -= 1 }
	// 			'R' { current.col += 1 }
	// 			else { panic('unknown character') }
	// 		}
	// 		holes << Position{
	// 			...current
	// 		}
	// 	}
	// }

	// lowest_row := arrays.min(holes.map(it.row)) or { 0 }
	// lowest_col := arrays.min(holes.map(it.col)) or { 0 }
	// highest_row := arrays.max(holes.map(it.row)) or { 0 }
	// highest_col := arrays.max(holes.map(it.col)) or { 0 }

	lowest_row := arrays.min(walls.map(it.from)) or {0}
	lowest_row := arrays.min(walls.map(it.from)) or {0}

	width := highest_col + 1 - lowest_col
	height := highest_row + 1 - lowest_row
	println('${width} - ${height}')

	println('Filling in new holes')

	// mut new_holes := []Position{}
	// mut hole_grid := [][]bool{len: height, init: []bool{len: width, init: false}}
	// mut hole_orig := [][]bool{len: height, init: []bool{len: width, init: false}}

	// mut hole_grid := map[int]map[int]bool{}
	mut hole_orig := map[int]map[int]bool{}
	mut walls := [][]Range{}

	for hole in holes {
		set(mut hole_orig, hole.row - lowest_row, hole.col - lowest_col)
		// hole_orig[hole.row - lowest_row][hole.col - lowest_col] = true
	}
	println('Convert holemap to range walls')
	for row in 0..height {
		walls << []Range{}
		for col in 0..width {
			mut range_started := false
			mut range := Range{}
			if hole_orig[row][col] { 
				if ! range_started {
					range_started = true
					range.from = col
				}
			} else {
				if range_started {
					range_started = false
					range.len = col - range.from
					walls[walls.len - 1] << Range{...range}
				}
			}
		}
	}

	println('Start')

	mut filled_count := 0
	mut prev_row_ranges := []Range{}
	mut curr_row_ranges := []Range{}
	for row in 0 .. height {
		if row % 100 == 0 {
			println('Row ${row}')
		}
		mut inside := false
		mut inside_range := Range{}
		for col in 0 .. width {
			// println(hole_orig[row])

			if col > 0 && !get(hole_orig, row, col) && get(hole_orig, row, col - 1) {
				if !inside && (row > 0 && (is_in_ranges(prev_row_ranges, col)
					|| (col > 0 && get(hole_orig, row - 1, col) && get(hole_orig, row, col - 1)))) {
					inside = true
				} else if inside && (!is_in_ranges(prev_row_ranges, col)
					|| get(hole_orig, row - 1, col)) {
					inside = false
				}
			}

			if col > 0 && inside {
				if !hole_orig[row][col] && hole_orig[row][col - 1] {
					inside_range.from = col
				}
				if hole_orig[row][col] && !hole_orig[row][col - 1] {
					inside_range.len = col - inside_range.from
					curr_row_ranges << Range{
						...inside_range
					}
				}
			}

			if inside && !get(hole_orig, row, col) {
				filled_count += 1
				// set(mut hole_grid, row, col)
			}
		}
		// println(curr_row_ranges)
		// println(filled_count)
		// for coli in 0 .. width {
		// 	if is_in_ranges(curr_row_ranges, coli) {
		// 		print('-')
		// 	} else if hole_orig[row][coli] {
		// 		print('#')
		// 	} else {
		// 		print(' ')
		// 	}
		// }
		// println('')

		// if curr_row_ranges.len > 0 {
		// 	print(' '.repeat(curr_row_ranges[0].from))
		// 	for ri, range in curr_row_ranges {
		// 		print('-'.repeat(range.len))
		// 		if ri < curr_row_ranges.len - 2 {
		// 			print(' '.repeat(curr_row_ranges[ri + 1].from - (range.from + range.len)))
		// 		}
		// 	}
		// }
		// println('')

		prev_row_ranges = curr_row_ranges.clone()
		curr_row_ranges.clear()
	}

	println('Calculating total amount of holes')
	// filled_count := arrays.sum(hole_grid.values().map(it.len)) or {0}
	// filled_count := arrays.sum(hole_grid.map(it.filter(it).len)) or { 0 }
	println(filled_count)
	original_count := arrays.sum(hole_orig.values().map(it.len)) or { 0 }
	// original_count := arrays.sum(hole_orig.map(it.filter(it).len)) or { 0 }
	println(original_count)
	count_holes := filled_count + original_count

	// for row in 0 .. height {
	// 	for col in 0 .. width {
	// 		if get(hole_orig, row, col) {
	// 			print('#')
	// 		}
	// 		// else if get(hole_grid, row, col) {
	// 		// 	print('-')
	// 		// }
	// 		else {
	// 			print(' ')
	// 		}
	// 		print('')
	// 	}
	// 	print('\n')
	// }

	return count_holes
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/18.txt' }
	}
	println('Reading input: ${inputfile}')
	data := read_lines(inputfile)!

	if os.args.len >= 3 {
		mut sw := new_stopwatch()
		match os.args[2] {
			'1' { println(part01(data)!) }
			'2' { println(part02(data)!) }
			else { println('Unknown part specified') }
		}
		println('Took: ${sw.elapsed().milliseconds()}ms')
	} else {
		mut sw := new_stopwatch()
		println(part01(data)!)
		println('Part 01 took: ${sw.elapsed().milliseconds()}ms')
		sw.restart()
		println(part02(data)!)
		println('Part 02 took: ${sw.elapsed().milliseconds()}ms')
	}
}
