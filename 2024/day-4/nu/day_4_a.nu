#!/usr/bin/env nu

def get_columns [] { $in | first | length }
def get_rows [] { $in | length }

const DIRS = [
  [ 1,  1], [ 1,  0], [0, -1],
  [-1,  1], [-1,  0], [0,  1],
  [-1, -1], [ 1, -1]
]

def main [input: path, --visual(-v)]: [ nothing -> int ] {
  let matrix = open $input
    | lines
    | split chars

  let rows = $matrix | get_rows 
  let cols = $matrix | get_columns 
  mut res = 0;
  mut coords: list<list<int>> = []

  for i in 0..<$rows {
    let row = $matrix | get $i
    for j in 0..<$cols {
      if ($row | get $j) == 'X' {
        for dir in $DIRS {
          let di = $dir.0
          let dj = $dir.1

          let di1 = $i + (1 * $di)
          let dj1 = $j + (1 * $dj)
          let di2 = $i + (2 * $di)
          let dj2 = $j + (2 * $dj)
          let di3 = $i + (3 * $di)
          let dj3 = $j + (3 * $dj)

          if (($di3 in 0..<$rows) and ($dj3 in 0..<$cols) 
            and (($matrix | get $di1 | get $dj1) == 'M')
            and (($matrix | get $di2 | get $dj2) == 'A')
            and (($matrix | get $di3 | get $dj3) == 'S')) {
            $res += 1
            $coords ++= [
              [$i, $j]
              [$di1, $dj1]
              [$di2, $dj2]
              [$di3, $dj3]
            ]
          }
        }
      }
    }
  }

  # Visual print of the results
  if $visual {
    for i in 0..<$rows {
      let row = $matrix | get $i
      for j in 0..<$cols {
        let c: string = $matrix | get $i | get $j
        if [$i, $j] in $coords {
          print -n $"(ansi red)($c)(ansi reset)"
        } else {
          print -n $"($c)"
        }
        if $j == ($cols - 1) { print "" }
      }
    }
  }
  
  $res
}
