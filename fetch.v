import os
import net.http

fn main() {
	aoc_cookie := $env('AOC_COOKIE')
	if aoc_cookie == '' {
		println('Please export your AdventOfCode session cookie as an environment variable to use this script.')
		println('> export AOC_COOKIE="12345..."')
		exit(1)
	}

	if os.args.len < 2 {
		println('Provide the day as argument. Example: v run fetch.v 02')
		exit(1)
	} else if os.args[1].len != 2 {
		println('The day should consist of 2 numbers. Examples: 07, 12, 23')
		exit(1)
	}
	day := os.args[1]

	cookies := {
		'session': aoc_cookie
	}
	s := http.fetch(url: 'https://adventofcode.com/2023/day/${day.int()}/input', cookies: cookies, verbose: true) or {
		println('ERROR ${err}')
		exit(1)
	}
	if s.status() != .ok {
		println('ERROR received http code ${s.status_code}')
		exit(1)
	}
	println('Fetched inputfile.')
	os.write_file('input/${day}.txt', s.body)!
	println('Saved file to input/${day}.txt')
}
