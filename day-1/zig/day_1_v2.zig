const std = @import("std");
const stdout = std.fs.File.stdout();
const N_LINES = 1000;

fn part_a(filepath: []const u8) !u32 {
    var file = try std.fs.cwd().openFile(filepath, .{});
    var file_buf: [16 * N_LINES]u8 = undefined;
    _ = try file.readAll(&file_buf);

    var list_l: [N_LINES]i32 = undefined;
    var list_r: [N_LINES]i32 = undefined;

    var window = std.mem.window(u8, &file_buf, 15, 14);
    for (0..N_LINES) |i| {
        const line = window.next().?;
        list_l[i] = try std.fmt.parseInt(i32, line[0..5], 10);
        list_r[i] = try std.fmt.parseInt(i32, line[8..13], 10);
    }

    std.mem.sort(i32, &list_l, {}, std.sort.asc(i32));
    std.mem.sort(i32, &list_r, {}, std.sort.asc(i32));

    var total: u32 = 0;
    for (list_l, list_r) |elem_l, elem_r| total += @abs(elem_l - elem_r);
    return total;
}

pub fn main() !void {
    if (std.os.argv.len != 2) {
        std.debug.print("[!] missing filepath\n", .{});
        return;
    }

    const filepath = std.mem.span(std.os.argv[1]);
    std.debug.print("> {d}\n", .{try part_a(filepath)});
}
