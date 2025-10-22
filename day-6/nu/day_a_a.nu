#!/usr/bin/env nu

use std/log

let GUARD_POS = [ '>', '<', 'v', '^' ]
let SPACE = '.'
let SOLID = '#'

# converts the ascii guard to record that holds the direction
def char_to_dir [pos: string]: nothing -> record<i: int, j: int> {
  match $pos {
    '>' => { i:  0, j:  1},
    'v' => { i:  1, j:  0},
    '<' => { i:  0, j: -1},
    '^' => { i: -1, j:  0},
  }
}

# rotates direction 90º right
def rotate_pos [pos: record<i: int, j: int>]: [
  nothing -> record<i: int, j: int>
] {
  match $pos {
    { i:  0, j:  1} => { i:  1, j:  0},
    { i:  1, j:  0} => { i:  0, j: -1},
    { i:  0, j: -1} => { i: -1, j:  0},
    { i: -1, j:  0} => { i:  0, j:  1},
  }
}

# advances input in `dir` direction
def advance_pos [dir: record<i: int, j: int>]: [
  record<i: int, j: int> -> record<i: int, j: int>
] {
  {i: ($in.i + $dir.i), j: ($in.j + $dir.j)}
}

def main [input: path] {
  let matrix = open $input
    | lines
    | split chars

  let ROWS = $matrix | length
  let COLS = $matrix | first | length 
  mut visited: list<string> = []

  log info "started traversing matrix"
  for i in 0..<$ROWS {
    let row = $matrix | get $i
    for j in 0..<$COLS {
      let pos = $row | get $j

      if $pos in $GUARD_POS {
        log info "found the guard"
        mut guard_pos = {i: $i, j: $j}
        mut guard_dir = char_to_dir $pos
        $visited ++= [ $"($guard_pos.i),($guard_pos.j)" ]

        loop {
          let next_i = $guard_pos.i + $guard_dir.i
          let next_j = $guard_pos.j + $guard_dir.j

          # its not safe to advance, stop
          if $next_i < 0 or $next_j < 0 or $next_i >= $ROWS or $next_j >= $COLS {
            break
          }

          # rotate 90º right if we face a solid, we dont advance
          # yet because we dont know if its safe
          if ($matrix | get $next_i | get $next_j) == $SOLID {
            $guard_dir = rotate_pos $guard_dir
            continue
          }

          # advance and register new position
          $guard_pos = $guard_pos | advance_pos $guard_dir
          $visited ++= [ $"($guard_pos.i),($guard_pos.j)" ]
        }
        log info "finished moving the guard"
        break
      }
    }
  }

  $visited
  | uniq
  | length 
}
