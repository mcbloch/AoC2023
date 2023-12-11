module main

import os
import time { new_stopwatch }
import math
import arrays

struct Coordinate {
	y i64
	x i64
}

fn (a Coordinate) distance_to(b Coordinate) i64 {
	return math.abs(a.y - b.y) + math.abs(a.x - b.x)
}

fn (a Coordinate) distance_to_expanded(b Coordinate, expansions []Coordinate, expand_size int) i64 {
	y_addition := expansions.filter(it.x == 0 && ((it.y > a.y && it.y < b.y)
		|| (it.y < a.y && it.y > b.y))).len * (expand_size-1)
	x_addition := expansions.filter(it.y == 0 && ((it.x > a.x && it.x < b.x)
		|| (it.x < a.x && it.x > b.x))).len * (expand_size-1)
	return math.abs(a.y - b.y) + y_addition + math.abs(a.x - b.x) + x_addition
}

fn (grid [][]string) str() string {
	return grid.map(it.join(' ')).join('\n')
}

fn part01(lines []string) !i64 {
	// Expand the galaxy
	mut grid := lines.map(it.split(''))
	for li := 0; li < grid.len; {
		line := grid[li]
		if line.all(it == '.') {
			grid.insert(li, []string{len: grid[0].len, init: '.'})
			li += 1
		}
		li += 1
	}
	for ci := 0; ci < grid[0].len; {
		col := grid.map(it[ci])
		if col.all(it == '.') {
			for mut line in grid {
				line.insert(ci, '.')
			}
			ci += 1
		}
		ci += 1
	}
	// println(grid)
	// println('---------------')

	// Collect galaxies
	mut galaxies := []Coordinate{}
	for ri, row in grid {
		for ci, c in row {
			if c == '#' {
				galaxies << Coordinate{ri, ci}
			}
		}
	}
	// println('Galaxies: ${galaxies}')

	mut distances := [][]i64{len: galaxies.len, init: []i64{len: galaxies.len, init: -1}}
	for i in 0 .. galaxies.len {
		for j in i .. galaxies.len {
			dist := galaxies[i].distance_to(galaxies[j])
			distances[i][j] = dist
			distances[j][i] = dist
		}
	}
	// println(galaxies.map('${it.y:2},${it.x:-2}').join(' | '))
	// println('-'.repeat((galaxies.len * 7) + 6))
	// println(' ' + distances.map(it.map('${it:3}').join('  |  ')).join('\n '))

	// Find shortest path
	shortest_path_sum := arrays.sum(distances.map(arrays.sum(it)!))! / 2
	return shortest_path_sum
}

struct Part2Args {
	expand_size int = 1000000
}

fn part02(lines []string, args Part2Args) !i64 {
	mut grid := lines.map(it.split(''))

	// Expand the galaxy
	mut expansions := []Coordinate{}
	for li := 0; li < grid.len; li += 1 {
		line := grid[li]
		if line.all(it == '.') {
			expansions << Coordinate{li, 0}
		}
	}
	for ci := 0; ci < grid[0].len; ci += 1 {
		if grid.map(it[ci]).all(it == '.') {
			expansions << Coordinate{0, ci}
		}
	}
	// println(expansions)
	// println(grid)
	// println('---------------')

	// Collect galaxies
	mut galaxies := []Coordinate{}
	for ri, row in grid {
		for ci, c in row {
			if c == '#' {
				galaxies << Coordinate{ri, ci}
			}
		}
	}
	// println('Galaxies: ${galaxies}')

	mut distances := [][]i64{len: galaxies.len, init: []i64{len: galaxies.len, init: i64(-1)}}
	for i in 0 .. galaxies.len {
		for j in i .. galaxies.len {
			dist := galaxies[i].distance_to_expanded(galaxies[j], expansions, args.expand_size)
			distances[i][j] = dist
			distances[j][i] = dist
		}
	}
	// println(galaxies.map('${it.y:2},${it.x:-2}').join(' | '))
	// println('-'.repeat((galaxies.len * 7) + 6))
	// println(' ' + distances.map(it.map('${it:3}').join('  |  ')).join('\n '))

	// Find shortest path
	shortest_path_sum := arrays.sum(distances.map(arrays.sum(it)!))! / 2
	return shortest_path_sum
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/11.txt' }
	}
	println('Reading input: ${inputfile}')
	lines := os.read_lines(inputfile)!

	if os.args.len >= 3 {
		match os.args[2] {
			'1' { println(part01(lines)!) }
			'2' { println(part02(lines, Part2Args{})!) }
			else { println('Unknown part specified') }
		}
	} else {
		mut sw := new_stopwatch()
		println(part01(lines)!)
		println('Part 01 took: ${sw.elapsed().microseconds()}us')
		sw.restart()
		println(part02(lines, Part2Args{})!)
		println('Part 02 took: ${sw.elapsed().milliseconds()}ms')
	}
}
