#!/usr/bin/env nu

# Advent of Code 2024 Day 2 A
def main [input: path] {
  let is_sorted = { ($in | sort -r) == $in or ($in | sort) == $in }
  let is_valid = { $in | window 2 | all {|w| ($w.0 - $w.1 | math abs) in 1..3 } }

  open $input
  | lines
  | par-each { split words | into int } 
  | where $is_sorted
  | where $is_valid
  | length
}
