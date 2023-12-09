module main

import os
import time as tme { new_stopwatch }
import math
import arrays
import maps

fn part01(lines []string) !i64 {
	directions := lines[0].split('')
	// println(directions)

	mut nodes := map[string][]string{}
	for line in lines[2..] {
		lr := line.split('=')[1].trim_space().split_any('(,)')
		nodes[line.split('=')[0].trim_space()] = [lr[1].trim_space(),
			lr[2].trim_space()]
	}
	mut dir_i := 0
	mut curr_position := 'AAA'
	for (curr_position != 'ZZZ') {
		dir := directions[dir_i % directions.len]
		match dir {
			'L' { curr_position = nodes[curr_position][0] }
			'R' { curr_position = nodes[curr_position][1] }
			else {}
		}
		dir_i += 1
	}
	// println(nodes)
	return dir_i
}

struct Point {
	label string
	step  int
}

fn (p Point) str() string {
	return 'Point{label: ${p.label}, step: ${p.step}}'
}

fn part02(lines []string) !i64 {
	directions := lines[0].split('')

	mut nodes := map[string][]string{}
	for line in lines[2..] {
		lr := line.split('=')[1].trim_space().split_any('(,)')
		nodes[line.split('=')[0].trim_space()] = [lr[1].trim_space(),
			lr[2].trim_space()]
	}
	mut dir_i := 0
	mut curr_positions := []string{}
	mut final_positions := []string{}
	mut z_per_start := map[string][]Point{}
	for dir, _ in nodes {
		if dir[dir.len - 1] == `A` {
			curr_positions << dir
		}
		if dir[dir.len - 1] == `Z` {
			final_positions << dir
		}
	}
	// println(curr_positions)
	// println(final_positions)
	// println('')
	for start in curr_positions {
		mut curr_pos := start
		dir_i = 0
		z_per_start[start] = []Point{}
		for {
			dir := directions[dir_i % directions.len]
			match dir {
				'L' { curr_pos = nodes[curr_pos][0] }
				'R' { curr_pos = nodes[curr_pos][1] }
				else {}
			}
			dir_i += 1
			p := Point{
				label: curr_pos
				step: dir_i
			}
			if z_per_start[start].len > 0 {
				if p.label == z_per_start[start][0].label
					&& p.step % directions.len == z_per_start[start][0].step % directions.len {
					break
				}
			}
			if curr_pos[curr_pos.len - 1] == `Z` {
				z_per_start[start] << p
			}
			// println(z_per_start)
		}
	}

	zs := maps.to_array(z_per_start, fn (s string, ps []Point) []int {
		return ps.map(it.step)
	})
	mut zs_idx := zs.map(0)
	mut lowest_lcm := i64(0)
	outer: for {
		// println(zs)
		// println(zs_idx)
		mut temp_i := 2
		mut temp_lcm := math.lcm(zs[0][zs_idx[0]], zs[1][zs_idx[1]])
		// println(temp_lcm)
		for temp_i < zs.len {
			temp_lcm = math.lcm(temp_lcm, zs[temp_i][zs_idx[temp_i]])
			temp_i += 1
		}
		if lowest_lcm == 0 || temp_lcm < lowest_lcm {
			lowest_lcm = temp_lcm
		}

		for temp_j in 0 .. zs_idx.len {
			zs_idx[temp_j] = (zs_idx[temp_j] + 1) % zs[temp_j].len
			if zs_idx[temp_j] != 0 {
				break
			}
			if temp_j == zs_idx.len - 1 {
				break outer
			}
		}
	}
	return lowest_lcm
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/08.txt'
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
