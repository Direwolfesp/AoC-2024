const std = @import("std");
const stdout = std.fs.File.stdout();

const N_LINES = 1000;

fn part_a(filepath: []const u8) !u32 {
    var file = try std.fs.cwd().openFile(filepath, .{});
    defer file.close();
    var line_buf: [128]u8 = undefined;
    var reader = file.readerStreaming(&line_buf);

    var list_l: [N_LINES]i32 = undefined;
    var list_r: [N_LINES]i32 = undefined;

    var n_lines: u64 = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        const space_beg = std.mem.indexOfScalar(u8, line, ' ');
        const space_end = std.mem.lastIndexOfScalar(u8, line, ' ');
        if (space_beg == null or space_end == null) break;

        list_l[n_lines] = try std.fmt.parseInt(i32, line[0..space_beg.?], 10);
        list_r[n_lines] = try std.fmt.parseInt(i32, line[space_end.? + 1 ..], 10);
        n_lines += 1;
    }

    std.mem.sort(i32, &list_l, {}, std.sort.asc(i32));
    std.mem.sort(i32, &list_r, {}, std.sort.asc(i32));

    var total: u32 = 0;

    for (0..n_lines) |i| {
        total += @abs(list_l[i] - list_r[i]);
    }

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
