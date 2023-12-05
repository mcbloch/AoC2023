module main

import os
import time
import math
import arrays

struct Range {
	start i64
	len   i64
}

pub fn (c Range) str() string {
	return 'Range{${c.start}, ${c.len}}'
}

pub fn (r Range) end() i64 {
	return r.start + r.len
}

struct Mapping {
	src i64
	dst i64
	len i64
}

type MappingMeta = map[string]string
type MappingData = map[string][]Mapping

fn parse_io(lines []string) ([]i64, MappingMeta, MappingData) {
	seeds := lines[0].split(': ')[1].split(' ').map(fn (s string) i64 {
		return s.i64()
	})
	mut mapping_meta := map[string]string{}
	mut mapping_data := map[string][]Mapping{}

	mut i := 2
	for i < lines.len {
		temp := lines[i].split_any('- ')
		src := temp[0]
		dest := temp[2]

		mapping_meta[src] = dest
		mapping_data[src] = []

		i += 1
		for {
			nums := lines[i].split(' ').map(it.i64())
			mapping_data[src] << Mapping{
				src: nums[1]
				dst: nums[0]
				len: nums[2]
			}

			i += 1
			if i >= lines.len || lines[i] == '' {
				i += 1
				break
			}
		}
	}

	return seeds, mapping_meta, mapping_data
}

fn part01(lines []string) !i64 {
	seeds, mapping_meta, mapping_data := parse_io(lines)
	mut min_location := i64(-1)

	for seed in seeds {
		mut current_name := 'seed'
		mut current_id := seed

		for (current_name in mapping_meta) {
			mut mapping_found := false
			for range in mapping_data[current_name] {
				if current_id >= range.src && current_id <= range.src + range.len {
					mapping_found = true
					current_name = mapping_meta[current_name]
					current_id = range.dst + (current_id - range.src)
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

fn find_destination_mappings(name string, source Range, mapping_meta MappingMeta, mapping_data MappingData) []Range {
	mut destination_mappings := []Range{}

	mut offset := i64(0)
	for offset < source.len {
		current_start := source.start + offset
		mut entry_found := false
		for entry in mapping_data[name] {
			distance := current_start - entry.src
			if (current_start >= entry.src) && (current_start < entry.src + entry.len) {
				destination_mappings << Range{
					start: entry.dst + (current_start - entry.src)
					len: math.min(source.len - offset, entry.len - distance)
				}
				entry_found = true
				break
			}
		}
		if !entry_found {
			next_value := arrays.min(mapping_data[name].map(it.src).filter(it > current_start)) or {
				-1
			}

			next_len := if next_value == -1 {
				source.len - offset
			} else {
				math.min(source.len - offset, next_value - current_start)
			}

			destination_mappings << Range{
				start: current_start
				len: next_len
			}
		}
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

	mut current_name := 'seed'
	for (current_name in mapping_meta) {
		for input_range in input_ranges {
			next_input_ranges << find_destination_mappings(current_name, input_range,
				mapping_meta, mapping_data)
		}
		input_ranges = next_input_ranges.clone()
		next_input_ranges.clear()
		current_name = mapping_meta[current_name]
	}

	return arrays.min(input_ranges.map(it.start))
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
