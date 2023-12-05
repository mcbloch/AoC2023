module main

import os
import time
import math
// import datatypes
// import arrays

fn parse_io(lines []string) ([]i64, map[string]string, map[string][][]i64) {
	seeds := lines[0].split(': ')[1].split(' ').map(fn (s string) i64 {
		return s.i64()
	})
	mut mapping_meta := map[string]string{}
	mut mapping_data := map[string][][]i64{}

	mut i := 2
	for i < lines.len {
		temp := lines[i].split_any('- ')
		src := temp[0]
		dest := temp[2]

		// println('${src} -> ${dest}')
		mapping_meta[src] = dest
		mapping_data[src] = []

		i += 1
		for {
			mapping_data[src] << lines[i].split(' ').map(fn (s string) i64 {
				return s.i64()
			})

			i += 1
			if i >= lines.len || lines[i] == '' {
				i += 1
				break
			}
		}
	}
	// println(mapping_meta)
	// println(mapping_data)

	return seeds, mapping_meta, mapping_data
}

fn part01(lines []string) !i64 {
	seeds, mapping_meta, mapping_data := parse_io(lines)
	mut min_location := i64(-1)

	for seed in seeds {
		mut current_name := 'seed'
		mut current_id := seed

		for (current_name in mapping_meta) {
			// println('${current_name} ${current_id}')

			mut mapping_found := false
			for range in mapping_data[current_name] {
				dest_range_start := range[0]
				src_range_start := range[1]
				range_length := range[2]

				if current_id >= src_range_start && current_id <= src_range_start + range_length {
					mapping_found = true
					current_name = mapping_meta[current_name]
					current_id = dest_range_start + (current_id - src_range_start)
					break
				}
			}
			if !mapping_found {
				current_name = mapping_meta[current_name]
			}
		}

		if min_location == -1 || current_id < min_location {
			min_location = current_id
		}
	}

	return min_location
}

struct Range {
	start i64
	len   i64
}

pub fn (c Range) str() string {
	return 'Range{${c.start}, ${c.len}}'
}

struct Mapping {
	src   i64
	dst   i64
	range i64
}

fn find_destination_mappings(name string, source Range, mapping_meta map[string]string, mapping_data map[string][][]i64) []Range {
	mut destination_mappings := []Range{}

	mut offset := i64(0)
	for offset < source.len {
		// println('    ${source.start}, ${source.len}, ${offset}')
		// println('    search from ${source.start + offset} with len ${source.len - offset} until ${
		// source.start + source.len}')
		mut entry_found := false
		for entry in mapping_data[name] {
			// println('    entry: ${entry}')
			src_range_start := entry[1]
			range_length := entry[2]
			distance := source.start + offset - src_range_start
			if (source.start + offset >= src_range_start)
				&& (source.start + offset < src_range_start + range_length) {
				destination_mappings << Range{
					start: entry[0] + ((source.start + offset) - src_range_start)
					len: math.min(source.len - offset, entry[2] - distance)
				}
				entry_found = true
				// println('      matching entry')
				break
			}
		}
		if !entry_found {
			// Find the first next value
			mut next_value := i64(-1)
			for entry in mapping_data[name] {
				if (entry[1] > source.start + offset) && (next_value == -1 || entry[1] < next_value) {
					next_value = entry[1]
				}
			}
			next_len := if next_value == -1 {
				source.len - offset
			} else {
				math.min(source.len - offset, next_value - (source.start + offset))
			}

			destination_mappings << Range{
				start: source.start + offset
				len: next_len
			}
		}
		// println('    ${source.start + offset} -> ${destination_mappings.last().start}. for a range of ${destination_mappings.last().len} (rest: ${source.len - offset - destination_mappings.last().len})')
		// println('increase with ${destination_mappings.last().len}')
		offset += destination_mappings.last().len
	}
	return destination_mappings
}

fn part02(lines []string) !i64 {
	seeds, mapping_meta, mapping_data := parse_io(lines)
	mut input_ranges := []Range{}
	mut next_input_ranges := []Range{}

	for i := 0; i < seeds.len; i += 2 {
		input_ranges << Range{
			start: seeds[i]
			len: seeds[i + 1]
		}
	}
	// println(input_ranges)

	mut current_name := 'seed'
	for (current_name in mapping_meta) {
		// println('============')
		// println('type: ${current_name}')
		// println('with ranges: ${input_ranges}')
		for (input_ranges.len > 0) {
			input_range := input_ranges.pop()

			// println('  take range ${input_range}')
			dest_ranges := find_destination_mappings(current_name, input_range, mapping_meta,
				mapping_data)
			// println('    found destinations ${dest_ranges}')

			for dst_range in dest_ranges {
				next_input_ranges << dst_range
			}
		}
		// next_input_ranges = arrays.distinct(next_input_ranges)
		input_ranges = next_input_ranges.clone()
		next_input_ranges.clear()
		current_name = mapping_meta[current_name]
	}

	mut min_location := i64(-1)
	for range in input_ranges {
		if min_location == -1 || range.start < min_location {
			min_location = range.start
		}
	}

	return min_location
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/05.txt'
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
		sw := time.new_stopwatch()
		println(part01(lines)!)
		println('Part 01 took: ${sw.elapsed().microseconds()}us')

		sw2 := time.new_stopwatch()
		println(part02(lines)!)
		println('Part 02 took: ${sw2.elapsed().microseconds()}us')
	}
}
