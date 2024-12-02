const std = @import("std");

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var file = std.fs.cwd().openFile("input.txt", .{}) catch unreachable;

    var buffer: [100000]u8 = undefined;
    const size = file.readAll(&buffer) catch unreachable;
    const input = buffer[0..size];

    var line_iter = std.mem.splitSequence(u8, input, "\n");

    var safe_count: usize = 0;

    while (line_iter.next()) |line| {
        var num_iter = std.mem.splitSequence(u8, line, " ");
        std.debug.print("parsing line \"{s}\"\n", .{line});
        if (isSafe(&num_iter)) safe_count += 1;
    }

    std.io.getStdOut().writer().print("{}", .{safe_count}) catch unreachable;
}

pub fn isSafe(iter: *std.mem.SplitIterator(u8, .sequence)) bool {
    var prev: i32 = -1;

    var is_increasing = true;
    var is_decreasing = true;

    return while (iter.next()) |num_string| {
        std.debug.print("parsing \"{s}\"\n", .{num_string});
        const num = std.fmt.parseInt(i32, num_string, 10) catch {
            std.debug.print("cannot parse \"{s}\"\n", .{num_string});
            continue;
        };

        if (prev == -1) {
            prev = num;
            continue;
        }

        if (@abs(prev - num) > 3 or @abs(prev - num) < 1) break false;
        //23 20 19 17 14
        if (num > prev) is_decreasing = false;
        if (num < prev) is_increasing = false;

        if (!is_increasing and !is_decreasing) break false;

        prev = num;
    } else if (prev == -1) false else true;
}
