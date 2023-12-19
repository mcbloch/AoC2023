module main

import os { read_file }
import time { new_stopwatch }
import arrays { sum }
// import math { min }

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
	// for _, w in workflows {
	// 	println(w)
	// }
	// println('=========')
	// println(workflows)

	part_ratings_raw := parts[1].split_into_lines().map(it.split_any('{,}'))
	mut accepted_parts := []map[rune]int{}
	for part_rating_raw in part_ratings_raw {
		part_rating := {
			`x`: part_rating_raw[1].substr(2, part_rating_raw[1].len).int()
			`m`: part_rating_raw[2].substr(2, part_rating_raw[2].len).int()
			`a`: part_rating_raw[3].substr(2, part_rating_raw[3].len).int()
			`s`: part_rating_raw[4].substr(2, part_rating_raw[4].len).int()
		}
		// println(part_rating)
		mut workflow_name := 'in'

		outer: for {
			workflow := workflows[workflow_name]
			// println(workflow)
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
							// println('ACCEPT')
							break outer
						}
						.reject {
							// println('REJECT')
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
	// println('')
	// println(accepted_parts)
	mut sum := 0
	for acc in accepted_parts {
		for _, v in acc {
			sum += v
		}
	}
	// return arrays.sum(accepted_parts.map(arrays.sum(it.values())))

	return sum
}

struct RulePointer {
	w_name  string
	r_idx   int
	reverse bool
}

fn (rp RulePointer) str() string {
	return 'RP(${rp.w_name} : ${rp.r_idx} ${rp.reverse})'
}

fn compare_constraint(c Rule, a int, reverse bool) bool {
	result := match c.comparator {
		`<` { a < c.compare_value }
		`>` { a > c.compare_value }
		`E` { true }
		else { panic('Unknown comparator') }
	}
	if reverse {
		return !result
	} else {
		return result
	}
}

fn calculate_possibilities(workflow_name string, rule_i int, workflows map[string]Workflow, constraints []RulePointer) i64 {
	// println(workflow_name)
	if workflow_name == 'in' {
		// println(constraints)
		mut total := i64(1)

		for part in [`x`, `m`, `a`, `s`] {
			mut nums := []int{len: 4000, init: index + 1} 
			for rp in constraints {
				rule := workflows[rp.w_name].rules[rp.r_idx]
				if rule.part != part {
					continue
				}

				nums = nums.filter(compare_constraint(rule, it, rp.reverse))
			}
			total *= nums.len

			// mut local_amount := 0
			// for i in 1 .. 4001 {
			// 	if constraints.filter(workflows[it.w_name].rules[it.r_idx].part == part).all(compare_constraint(workflows[it.w_name].rules[it.r_idx],
			// 		i, it.reverse))
			// 	{
			// 		local_amount += 1
			// 	}
			// }
			// println('${part} -> ${local_amount}')
			// total *= local_amount
		}
		// println('${total}')

		return total
	} else {
		// find the workflows going to this workflow
		mut sub_count := i64(0)
		for name, workflow in workflows {
			for rule_i_new, rule_new in workflow.rules {
				if rule_new.destination == workflow_name {
					mut new_cs := constraints.clone()
					for i in 0 .. rule_i_new {
						new_cs << RulePointer{name, i, true}
					}
					new_cs << RulePointer{name, rule_i_new, false}
					sub_count += calculate_possibilities(name, rule_i_new, workflows, new_cs)
				}
			}
		}
		return sub_count
	}
	return 0
}

fn part02(data string) !i64 {
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

	// for _, w in workflows {
	// 	println(w)
	// }
	// println('=========')

	mut total := i64(0)
	mut constraints := []RulePointer{}
	for name, workflow in workflows {
		for rule_i, rule in workflow.rules {
			if rule.action == Action.accept {
				mut cs := constraints.clone()
				for i in 0 .. rule_i {
					cs << RulePointer{name, i, true}
				}
				cs << RulePointer{name, rule_i, false}
				total += calculate_possibilities(name, rule_i, workflows, cs)
			}
		}
		// mut new_constraints = constraints.clone()
	}

	// recursive
	// for a workflow with an end, find the ranges to end
	// do recursive call on all workflows going to this workflow
	//    and request the possiblities to get here given some contraints.

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
