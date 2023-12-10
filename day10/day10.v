module main

import os
import time { new_stopwatch }
import math { floor }
import arrays { flatten, group }

fn find_initial_step(lines []string, start []int) []int {
	mut curr := [start[0] + 1, start[1]]
	if lines[curr[0]][curr[1]] in [`|`, `L`, `J`] {
		return curr
	}
	curr = [start[0] - 1, start[1]]
	if lines[curr[0]][curr[1]] in [`|`, `7`, `F`] {
		return curr
	}
	curr = [start[0], start[1] + 1]
	if lines[curr[0]][curr[1]] in [`-`, `7`, `J`] {
		return curr
	}
	curr = [start[0], start[1] - 1]
	if lines[curr[0]][curr[1]] in [`-`, `L`, `F`] {
		return curr
	}
	panic('No connecting pipes around starting point')
}

fn find_loop(lines []string) [][]int {
	// Find starting point -> letter S
	mut start := [0, 0]
	for row_i, row in lines {
		for col_i, c in row {
			if c == `S` {
				start = [row_i, col_i]
				break
			}
		}
	}
	println('start at ${start}')

	// Find the direction we can go to from S
	mut curr := find_initial_step(lines, start)
	mut prev := start.clone()
	mut pipe := [start, curr]

	// Start to walk the loop
	for {
		c := lines[curr[0]][curr[1]]
		new := match c {
			`|` {
				if prev[0] < curr[0] {
					[curr[0] + 1, curr[1]]
				} else {
					[curr[0] - 1, curr[1]]
				}
			}
			`-` {
				if prev[1] < curr[1] {
					[curr[0], curr[1] + 1]
				} else {
					[curr[0], curr[1] - 1]
				}
			}
			`L` {
				if prev[0] < curr[0] {
					[curr[0], curr[1] + 1]
				} else {
					[curr[0] - 1, curr[1]]
				}
			}
			`J` {
				if prev[0] < curr[0] {
					[curr[0], curr[1] - 1]
				} else {
					[curr[0] - 1, curr[1]]
				}
			}
			`7` {
				if prev[0] > curr[0] {
					[curr[0], curr[1] - 1]
				} else {
					[curr[0] + 1, curr[1]]
				}
			}
			`F` {
				if prev[0] > curr[0] {
					[curr[0], curr[1] + 1]
				} else {
					[curr[0] + 1, curr[1]]
				}
			}
			`.` {
				panic('Impossible location to arrive on in the loop.')
			}
			`S` {
				break
			}
			else {
				panic('Unknown character in input')
			}
		}

		prev = curr.clone()
		curr = new.clone()
		pipe << new
	}
	return pipe
}

fn part01(lines []string) !int {
	pipe := find_loop(lines)
	// println(lines.map(it.split('').join(' ')).join('\n'))
	// println(pipe)
	// println(pipe.map(lines[it[0]][it[1]].ascii_str()))
	return int(floor(pipe.len / 2))
}

fn part02(lines []string) !int {
	// Padd everything with spacing, allowing flow of open space, but not counting as ground.
	println(lines.join('\n'))
	mut grid := lines.map(it.split(''))

	// Find loop and make everything else ground
	pipe := find_loop(lines)
	for ri, r in grid {
		for ci, c in r {
			if ! ([ri, ci] in pipe) {
				grid[ri][ci] = '.'
			}
		}
	}

	// Pad the grid with whitespace to allow flow
	grid = grid.map(' ${it.join(' ')} '.split(''))
	width := grid[0].len
	height := grid.len
	mut blanks := [][]string{len: height, init: ' '.repeat(width).split('')}
	grid = flatten(group[[]string](blanks, grid))
	grid << ' '.repeat(width).split('')

	// println('='.repeat(grid[0].len+4))
	// println(grid.map('||'+it.join('')+'||').join('\n'))
	// println('='.repeat(grid[0].len+4))

	// now extend the characters
	for row_i, row in grid {
		if row_i % 2 == 0{
			continue
		}
		for col_i, c in row {
			if col_i % 2 == 0{
				continue
			}
			match c {
				'|' {
					// println(row)
					grid[row_i - 1][col_i] = '|'
					grid[row_i + 1][col_i] = '|'
				}
				'-' {
					grid[row_i][col_i - 1] = '-'
					grid[row_i][col_i + 1] = '-'
				}
				'L' {
					grid[row_i - 1][col_i] = '|'
					grid[row_i][col_i + 1] = '-'
				}
				'J' {
					grid[row_i - 1][col_i] = '|'
					grid[row_i][col_i - 1] = '-'
				}
				'7' {
					grid[row_i + 1][col_i] = '|'
					grid[row_i][col_i - 1] = '-'
					
				}
				'F' {
					grid[row_i + 1][col_i] = '|'
					grid[row_i][col_i + 1] = '-'
					
				}
				else {}
			}
		}
		// println('='.repeat(grid[0].len+4))
		// println(grid.map('||'+it.join('')+'||').join('\n'))
		// println('='.repeat(grid[0].len+4))
	}


	// println('='.repeat(grid[0].len+4))
	// println(grid.map('||'+it.join('')+'||').join('\n'))
	// println('='.repeat(grid[0].len+4))

	// Floodfill algorithm, starting on the outside.
	mut done := [][]int{}
	mut queue := [][]int{}
	// Add all positions on the outside in the queue
	for i in 0..grid.len {
		queue << [i, 0]
		queue << [i, grid[0].len-1]
	}
	for i in 0..grid[0].len {
		queue << [0, i]
		queue << [grid.len-1, i]
	}

	for (queue.len > 0) {
		pos := queue.pop()
		for dir in [[1, 0], [-1, 0], [0, 1], [0, -1]] {
			new_pos := [pos[0] + dir[0], pos[1] + dir[1]]
			if new_pos[0] >= 0 && new_pos[1] >= 0 && new_pos[0] < grid.len
				&& new_pos[1] < grid[0].len && grid[new_pos[0]][new_pos[1]] in [' ', '.']
				&& (new_pos !in done) {
				queue << new_pos
				grid[new_pos[0]][new_pos[1]] = 'O'
			}
		}
		done << pos
	}
	println('--------------------')
	println(grid.map(it.join('')).join('\n'))
	println('--------------------')
	// println(done)
	// println(queue)

	return arrays.map_of_counts(arrays.flatten(grid))['.']
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/10.txt' }
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
		println('Part 01 took: ${sw.elapsed().microseconds()}us')
		sw.restart()
		println(part02(lines)!)
		println('Part 02 took: ${sw.elapsed().microseconds()}us')
	}
}
