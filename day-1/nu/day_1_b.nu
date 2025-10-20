#!/bin/env nu

# Advent of Code 2024 Day 1 Part B
def main [file: path] {
  let table = open $file
    | parse "{left}   {right}"
    | into int left right 

  let uniq_right = $table.right | uniq --count 
  mut res = 0

  for n in $table.left {
    $res += $n * ($uniq_right
      | where value == $n
      | get count.0?
      | default 0)
  }
  $res
}

