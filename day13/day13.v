module main

import os
import time { new_stopwatch }
import math
import arrays
// import regex

fn str_grid(lines []string) string {
	header := []string{len: lines[0].len, init: (index + 1).str()}
	return '-'.repeat(lines[0].len) + '\n' + header.join('') + '\n' + lines.join('\n') + '\n' +
		'-'.repeat(lines[0].len)
}

fn part01(lines []string) !i64 {
	mut summarize_score := 0

	mut splits := [0]
	splits << arrays.map_indexed(lines, fn (idx int, elem string) []int {
		return [idx + 1, if elem.len == 0 { 1 } else { 0 }]
	}).filter(it[1] == 1).map(it[0])
	splits << [lines.len + 1]

	for pattern_range in arrays.window(splits, size: 2) {
		println(pattern_range)
		lines_local := lines[pattern_range[0]..pattern_range[1] - 1]
		println(str_grid(lines_local))

		println('test rows')
		for ri := 1; ri < lines_local.len; ri += 1 {
			a := lines_local[..ri].reverse()
			b := lines_local[ri..]
			compare_len := math.min(a.len, b.len)
			// println('Comparing strings for a len of ${compare_len}')
			// println('  ${a}')
			// println('  ${b}')
			if a[..compare_len] == b[..compare_len] {
				println('match')
				println(a[..compare_len])
				println(ri)
				summarize_score += (100* ri)
			}
		}


		println('test columns')
		for ci := 1; ci < lines_local[0].len; ci += 1 {
			mut a := []string{}
			mut b := []string{}
			for i := 0; i < math.min(ci, lines_local[0].len - ci); i += 1 {
				a << lines_local.map(it[ci - 1 - i]).bytestr()
				b << lines_local.map(it[ci + i]).bytestr()
			}
			compare_len := math.min(a.len, b.len)
			// println('Comparing strings for a len of ${compare_len}')
			// println('  ${a}')
			// println('  ${b}')
			if a[..compare_len] == b[..compare_len] {
				println('match')
				println(a[..compare_len])
				println(ci)

				summarize_score += ci
			}
		}
		println('')
	}

	return summarize_score
}

fn part02(lines []string) !i64 {
	mut summarize_score := 0

	mut splits := [0]
	splits << arrays.map_indexed(lines, fn (idx int, elem string) []int {
		return [idx + 1, if elem.len == 0 { 1 } else { 0 }]
	}).filter(it[1] == 1).map(it[0])
	splits << [lines.len + 1]

	for pattern_range in arrays.window(splits, size: 2) {
		println(pattern_range)
		lines_local := lines[pattern_range[0]..pattern_range[1] - 1]
		println(str_grid(lines_local))

		println('test rows')
		for ri := 1; ri < lines_local.len; ri += 1 {
			a := lines_local[..ri].reverse()
			b := lines_local[ri..]
			compare_len := math.min(a.len, b.len)
			// println('Comparing strings for a len of ${compare_len}')
			// println('  ${a}')
			// println('  ${b}')


			mut diff_count := 0
			for couple in arrays.group[string](a[..compare_len], b[..compare_len]){
				// println('    ${couple}')
				for char_i in 0..couple[0].len {
					if couple[0][char_i] != couple[1][char_i]{
						diff_count += 1
					}
				}
			}
			// The smudge needs to appear in our mirroring.
			// Technically it could also occur in the ignore row or column but that's not what they want.
			if diff_count == 1 {
				println('match')
				summarize_score += ( 100* ri)
				break
			}
		}


		println('test columns')
		for ci := 1; ci < lines_local[0].len; ci += 1 {
			mut a := []string{}
			mut b := []string{}
			for i := 0; i < math.min(ci, lines_local[0].len - ci); i += 1 {
				a << lines_local.map(it[ci - 1 - i]).bytestr()
				b << lines_local.map(it[ci + i]).bytestr()
			}
			compare_len := math.min(a.len, b.len)
			// println('Comparing strings for a len of ${compare_len}')
			// println('  ${a}')
			// println('  ${b}')

			mut diff_count := 0
			for couple in arrays.group[string](a[..compare_len], b[..compare_len]){
				// println('    ${couple}')
				for char_i in 0..couple[0].len {
					if couple[0][char_i] != couple[1][char_i]{
						diff_count += 1
					}
				}
			}
			if diff_count == 1 {
				println('match')
				summarize_score += ci
				break
			}

			// if a[..compare_len] == b[..compare_len] {
			// 	println('match')
			// 	println(a[..compare_len])
			// 	println(ci)

			// 	summarize_score += ci
			// }
		}
		println('')
	}

	return summarize_score
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/13.txt' }
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
