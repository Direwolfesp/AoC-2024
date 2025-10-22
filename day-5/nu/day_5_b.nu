#!/usr/bin/env nu

# A list is valid if each pair [b|a] either satisfies:
# -> [b|a] exists in the orderings
# -> [a|b] does not exist in the orderings
def main [input: path] {
  let contents = open $input | lines 

  let orderings = $contents
    | take while {|l| $l =~ "\\d|\\d"}
    | parse "{before}|{after}"
    | into int before after

  # Converts a list into a valid list.
  let make_valid = {|list|
    $list | sort-by -c {|b, a|
        (($orderings
        | where before == $b and after == $a
        | is-not-empty)
      or
       ($orderings
        | where before == $a and after == $b
        | is-empty))
    }
  }
    
  $contents
  | skip while {|l| ($l =~ '\d+\|\d+') or ($l | is-empty) }
  | each { from csv --noheaders | values | flatten }
  | par-each {|list|
    let new = do $make_valid $list
    if $new != $list { $new }
  }
  | reduce --fold 0 {|l, acc| $acc + ($l | get (($l | length) // 2))}
}
