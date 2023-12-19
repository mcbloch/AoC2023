module main

import os { read_file }
import time { new_stopwatch }
// import arrays { sum }
// import math { min }
import math

enum Action {
	accept
	reject
	send_to
}

struct Rule {
	part          u8
	comparator    u8
	compare_value int
	destination   string
	action        Action
}

fn (r Rule) str() string {
	return 'R(${r.part.ascii_str()} ${r.comparator.ascii_str()} ${r.compare_value} -> ${r.destination})'
}

struct Workflow {
	name  string
	rules []Rule
}

fn (w Workflow) str() string {
	return 'Wf[${w.name} | ${w.rules}]'
}

fn part01(data string) !int {
	parts := data.split('\n\n')
	workflows_raw := parts[0].split_into_lines().map(it.split_any('{,}'))
	// println(workflows_raw)
	mut workflows := map[string]Workflow{}
	for w in workflows_raw {
		rules_raw := w[1..]
		mut rules := []Rule{}
		for rraw in rules_raw {
			if rraw.contains(':') {
				rule_body := rraw[1..].split(':')
				action := match rule_body[1] {
					'A' { Action.accept }
					'R' { Action.reject }
					else { Action.send_to }
				}
				rules << Rule{
					part: rraw[0]
					comparator: rule_body[0][0]
					compare_value: rule_body[0][1..].int()
					destination: rule_body[1]
					action: action
				}
			} else {
				rules << Rule{
					part: ` `
					comparator: `E`
					compare_value: 0
					destination: rraw
					action: match rraw {
						'A' { Action.accept }
						'R' { Action.reject }
						else { Action.send_to }
					}
				}
			}
		}
		workflows[w[0]] = Workflow{
			name: w[0]
			rules: rules
		}
	}

	part_ratings_raw := parts[1].split_into_lines().map(it.split_any('{,}'))
	mut accepted_parts := []map[rune]int{}
	for part_rating_raw in part_ratings_raw {
		part_rating := {
			`x`: part_rating_raw[1].substr(2, part_rating_raw[1].len).int()
			`m`: part_rating_raw[2].substr(2, part_rating_raw[2].len).int()
			`a`: part_rating_raw[3].substr(2, part_rating_raw[3].len).int()
			`s`: part_rating_raw[4].substr(2, part_rating_raw[4].len).int()
		}
		mut workflow_name := 'in'

		outer: for {
			workflow := workflows[workflow_name]
			for rule in workflow.rules {
				op := match rule.comparator {
					`<` {
						fn (a int, b int) bool {
							return a < b
						}
					}
					`>` {
						fn (a int, b int) bool {
							return a > b
						}
					}
					`E` {
						fn (a int, b int) bool {
							return true
						}
					}
					else {
						panic('Unknown comparator in rule: ${rule}')
					}
				}
				if op(part_rating[rule.part], rule.compare_value) {
					match rule.action {
						.accept {
							accepted_parts << part_rating
							break outer
						}
						.reject {
							break outer
						}
						.send_to {
							workflow_name = rule.destination
							break
						}
					}
				}
			}
		}
	}
	mut sum := 0
	for acc in accepted_parts {
		for _, v in acc {
			sum += v
		}
	}

	return sum
}

struct RulePointer {
	w_name string
	r_idx  int
mut:
	reverse bool
}

fn (rp RulePointer) str() string {
	return 'RP(${rp.w_name} : ${rp.r_idx} ${rp.reverse})'
}

fn calculate_possibilities(workflow_name string, workflows map[string]Workflow, mut constraints []RulePointer) i64 {
	if workflow_name == 'in' {
		mut total := i64(1)

		for part in [`x`, `m`, `a`, `s`] {
			mut num_min := 1
			mut num_max := 4000
			for rp in constraints {
				rule := workflows[rp.w_name].rules[rp.r_idx]
				if rule.part != part {
					continue
				}

				if !rp.reverse {
					match rule.comparator {
						`<` { num_max = math.min(num_max, rule.compare_value - 1) }
						`>` { num_min = math.max(num_min, rule.compare_value + 1) }
						else {}
					}
				} else {
					match rule.comparator {
						`>` { num_max = math.min(num_max, rule.compare_value) }
						`<` { num_min = math.max(num_min, rule.compare_value) }
						else {}
					}
				}
			}
			total *= (num_max + 1 - num_min)
		}

		return total
	} else {
		// find the workflows going to this workflow
		mut sub_count := i64(0)
		for name, workflow in workflows {
			for rule_i_new, rule_new in workflow.rules {
				constraints << RulePointer{name, rule_i_new, true}

				if rule_new.destination == workflow_name {
					constraints[constraints.len - 1].reverse = false
					sub_count += calculate_possibilities(name, workflows, mut constraints)
					constraints[constraints.len - 1].reverse = true
				}
			}

			for _ in workflow.rules {
				constraints.pop()
			}
		}
		return sub_count
	}
}

fn part02(data string) !i64 {
	parts := data.split('\n\n')
	workflows_raw := parts[0].split_into_lines().map(it.split_any('{,}'))
	mut workflows := map[string]Workflow{}
	for w in workflows_raw {
		rules_raw := w[1..]
		mut rules := []Rule{}
		for rraw in rules_raw {
			if rraw.contains(':') {
				rule_body := rraw[1..].split(':')
				action := match rule_body[1] {
					'A' { Action.accept }
					'R' { Action.reject }
					else { Action.send_to }
				}
				rules << Rule{
					part: rraw[0]
					comparator: rule_body[0][0]
					compare_value: rule_body[0][1..].int()
					destination: rule_body[1]
					action: action
				}
			} else {
				rules << Rule{
					part: ` `
					comparator: `E`
					compare_value: 0
					destination: rraw
					action: match rraw {
						'A' { Action.accept }
						'R' { Action.reject }
						else { Action.send_to }
					}
				}
			}
		}
		workflows[w[0]] = Workflow{
			name: w[0]
			rules: rules
		}
	}

	mut total := i64(0)
	mut constraints := []RulePointer{}

	for name, workflow in workflows {
		for rule_i, rule in workflow.rules {
			constraints << RulePointer{name, rule_i, true}
			if rule.action == Action.accept {
				constraints.last().reverse = false
				total += calculate_possibilities(name, workflows, mut constraints)
				constraints.last().reverse = true
			}
		}
		for _ in workflow.rules {
			constraints.pop()
		}
	}

	return total
}

fn main() {
	inputfile := match true {
		os.args.len >= 2 { os.args[1] }
		else { 'input/19.txt' }
	}
	println('Reading input: ${inputfile}')
	data := read_file(inputfile)!

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
