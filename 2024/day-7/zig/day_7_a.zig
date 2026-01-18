const std = @import("std");

fn is_solvable(res: u64, acc: u64, nums: []const u32, depth: u32) bool {
    return if (depth == 0)
        res == acc
    else if (acc > res)
        false
    else
        is_solvable(res, acc + nums[0], nums[1..], depth - 1) or
            is_solvable(res, acc * nums[0], nums[1..], depth - 1);
}

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .init;
    defer std.debug.assert(gpa.deinit() == .ok);
    const alloc = gpa.allocator();

    const f_name: []const u8 = std.mem.span(std.os.argv[1]);
    const f = try std.fs.cwd().openFile(f_name, .{});
    defer f.close();

    const contents = try f.readToEndAlloc(alloc, std.math.maxInt(u32));
    defer alloc.free(contents);

    var sum: u64 = 0;
    var iter = std.mem.tokenizeScalar(u8, contents, '\n');

    while (iter.next()) |line| {
        var num_iter = std.mem.tokenizeAny(u8, line, ": ");
        const res = num_iter.next().?;
        const n_res = try std.fmt.parseInt(u64, res, 10);

        var nums: [16]u32 = undefined;
        var i: u32 = 0;

        while (num_iter.next()) |num| : (i += 1)
            nums[i] = try std.fmt.parseInt(u32, num, 10);

        if (is_solvable(n_res, 0, nums[0..i], i)) sum += n_res;
    }
    std.debug.print("Sol: {d}\n", .{sum});
}
