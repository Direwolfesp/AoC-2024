#!/usr/bin/env nu

const DIRS = [
  [ 1,  1], [ 1,  0], [0, -1],
  [-1,  1], [-1,  0], [0,  1],
  [-1, -1], [ 1, -1]
]

def worker [matrix: list<list<string>>, start_row: int, end_row: int] {
  let cols = $matrix | first | length
  let rows = $matrix | length
  mut res = 0

  for i in $start_row..<$end_row {
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
          }
        }
      }
    }
  }
  $res
}

def main [input: path]: [ nothing -> int ] {
  let matrix = open $input
    | lines
    | split chars

  let rows = $matrix | length
  let chunk_size = $rows / (nproc | into int) | math ceil # cpus
  mut indices = [[start end]; [null, null]]
  mut i = 0;

  while ($i < $rows) {
    let chunk_len = if ($i + $chunk_size) < $rows {
      $chunk_size
    } else {
      $rows - $i
    }
    $indices = $indices | append {start: $i, end: ($i + $chunk_len)}
    $i += $chunk_len;
  }

  $indices
  | where start != null
  | par-each {|i| worker $matrix $i.start $i.end }
  | math sum
}
