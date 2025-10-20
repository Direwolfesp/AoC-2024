#!/usr/bin/env nu

# Advent of Code 2024 Day 2 B
def main [input: path] {
  let is_sorted = {|l| ($l | sort -r) == $l or ($l | sort) == $l }

  let is_valid = {|l|
    $l | window 2 | all {|w| ($w.0 - $w.1 | math abs) in 1..3 }
  }

  let is_tolerable = {|l| 0..<($l | length)
      | each { |i| $l | reject $i } # generate sublists eliminating one item each
      | where $is_sorted
      | where $is_valid
      | is-not-empty
  }

  open $input
  | lines
  | par-each { split words | into int } 
  | where {|l| (do $is_sorted $l) and (do $is_valid $l) or (do $is_tolerable $l)}
  | length
}
