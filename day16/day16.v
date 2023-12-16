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

fn (b Beam) move(d Dir) Beam {
	return match d {
		.up { Beam{b.position + Pos{-1, 0}, d} }
		.down { Beam{b.position + Pos{1, 0}, d} }
		.right { Beam{b.position + Pos{0, 1}, d} }
		.left { Beam{b.position + Pos{0, -1}, d} }
	}
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
	new_dirs := match grid.get(beam.position) {
		`|` {
			match beam.direction {
				.left { [Dir.down, Dir.up] }
				.right { [Dir.down, Dir.up] }
				else { [beam.direction] }
			}
		}
		`-` {
			match beam.direction {
				.up { [Dir.left, Dir.right] }
				.down { [Dir.left, Dir.right] }
				else { [beam.direction] }
			}
		}
		`/` {
			match beam.direction {
				.up { [Dir.right] }
				.down { [Dir.left] }
				.right { [Dir.up] }
				.left { [Dir.down] }
			}
		}
		`\\` {
			match beam.direction {
				.up { [Dir.left] }
				.down { [Dir.right] }
				.right { [Dir.down] }
				.left { [Dir.up] }
			}
		}
		else {
			[beam.direction]
		}
	}
	// println(offsets)
	return new_dirs.map(beam.move(it)).filter(it.position.row >= 0 && it.position.col >= 0
		&& it.position.row < grid.len && it.position.col < grid[0].len)
}

fn part01(data []string) !int {
	println(data.len)
	grid := data.map(it.bytes())
	mut grid_passed := [][]int{len: data.len, init: []int{len: data[0].len, init: 0}}

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

		grid_passed[beam.position.row][beam.position.col] = 1
		done << beam
		// println('queue: ${queue}')
		// println('done:  ${done}')
		// println(str(grid, done))
	}

	return arrays.sum(grid_passed.map(arrays.sum(it) or { 0 })) or { 0 }
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
		else { 'input/16.txt' }
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
