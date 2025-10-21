#!/bin/env -S nu --no-config-file --no-std-lib

# Advent of Code 2024 Day 1 Part B
def main [file: path] {
  let table = open $file
    | parse "{left}   {right}"
    | into int left right 

  let uniq_right = $table.right | uniq --count 

  # Normal for loop approach: 354ms +-10ms
  # mut res = 0
  # for n in $table.left {
  #   $res += $n * ($uniq_right
  #     | where value == $n
  #     | get count.0?
  #     | default 0)
  # }
  # $res

  # Reduce approach: 354ms +-10ms
  # $table.left | reduce --fold 0 {|n, acc|
  #   $acc + $n * ($uniq_right
  #     | where value == $n
  #     | get count.0?
  #     | default 0)
  # }
    
  # Parallel approach: 54ms +-3ms
  $table.left | par-each {|n|
    $n * ($uniq_right
      | where value == $n
      | get count.0?
      | default 0)
  }
  | math sum
}

