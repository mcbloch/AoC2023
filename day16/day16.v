module main

import os { read_lines }
import time { new_stopwatch }
import arrays

enum Dir {
	up
	down
	right
	left
}

fn (d Dir) str() string {
	return match d {
		.up { '^' }
		.down { 'v' }
		.left { '<' }
		.right { '>' }
	}
}

struct Pos {
	row int
	col int
}

fn (p Pos) str() string {
	return '(${p.row}, ${p.col})'
}

fn (p Pos) + (p2 Pos) Pos {
	return Pos{p.row + p2.row, p.col + p2.col}
}

struct Beam {
	position  Pos
	direction Dir
}

fn (b Beam) str() string {
	return 'Beam[${b.position}, ${b.direction}]'
}

fn (b Beam) + (b2 Beam) Beam {
	return Beam{b.position + b2.position, b2.direction}
}

fn (d Dir) offset() Beam {
	return Beam{match d {
		.up { Pos{-1, 0} }
		.down { Pos{1, 0} }
		.right { Pos{0, 1} }
		.left { Pos{0, -1} }
	}, d}
}

fn (grid [][]u8) get(p Pos) u8 {
	return grid[p.row][p.col]
}

fn str(grid [][]u8, beams []Beam) string {
	mut grid_repr := grid.map(it.clone())

	for b in beams {
		if grid.get(b.position) == `.` {
			grid_repr[b.position.row][b.position.col] = b.direction.str().bytes()[0]
		}
	}

	return grid_repr.map(it.bytestr().split('').join(' ')).join('\n')
}

fn (beam Beam) step(grid [][]u8) []Beam {
	// println('${beam}')
	tile := grid[beam.position.row][beam.position.col]
	offsets := match tile {
		`|` {
			match beam.direction {
				.left { [Dir.down.offset(), Dir.up.offset()] }
				.right { [Dir.down.offset(), Dir.up.offset()] }
				else { [beam.direction.offset()] }
			}
		}
		`-` {
			match beam.direction {
				.up { [Dir.left.offset(), Dir.right.offset()] }
				.down { [Dir.left.offset(), Dir.right.offset()] }
				else { [beam.direction.offset()] }
			}
		}
		`/` {
			match beam.direction {
				.up { [Dir.right.offset()] }
				.down { [Dir.left.offset()] }
				.right { [Dir.up.offset()] }
				.left { [Dir.down.offset()] }
			}
		}
		`\\` {
			match beam.direction {
				.up { [Dir.left.offset()] }
				.down { [Dir.right.offset()] }
				.right { [Dir.down.offset()] }
				.left { [Dir.up.offset()] }
			}
		}
		else {
			[beam.direction.offset()]
		}
	}
	// println(offsets)
	return offsets.map(beam + it).filter(it.position.row >= 0 && it.position.col >= 0
		&& it.position.row < grid.len && it.position.col < grid[0].len)
}

fn part01(data []string) !int {
	grid := data.map(it.bytes())

	mut queue := []Beam{}
	mut done := []Beam{}
	queue << Beam{Pos{0, 0}, Dir.right}

	for (queue.len > 0) {
		beam := queue.pop()

		for new_beam in beam.step(grid) {
			// println(new_beam)
			if new_beam !in done {
				queue << new_beam
			}
		}

		done << beam
		// println('queue: ${queue}')
		// println('done:  ${done}')
		// println(str(grid, done))
	}

	return arrays.distinct(done.map((it.position.row * grid.len) + it.position.col)).len
}

fn part02(data []string) !int {
	grid := data.map(it.bytes())

	mut start_queue := []Beam{}
	for i in 0 .. data.len {
		start_queue << Beam{Pos{i, 0}, Dir.right}
		start_queue << Beam{Pos{i, data[0].len - 1}, Dir.left}
	}
	for i in 0 .. data[0].len {
		start_queue << Beam{Pos{0, i}, Dir.down}
		start_queue << Beam{Pos{data.len - 1, i}, Dir.up}
	}

	mut max_lumen := 0
	println('start queue of len: ${start_queue.len}')
	for start_beam in start_queue {
		mut queue := []Beam{}
		queue << start_beam
		mut done := []Beam{}
		for (queue.len > 0) {
			beam := queue.pop()

			for new_beam in beam.step(grid) {
				// println(new_beam)
				if new_beam !in done {
					queue << new_beam
				}
			}

			done << beam
			// println('queue: ${queue}')
			// println('done:  ${done}')
			// println(str(grid, done))
		}

		lumen := arrays.distinct(done.map((it.position.row * grid.len) + it.position.col)).len
		println('${start_beam} -> ${lumen}')
		if lumen > max_lumen {
			max_lumen = lumen
		}
	}
	return max_lumen
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/15.txt' }
	}
	println('Reading input: ${inputfile}')
	data := read_lines(inputfile)!

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
