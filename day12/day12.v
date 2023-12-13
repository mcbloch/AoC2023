module main

import os
import time { new_stopwatch }
import math
import arrays
import regex

fn calculate_possibilities_for_offset(springs string, sizes []int, t [][]int, multiplier int, nosplit bool) i64 {
	println('springs: ${springs}')
	println('sizes: ${sizes}')
	println('T: ${t}')
	combs := arrays.reduce(t.map(it.len), fn (acc int, el int) int {
		return acc * el
	}) or { 0 }
	println('local combs: ${combs}')
	mut options := i64(0)
	mut pointers := []int{len: sizes.len, init: 0}
	mut memoization := map[string]i64{}
	mut options_cache := []i64{len: sizes.len, init: 0}
	for {
		mut skip_an_idx := false
		mut skip_idx := 0
		// println('---')
		// println(pointers)
		// println(memoization)
		// println(options_cache)

		mut valid_option := true
		// offset_window := arrays.window(arrays.map_indexed(pointers, fn [t] (idx int, elem int) int {
		// 	return t[idx][elem]
		// }), size: 2)

		// if nosplit && multiplier > 0 {
		// 	outer: for i := 0; i < multiplier; i += 1 {
		// 		section_len := (springs.len - multiplier + 1) / multiplier
		// 		default_start := (i * section_len) + i
		// 		default_end := default_start + section_len

		// 		for j := 0; j < sizes.len / multiplier; j += 1 {
		// 			le_idx := ((i*(sizes.len / multiplier)) + j)
		// 			if t[le_idx][pointers[le_idx]] < default_start || t[le_idx][pointers[le_idx]]+sizes[le_idx] > default_end {
		// 				valid_option = false
		// 				break outer
		// 			}
		// 		}
		// 	}
		// }

		// i -> rightmost non zero
		significant_id := arrays.index_of_last(pointers, fn (idx int, elem int) bool {
			return elem != 0
		})
		if significant_id >= 0 {
			le_id := '${significant_id}-${pointers[significant_id]}'
			if le_id in memoization {
				// println('Used cached value ${le_id} - ${memoization[le_id]}')
				options += memoization[le_id]
				skip_an_idx = true
				skip_idx = significant_id
				valid_option = false

				for i in 0..significant_id {
					options_cache[i] += memoization[le_id]
				}
			}
		}

		// If we have a dangling hashtag just in front of us, increment ourselves
		// THIS breaks memoization?
		for p_i, p in pointers {
			if p_i + 1 < pointers.len {
				from := t[p_i][p] + sizes[p_i]
				to := t[p_i + 1][pointers[p_i + 1]]
				if to > from && springs.substr(from, to).count('#') > 0 {
					skip_an_idx = true
					skip_idx = p_i
					valid_option = false
					break
				}
			}
		}

		if valid_option {
			mut seconds_before_first := -1
			for idx, elem in pointers {
				if idx < pointers.len - 1 {
					elem_0 := t[idx][elem]
					elem_1 := t[idx + 1][pointers[idx + 1]]
					if elem_0 + sizes[idx] >= elem_1 {
						seconds_before_first = idx
						break
					}
				}
			}
			if seconds_before_first != -1 {
				skip_an_idx = true
				skip_idx = seconds_before_first + 1
				valid_option = false
			}
		}

		if valid_option {
			// Check if all fixed # characters are mapped
			for ci, c in springs {
				if c == `#` {
					mut found := false
					for point_i, pointer in pointers {
						off := t[point_i][pointer]
						if off <= ci && off + sizes[point_i] >= ci {
							found = true
							break
						}
					}
					if !found {
						valid_option = false
						break
					}
				}
			}
		}
		// println('test 3')

		if valid_option {
			// mut result := []string{len: springs.len, init: '_'}
			// for pi, p in pointers {
			// 	for i in 0 .. sizes[pi] {
			// 		result[t[pi][p] + i] = 'x'
			// 	}
			// }
			// println('  pointers: ${pointers}')
			// println('   springs: ${springs}')
			// println('     match: ${result.join('')}')
			// println('')
			options += 1
			for i in 0 .. options_cache.len {
				options_cache[i] += 1
			}
		}
		// println(pointers)
		if skip_an_idx {
			id := '${skip_idx}-${pointers[skip_idx]}'
			value := options_cache[skip_idx]
			memoization[id] = value
			
			pointers[skip_idx] += 1
			options_cache[skip_idx] = 0
			for i := skip_idx + 1; i < pointers.len; i += 1 {
				pointers[i] = 0
				options_cache[i] = 0
			}
		} else {
			pointers[pointers.len - 1] += 1
			options_cache[pointers.len - 1] = 0
		}
		// println(pointers)
		for i := pointers.len - 2; i >= 0; i -= 1 {
			if pointers[i + 1] >= t[i + 1].len {
				// memoize
				id := '${i}-${pointers[i]}'
				value := options_cache[i]
				memoization[id] = value

				pointers[i + 1] = 0
				options_cache[i + 1] = 0
				pointers[i] += 1
				options_cache[i] = 0
			}
		}
		// println(pointers)
		if pointers.first() >= t.first().len {
			break
		}
		// println('---')
	}
	return options
}

fn solution(lines []string, multiplier int) !i64 {
	mut sum := i64(0)
	for line in lines {
		temp := line.split(' ')
		mut springs := temp[0]
		temp_sizes := temp[1].split(',').map(it.int())
		mut sizes := temp_sizes.clone()
		for _ in 0 .. multiplier - 1 {
			springs += '?' + temp[0]
			sizes << temp_sizes
		}

		println('${springs} - ${sizes}')

		mut t := arrays.map_indexed(sizes, fn [springs, sizes] (idx int, elem int) []int {
			offset := arrays.sum(sizes[..idx].map(it + 1)) or { 0 }
			offset_end := arrays.sum(sizes[idx + 1..].map(it + 1)) or { 0 }
			return []int{len: (springs.len - elem + 1 - offset - offset_end), init: index + offset}
		})
		// Yeet pointers that we can exclude upfront.
		// Some conditions are dependent on the combinations. They will be looked at in THE loop itself.

		// Remove offsets that place a spring on a .
		// Remove offsets whose surroundings are a #
		for pi, mut t_opts in t {
			mut delete_count := 0
			for so_i, spring_offset in t_opts.clone() {
				size := sizes[pi]
				offset_end := spring_offset + size
				if springs[spring_offset..spring_offset + size].contains('.')
					|| (spring_offset > 0 && springs[spring_offset - 1] == `#`)
					|| (offset_end < springs.len && springs[offset_end] == `#`) {
					t_opts.delete(so_i - delete_count)
					delete_count += 1
				}
			}
		}

		// Remove offsets that leave dangling # chars before the first spring.
		{
			mut delete_count := 0
			for off_i, offset in t[0].clone() {
				if springs.substr(0, offset).count('#') > 0 {
					t[0].delete(off_i - delete_count)
					delete_count += 1
				}
			}
		}
		// Same but at the end.
		{
			mut delete_count := 0
			for off_i, offset in t.last().clone() {
				if springs.substr(offset + sizes.last(), springs.len).count('#') > 0 {
					t[t.len - 1].delete(off_i - delete_count)
					delete_count += 1
				}
			}
			println(t)
		}
		// Find groups of # characters.
		// If the biggest groups match the biggest sizes, fit them.
		// hashtag_groups := springs.split_any('.?')
		// println(hashtag_groups)
		// hashtag_groups_idx := arrays.map_indexed(hashtag_groups, fn[hashtag_groups](idx int, elem string) []int {
		// 	so_i := arrays.sum(hashtag_groups[..idx].map(math.max(1, it.len))) or {0}
		// 	return [so_i, elem.len]
		// })
		// println(hashtag_groups_idx)
		query := '#+'
		mut re := regex.regex_opt(query) or { panic(err) }
		hashtag_groups := re.find_all(springs)
		// println(hashtag_groups)

		if hashtag_groups.len > 0 {
			group_sizes := arrays.chunk(hashtag_groups, 2).map(it[1] - it[0])
			group_size_counts := arrays.map_of_counts(group_sizes)
			// println(group_sizes)
			// println(group_size_counts)
			spring_size_counts := arrays.map_of_counts(sizes)
			if arrays.max(group_size_counts.keys())! == arrays.max(spring_size_counts.keys())! {
				max_size := arrays.max(group_size_counts.keys())!
				if spring_size_counts[max_size] == group_size_counts[max_size] {
					for pi, mut t_opts in t {
						size := sizes[pi]
						if size == max_size {
							t_opts.clear()
							t_opts << arrays.window(hashtag_groups, size: 1, step: 2).map(it[0])
						}
					}
				}
			}
		}

		// Remove offsets where spring is before previous spring or spring after next spring
		for {
			mut did_delete := false

			for pi, _ in t[..t.len - 1] {
				if t[pi][0] + 1 >= t[pi + 1][0] {
					t[pi + 1].delete(0)
					did_delete = true
					break
				}
			}
			if !did_delete {
				break
			}
		}
		for {
			mut did_delete := false

			for pi, _ in t[..t.len - 1] {
				if t[pi].last() >= t[pi + 1].last() - 1 {
					t[pi].delete(t[pi].len - 1)
					did_delete = true
					break
				}
			}
			if !did_delete {
				break
			}
		}

		println(t)
		comb_count := arrays.reduce(t.map(it.len), fn (acc int, elem int) int {
			return acc * elem
		})!
		println('Start with ${t.map(it.len)} options, total ${arrays.sum(t.map(it.len))}')
		println('This makes ${comb_count} combinations')

		// We can now split the problem.
		// There where the last offset of a spring is lower then the lowest offset of the next spring.
		mut problem_splits := []int{}
		problem_splits << 0
		for i in 1 .. t.len {
			if t[i - 1].last() + sizes[i - 1] < t[i].first() {
				problem_splits << i
			}
		}
		problem_splits << t.len
		println('splits: ${problem_splits}')
		mut options := []i64{}
		for range in arrays.window(problem_splits, size: 2) {
			mut t_new := t[range[0]..range[1]].clone()
			sizes_new := sizes[range[0]..range[1]].clone()
			offset_start := t[range[0]].first()
			last_so := math.max(range[0], range[1] - 1)
			offset_end := t[last_so].last() + sizes[last_so]
			springs_new := springs.substr(offset_start, offset_end)
			println('- ${t_new}')
			for mut row in t_new {
				for i, _ in row {
					row[i] -= offset_start
				}
			}
			nosplit := problem_splits.len == 2
			options << calculate_possibilities_for_offset(springs_new, sizes_new, t_new,
				multiplier, nosplit)
			println(' sub result: ${options.last()}')
		}
		println(options)
		if options.len > 0 {
			opts := arrays.reduce(options, fn (acc i64, el i64) i64 {
				return acc * el
			})!
			println(opts)
			sum += opts
		}

		println('=====')
		// sum += options
	}

	return sum
}

fn part01(lines []string) !i64 {
	return solution(lines, 1)
}

fn part02(lines []string) !i64 {
	return solution(lines, 5)
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/12.txt' }
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
