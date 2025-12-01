package main

import "core:sort"
import "core:strconv"
import "core:strings"
import "core:os"
import "core:fmt"

split_line :: proc(line: string) -> (int, int) {
    num_l: int
    num_r: int
    ok: bool

    num_l, ok = strconv.parse_int(line[:strings.index_byte(line, ' ')])
    num_r, ok = strconv.parse_int(line[strings.last_index_byte(line, ' ') + 1:])
    return num_l, num_r
}

part_a :: proc(filepath: string) -> Maybe(int) {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        return nil
    }
    defer delete(data, context.allocator)

    list_l: [1000]int
    list_r: [1000]int
    num_count := 0

    it := string(data)
    for line in strings.split_lines(it, context.allocator) {
        if line == "" do break
        num_l, num_r := split_line(line)
        // fmt.printfln(">> ({},{})", num_l, num_r)
        list_l[num_count] = num_l
        list_r[num_count] = num_r
        num_count += 1
    }

    sort.quick_sort(list_l[:])
    sort.quick_sort(list_r[:])

    total := 0

    for i in 0..<num_count {
        total += abs(list_l[i] - list_r[i])
    }

    return total
}

main :: proc() {
    if len(os.args) != 2 {
        fmt.println("[!] missing filepath")
        return
    }

    fmt.println('>', part_a(os.args[1]))
}
