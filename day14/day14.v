module main

import os
import time { new_stopwatch }
// import math
import arrays
// import regex

fn str_grid_u8(lines [][]u8) string {
	header := []string{len: lines[0].len, init: (index + 1).str()}
	return '-'.repeat(lines[0].len) + '\n' + header.join('') + '\n' +
		lines.map(it.map(it.ascii_str()).join(' ')).join('\n') + '\n' + '='.repeat(lines[0].len * 2)
}

fn str_grid(lines []string) string {
	header := []string{len: lines[0].len, init: (index + 1).str()}
	return '-'.repeat(lines[0].len) + '\n' + header.join('') + '\n' + lines.join('\n') + '\n' +
		'='.repeat(lines[0].len)
}

fn part01(lines []string) !i64 {
	mut columns := [][]u8{}
	for col_i in 0 .. lines[0].len {
		columns << lines.map(it[col_i])
	}
	// println(str_grid(lines))
	println(str_grid_u8(columns))

	mut total_load := 0

	for line in columns {
		mut cube_rocks := [-1]
		cube_rocks << arrays.map_indexed(line, fn (idx int, elem u8) []int {
			return [idx, if elem == `#` { 1 } else { 0 }]
		}).filter(it[1] == 1).map(it[0])
		cube_rocks << [lines.len]
		println(cube_rocks)
		for pair in arrays.window(cube_rocks, size: 2) {
			if pair[0] + 1 != pair[1] {
				println('  ${line[pair[0] + 1..pair[1]].bytestr()}')

				for ci, c in line[pair[0] + 1..pair[1]].filter(it == `O`) {
					total_load += line.len - (pair[0] + 1 + ci)
				}
			}
		}
	}

	return total_load
}

fn do_cycle(mut grid [][]u8) {
	// UP
	// if direction == [-1, 0] {
	{
		mut col_i := 0
		mut o_idx := -1
		for {
			col := grid.map(it[col_i])
			o_idx += 1
			new_offset := arrays.index_of_first(col[o_idx..], fn (idx int, elem u8) bool {
				return elem == `O`
			})
			if new_offset == -1 {
				o_idx = -1
				col_i += 1
				if col_i >= grid[0].len {
					break
				}
			} else {
				o_idx += new_offset
				mut stop_idx := arrays.index_of_last(col[..o_idx], fn (idx int, elem u8) bool {
					return elem != `.`
				})
				if stop_idx + 1 != o_idx {
					grid[stop_idx + 1][col_i] = `O`
					grid[o_idx][col_i] = `.`
				}
			}
		}
	}
	// LEFT
	// if direction == [0, -1] {
	{
		mut row_i := 0
		mut o_idx := -1
		for {
			row := grid[row_i]
			o_idx += 1
			new_offset := arrays.index_of_first(row[o_idx..], fn (idx int, elem u8) bool {
				return elem == `O`
			})
			if new_offset == -1 {
				o_idx = -1
				row_i += 1
				if row_i >= grid.len {
					break
				}
			} else {
				o_idx += new_offset
				mut stop_idx := arrays.index_of_last(row[..o_idx], fn (idx int, elem u8) bool {
					return elem != `.`
				})
				if stop_idx + 1 != o_idx {
					grid[row_i][stop_idx + 1] = `O`
					grid[row_i][o_idx] = `.`
				}
			}
		}
	}
	// DOWN
	{
		mut col_i := 0
		mut o_idx := -1
		for {
			col := grid.map(it[col_i]).reverse()
			o_idx += 1
			new_offset := arrays.index_of_first(col[o_idx..], fn (idx int, elem u8) bool {
				return elem == `O`
			})
			if new_offset == -1 {
				o_idx = -1
				col_i += 1
				if col_i >= grid[0].len {
					break
				}
			} else {
				o_idx += new_offset
				mut stop_idx := arrays.index_of_last(col[..o_idx], fn (idx int, elem u8) bool {
					return elem != `.`
				}) + 1
				if stop_idx != o_idx {
					grid[grid.len - 1 - stop_idx][col_i] = `O`
					grid[grid.len - 1 - o_idx][col_i] = `.`
				}
			}
		}
	}
	// RIGHT
	// if direction == [0, 1] {
	{
		mut row_i := 0
		mut o_idx := -1
		for {
			row := grid[row_i].reverse()
			o_idx += 1
			new_offset := arrays.index_of_first(row[o_idx..], fn (idx int, elem u8) bool {
				return elem == `O`
			})
			if new_offset == -1 {
				o_idx = -1
				row_i += 1
				if row_i >= grid.len {
					break
				}
			} else {
				o_idx += new_offset
				mut stop_idx := arrays.index_of_last(row[..o_idx], fn (idx int, elem u8) bool {
					return elem != `.`
				}) + 1
				if stop_idx != o_idx {
					grid[row_i][grid[0].len - 1 - stop_idx] = `O`
					grid[row_i][grid[0].len - 1 - o_idx] = `.`
				}
			}
		}
	}
	// println(str_grid_u8(grid))
	// dir_i = (dir_i + 1) % directions.len
}

fn part02(lines []string) !i64 {
	mut grid := lines.map(it.bytes())
	println(str_grid_u8(grid))

	mut compare_state := []string{}

	mut cycle_i := 0
	for (cycle_i < 1000000000) { // 1000000000
		do_cycle(mut grid)
		println(cycle_i)
		// if cycle_i % 100 == 0 {
		// 	println(str_grid_u8(grid))
		// }

		if cycle_i == 1000 {
			compare_state = grid.map(it.bytestr())
		}

		if cycle_i > 1000 {
			mut equal := true
			outer: for line_i in 0 .. lines.len {
				for col_i in 0 .. lines[0].len {
					if compare_state[line_i][col_i] != grid[line_i][col_i] {
						equal = false
						break outer
					}
				}
			}
			if equal {
				println('loop: ${cycle_i}')

				rest := (1000000000 - 1001) % (cycle_i - 1000)

				cycle_i = 1000000000 - rest
				cycle_i -= 1
			}
		}

		cycle_i += 1
	}

	println(str_grid_u8(grid))
	mut total_load := 0
	for row_i, row in grid {
		for c in row {
			if c == `O` {
				total_load += grid.len - row_i
			}
		}
	}
	println(total_load)

	return total_load
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/14.txt' }
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
