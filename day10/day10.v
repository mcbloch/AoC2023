module main

import os
import time { new_stopwatch }
import math { floor }
import arrays { flatten, group }

struct Coordinate {
	y int
	x int
}

fn (coord Coordinate) up() Coordinate {
	return Coordinate{
		y: coord.y - 1
		x: coord.x
	}
}

fn (coord Coordinate) down() Coordinate {
	return Coordinate{
		y: coord.y + 1
		x: coord.x
	}
}

fn (coord Coordinate) left() Coordinate {
	return Coordinate{
		y: coord.y
		x: coord.x - 1
	}
}

fn (coord Coordinate) right() Coordinate {
	return Coordinate{
		y: coord.y
		x: coord.x + 1
	}
}

fn at(s_arr []string, coord Coordinate) rune {
	return s_arr[coord.y][coord.x]
}

fn (arr [][]string) at(coord Coordinate) string {
	return arr[coord.y][coord.x]
}

fn (mut arr [][]string) set(coord Coordinate, value string) {
	arr[coord.y][coord.x] = value
}

fn find_initial_step(lines []string, start Coordinate) Coordinate {
	if at(lines, start.down()) in [`|`, `L`, `J`] {
		return start.down()
	}
	if at(lines, start.up()) in [`|`, `7`, `F`] {
		return start.up()
	}
	if at(lines, start.right()) in [`-`, `7`, `J`] {
		return start.right()
	}
	if at(lines, start.left()) in [`-`, `L`, `F`] {
		return start.left()
	}
	panic('No connecting pipes around starting point')
}

fn find_loop(lines []string) []Coordinate {
	// Find starting point -> letter S
	mut start := Coordinate{0, 0}
	for row_i, row in lines {
		for col_i, c in row {
			if c == `S` {
				start = Coordinate{row_i, col_i}
				break
			}
		}
	}
	// println('start at ${start}')

	// Find the direction we can go to from S
	mut curr := find_initial_step(lines, start)
	mut pipe := []Coordinate{cap: 1000}
	pipe << [start, curr]

	// Start to walk the loop
	for {
		prev := pipe[pipe.len - 2]
		curr = pipe.last()

		c := lines[curr.y][curr.x]
		new := match c {
			`|` {
				if prev.y < curr.y {
					curr.down()
				} else {
					curr.up()
				}
			}
			`-` {
				if prev.x < curr.x {
					curr.right()
				} else {
					curr.left()
				}
			}
			`L` {
				if prev.y < curr.y {
					curr.right()
				} else {
					curr.up()
				}
			}
			`J` {
				if prev.y < curr.y {
					curr.left()
				} else {
					curr.up()
				}
			}
			`7` {
				if prev.y > curr.y {
					curr.left()
				} else {
					curr.down()
				}
			}
			`F` {
				if prev.y > curr.y {
					curr.right()
				} else {
					curr.down()
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
		pipe << new
	}
	return pipe
}

fn part01(lines []string) !int {
	pipe := find_loop(lines)
	// println(lines.map(it.split('').join(' ')).join('\n'))
	// println(pipe)
	// println(pipe.map(lines[it.y][it.x].ascii_str()))
	return int(floor(pipe.len / 2))
}

fn part02(lines []string) !int {
	// Padd everything with spacing, allowing flow of open space, but not counting as ground.
	mut grid := lines.map(it.split(''))

	// Find loop and make everything else ground
	pipe := find_loop(lines)
	for ri, r in grid {
		for ci, _ in r {
			coord := Coordinate{ri, ci}
			if coord !in pipe {
				grid.set(coord, '.')
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
		if row_i % 2 == 0 {
			continue
		}
		for col_i, c in row {
			if col_i % 2 == 0 {
				continue
			}
			coord := Coordinate{row_i, col_i}
			match c {
				'|' {
					grid.set(coord.up(), '|')
					grid.set(coord.down(), '|')
				}
				'-' {
					grid.set(coord.left(), '-')
					grid.set(coord.right(), '-')
				}
				'L' {
					grid.set(coord.up(), '|')
					grid.set(coord.right(), '-')
				}
				'J' {
					grid.set(coord.up(), '|')
					grid.set(coord.left(), '-')
				}
				'7' {
					grid.set(coord.down(), '|')
					grid.set(coord.left(), '-')
				}
				'F' {
					grid.set(coord.down(), '|')
					grid.set(coord.right(), '-')
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
	mut done := []Coordinate{}
	mut queue := []Coordinate{}
	dirs := [Coordinate{1, 0}, Coordinate{-1, 0}, Coordinate{0, 1},
		Coordinate{0, -1}]

	// Add all positions on the outside in the queue
	for i in 0 .. grid.len {
		queue << Coordinate{i, 0}
		queue << Coordinate{i, grid[0].len - 1}
	}
	for i in 0 .. grid[0].len {
		queue << Coordinate{0, i}
		queue << Coordinate{grid.len - 1, i}
	}

	for (queue.len > 0) {
		pos := queue.pop()
		for dir in dirs {
			new_pos := Coordinate{pos.y + dir.y, pos.x + dir.x}
			if new_pos.y >= 0 && new_pos.x >= 0 && new_pos.y < grid.len && new_pos.x < grid[0].len
				&& grid.at(new_pos) in [' ', '.'] && new_pos !in done {
				queue << new_pos
				grid.set(new_pos, 'O')
			}
		}
		done << pos
	}
	// println('--------------------')
	// println(grid.map(it.join('')).join('\n'))
	// println('--------------------')
	// println(done)
	// println(queue)

	// Count dots left in grids
	return arrays.sum(grid.map(it.filter(it == '.').len))
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
		println('Part 02 took: ${sw.elapsed().milliseconds()}ms')
	}
}
