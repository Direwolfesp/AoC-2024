#!/usr/bin/env nu

def main [input: path] {
  open $input
  | parse --regex "mul\\((?<x>\\d{1,3}),(?<y>\\d{1,3})\\)"
  | into int x y
  | each {|p| $p.x * $p.y}
  | math sum
}
