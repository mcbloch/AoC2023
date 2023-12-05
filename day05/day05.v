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
pub fn (m Mapping) str() string {
	return 'Mapping{src:${m.src}, dst:${m.dst}, len:${m.len}}'
}

pub fn (m Mapping) src_end() i64 {
	return m.src + m.len
}

type MappingMeta = map[string]string
type MappingData = map[string][]Mapping

fn parse_io(lines []string) ([]i64, MappingMeta, MappingData) {
	seeds := lines[0].split(': ')[1].split(' ').map(it.i64())
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

		for (lines[i] != '') {
			nums := lines[i].split(' ').map(it.i64())
			mapping_data[src] << Mapping{
				src: nums[1]
				dst: nums[0]
				len: nums[2]
			}

			i += 1
			if i >= lines.len {
				break
			}
		}

		// mapping_data[src].sort(a.src < b.src)
		i += 1
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
			for range in mapping_data[current_name] {
				if current_id >= range.src && current_id < range.src_end() {
					current_id = range.dst + (current_id - range.src)
					break
				}
			}
			current_name = mapping_meta[current_name]
		}

		if min_location == -1 || current_id < min_location {
			min_location = current_id
		}
	}

	return min_location
}

fn find_destination_mappings(source Range, map_entries []Mapping) []Range {
	mut destination_mappings := []Range{}
	mut offset := i64(0)
	for offset < source.len {
		current_start := source.start + offset
		mut entry_found := false
		for entry in map_entries {
			distance := current_start - entry.src
			if (current_start >= entry.src) && (current_start < entry.src_end()) {
				destination_mappings << Range{
					start: entry.dst + distance
					len: math.min(source.len - offset, entry.len - distance)
				}
				entry_found = true
				break
			}
		}
		if !entry_found {
			next_value := arrays.min(map_entries.map(it.src).filter(it > current_start)) or {
				source.end()
			}

			destination_mappings << Range{
				start: current_start
				len: next_value - current_start
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
			next_input_ranges << find_destination_mappings(input_range, mapping_data[current_name])
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
