#!/usr/bin/env nu

def main [input: path] {
  let contents = open $input | lines 

  let orderings = $contents
    | take while {|l| $l =~ "\\d|\\d"}
    | parse "{before}|{after}"
    | into int before after

  # list = [B|A] is valid if:
  # -> the pair [B|A] exists
  # or
  # -> the pair [A|B] does not exist
  let is_valid = {|list|
    $list | window 2 | all {|win|
      (
        ($orderings
        | where before == $win.0 and after == $win.1
        | is-not-empty)
      or
       ($orderings
        | where before == $win.1 and after == $win.0
        | is-empty)
      )
    }
  }
    
  $contents
  | skip while {|l| ($l =~ '\d+\|\d+') or ($l | is-empty) }
  | each { from csv --noheaders | values | flatten }
  | par-each {|list| if (do $is_valid $list) { $list } }
  | reduce --fold 0 {|l, acc| $acc + ($l | get (($l | length) // 2))}
}

