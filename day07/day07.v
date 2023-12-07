module main

import os
import time as tme { new_stopwatch }
// import math
import arrays
// import maps

fn get_hand_strength(cards []string, enable_jokers bool) int {
	card_counts := arrays.map_of_counts(cards.filter(!enable_jokers || it != 'J'))
	j_count := if enable_jokers { arrays.map_of_counts(cards)['J'] } else { 0 }

	max_count := (arrays.max(card_counts.values()) or { 0 })
	mut count_counts := arrays.map_of_counts(card_counts.values())
	count_counts[max_count] -= 1
	count_counts[max_count + j_count] += 1

	return match true {
		// five of a kind
		count_counts[5] == 1 {
			6
		}
		// four of a kind
		count_counts[4] == 1 {
			5
		}
		// full house
		count_counts[3] == 1 && count_counts[2] == 1 {
			4
		}
		// three of a kind
		count_counts[3] == 1 {
			3
		}
		// two pair
		count_counts[2] == 2 {
			2
		}
		// one pair
		count_counts[2] == 1 {
			1
		}
		// high card
		else {
			0
		}
	}
}

// You cannot override a generic array. You can however define methods on an array of a custom type
struct Int {
	i int
}

fn (a []Int) map_indexed[T](anon_fn fn (int, Int) T) []T {
	return arrays.map_indexed(a, anon_fn)
}

fn (a []Int) sum() Int {
	return Int{arrays.sum(a.map(it.i)) or { 0 }}
}

fn solve(lines []string, card_order []string, enable_jokers bool) !i64 {
	hands := lines.map(it.split(' ')[0].split(''))
	bets := lines.map(it.split(' ')[1].int())
	strengths := hands.map(get_hand_strength(it, enable_jokers))

	mut sorted_strength := arrays.map_indexed(strengths, fn (idx int, elem int) []int {
		return [idx, elem]
	}).sorted_with_compare(fn [hands, card_order] (mut a []int, mut b []int) int {
		if a[1] < b[1] {
			return -1
		}
		if a[1] > b[1] {
			return 1
		}
		for i in 0 .. 5 {
			va := card_order.index(hands[a[0]][i])
			vb := card_order.index(hands[b[0]][i])
			if va < vb {
				return 1
			}
			if va > vb {
				return -1
			}
		}
		return 0
	})

	return sorted_strength
		.map(Int{bets[it[0]]})
		.map_indexed(fn (order int, bet Int) Int {
			return Int{(order + 1) * bet.i}
		})
		.sum().i
	// return arrays.sum(arrays.map_indexed(sorted_strength.map(bets[it[0]]), fn (order int, bet int) i64 {
	// 	return i64((order + 1) * bet)
	// }))
}

fn part01(lines []string) !i64 {
	card_order := ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']
	return solve(lines, card_order, false)
}

fn part02(lines []string) !i64 {
	card_order := ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']
	return solve(lines, card_order, true)
}

fn main() {
	inputfile := if os.args.len < 2 {
		'input/07.txt'
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
