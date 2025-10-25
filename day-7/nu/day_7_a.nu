#!/usr/bin/env nu

use std/util repeat

# n = |{ "+", "-" }| = 2
# m = len(operands) - 1
# variations with repetitions = n^m = 2^m
def solve_equation [eq: record<res: int, operands: list<int>>] {
  "{+,*}"
  | repeat (($eq.operands | length) - 1)
  | str join
  | str expand
  | any {|comb|
    $eq.operands
    | skip 1
    | zip { $comb | split chars }
    | reduce --fold ($eq.operands | first) {|pair, acc|
      let val = $pair.0
      let op = $pair.1
      match $op {
        "+" => { $acc + $val },
        "*" => { $acc * $val },
        _ => { error make { msg: $"Wrong operand '($op)'" } }
      }
    }
    | $in == $eq.res
  }
}

def main [input: path] {
  let equations = open $input
    | lines 
    | par-each {
        let nums = split words | into int
        {
          res: ($nums | first),
          operands: [($nums | slice 1..)]
        }
    }
    | flatten

  let solutions = $equations
    | par-each {|eq| if (solve_equation $eq) { $eq } }
    | get res?

  if ($solutions | is-not-empty) {
    $solutions | math sum
  } else {
    print "No equations are valid."
  }
}
