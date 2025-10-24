#!/usr/bin/env nu

# n = |{ "+", "-" }| = 2
# m = len(operands) - 1
# combinations with repetitions = n^m = 2^m
def solve_equation [eq: record<res: int, operands: list<int>>] {
  let m = ($eq.operands | length) - 1

  0..<(2 ** $m)
  | enumerate
  | any {|comb| 
    # gather a list of operations
    let ops = $comb.item
      | format bits
      | str replace --all ' ' ''
      | if ($in | str length) < $m {
          fill --character '0' --width $m --alignment right
      } else {
          str substring ($m * -1)..
      }
      | str replace --all '1' '+'
      | str replace --all '0' '*'
      | split chars

    # zip the operands with the ops and do the math
    let res = $eq.operands
      | skip 1
      | zip {$ops}
      | reduce --fold ($eq.operands | first) {|pair, acc|
        let val = $pair.0
        let op = $pair.1
        match $op {
          "+" => { $acc + $val },
          "*" => { $acc * $val },
          _ => { error make { msg: $"Wrong operand '($op)'" } }
        }
      }
    $res == $eq.res
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
